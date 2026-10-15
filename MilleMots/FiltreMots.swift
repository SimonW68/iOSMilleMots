//
//  BaseMotsFiltres.swift
//  MilleMots
//
//  Created by Simon Wintz on 31/10/2025.
//

import Foundation
import SwiftUI
import CoreData

struct FiltreMots: View {
    @Binding var odsAffiche: Ods9?
    @Binding var motPresse: Mot?
    @State var fetchCount: Int = 0
    @State var seuilNErr: Int = 0
    @State var horsDelai: Bool = false
    @AppStorage(USER_nTirages) var nTirages : Int = DEFAULT_nTirages
    @EnvironmentObject var com: Com
    @FetchRequest private var mots: FetchedResults<Mot>
    @Environment(\.managedObjectContext) private var viewContext

    init(
        predicate: NSPredicate,
        sortDescriptors: [NSSortDescriptor],
        odsAffiche: Binding<Ods9?>,
        motPresse: Binding<Mot?>,
    ) {
        let request: NSFetchRequest<Mot> = Mot.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        _mots = FetchRequest<Mot>(fetchRequest: request)
        self._odsAffiche = odsAffiche
        self.seuilNErr = 0
        self._motPresse = motPresse
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) { // listes de mots
            LazyVGrid(columns:[GridItem(.adaptive(minimum: LONG_MOT_9L))], alignment: .leading) {
                ForEach(mots.reversed(), id:\.self) { mot in
                    let font =
                        if mot.baseActive { FONT_ACTIF }
                        else if mot.motMort { FONT_ACQUIS }
                        else { FONT_INACTIF }
                    HStack {
                        let dotColor = if mot.nEchec > seuilNErr { Color.red } else if mot.nEchec > 0 { Color.orange } else { Color("vert") }
                        Circle()
                            .strokeBorder(.black, lineWidth: 1)
                            .fill(dotColor)
                            .frame(width: 8, height: 8)
                        Text(mot.refOds?.graphie ?? "")
                            .dynamicTypeSize(.xLarge)
                            .font(font)
                        Spacer()
                    }
                    .padding(6)
                    .onTapGesture(count: 1) {
                        odsAffiche = mot.refOds
                    }
                    .onTapGesture(count: 2) {
                        motPresse = mot
                    }
                }
                .onReceive(mots.publisher.collect()) { _ in
                    fetchCount = mots.count
                }
                .onChange(of: fetchCount, initial: true) {
                    com.totalFiltre = fetchCount
                    Task {
                        await getMotsATrouver()
                    }
                }
                .onChange(of:com.getMotsAtrouver) {
                    Task {
                        await getMotsATrouver()
                    }
                }
                .onChange(of: com.saveFile) {
                    transfDataToFile()
                }
                .onChange(of: horsDelai) {
                    horsDelai = false
                    if com.optionEnCours != .basique {
                        com.message = "Il semble qu'il n' y ait pas assez de mot pour appliquer l'option \(com.optionEnCours.rawValue). Elargissez votre filtre ou déactivez cette option."
                        com.optionEnCours = .basique
                    }
                }
            }
        }
    }

    private func getMotsATrouver() async {
        if !com.isInterro {
            com.preMotsAtrouver.removeAll()
            let dateLimite = Date.timeIntervalSinceReferenceDate + DELAI_RECHERCHE_MOTS
            if mots.count > nTirages {
                if com.optionEnCours == .motsProches {
                    if let randomMot = mots.randomElement() {
                        com.preMotsAtrouver.append(MotAtrouver(mot: randomMot))
                        repeat {
                            com.preMotsAtrouver.append(MotAtrouver(mot: nextMotProche()))
                        } while (com.preMotsAtrouver.count < nTirages)
                    }
                } else {
                    if !com.listeCorr.isEmpty {
                        com.preMotsAtrouver = com.listeCorr.map { $0.motCorrect }
                    }
                    repeat {
                        let randomMot = mots.randomElement()
                        if !(com.preMotsAtrouver.map{$0.mot}.contains(randomMot!)) {
                            if com.optionEnCours == .anagrammes {
                                if let ana = returnRandomAna(context: viewContext, mot: randomMot) {
                                    com.preMotsAtrouver.append(MotAtrouver(mot: randomMot!, tirage: ana))
                                }
                            } else if com.optionEnCours == .motPlusUn {
                                if let mpu = returnRandomMotPlusUn(context: viewContext, mot: randomMot) {
                                    com.preMotsAtrouver.append(MotAtrouver(mot: randomMot!, tirage: mpu))
                                }
                            } else {
                                com.preMotsAtrouver.append(MotAtrouver(mot:randomMot!))
                            }
                        }
                        horsDelai = Date().timeIntervalSinceReferenceDate > dateLimite
                    } while com.preMotsAtrouver.count < nTirages && !horsDelai
                    com.preMotsAtrouver.shuffle()
                }
                if com.preMotsAtrouver.count == nTirages {
                    DispatchQueue.main.async {
                        com.pret = true
                    }
                }
            }
        }
    }
    func nextMotProche() -> Mot {
        let lastMot = com.preMotsAtrouver.last!.mot!.refOds!.graphie!
        let distances = mots
            .filter { !com.preMotsAtrouver.map{$0.mot}.contains($0) }
            .map {(mot: $0, distance: levenshtein(Array(lastMot), Array($0.refOds!.graphie!)))}
            .sorted(by:{$0.distance < $1.distance})
        let distMini = distances.first!.distance
        return distances.filter {$0.distance == distMini}.map(\.mot).randomElement()!
    }
    // pour sauvegarder la requète en cours dans un fichier texte (voir aussi : com)
    private func transfDataToFile() {
        com.url = URL.documentsDirectory.appending(path: "Suggestions.txt")
        var outStr = ""
        mots.forEach { mot in
            let defMot = mot.definition
            let mots = (mot.definition!.graphies! as! Set<Mot>).map { $0.refOds!.graphie! }.joined(separator: " ")
            let newLine = "\(mots); \(defMot!.enonce!)\r\n"
            if !outStr.contains(newLine) { outStr.append(newLine) }
        }
        let data = Data(outStr.utf8)
        do {
            try data.write(to: com.url!, options:[.atomic, .completeFileProtection])
        } catch {
            print(error.localizedDescription)
        }
    }
}
