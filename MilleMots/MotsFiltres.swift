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
    @State var seuilNErr: Int = 0
    @State var horsDelai: Bool = false
    @EnvironmentObject var com: Com
    @FetchRequest private var mots: FetchedResults<Mot>
    @Environment(\.managedObjectContext) private var viewContext

    init(
        predicate: NSPredicate,
        sortDescriptors: [NSSortDescriptor],
        odsAffiche: Binding<Ods9?>,
        motPresse: Binding<Mot?>
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
                        Text(mot.refOds!.graphie ?? "")
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
                .frame(maxWidth: 500)
                .onChange(of: com.getMotsAtrouver, initial: false) {
                    com.totalFiltre = mots.count
                    com.pret = false
                    print("pas pret")
                    Task {
                        await getMotsATrouver()
                    }
                }
                .onChange(of: com.saveFile) {
                    transfDataToFile()
                }
                .onChange(of: horsDelai) {
                    com.message = "Il semble qu'il n' y ait pas assez de mot pour appliquer l'option \(com.optionEnCours). Elargissez votre filtre ou déactivez cette option."
                    com.cancelAllOptions()
                    horsDelai = false
                }
            }
        }
    }

    private func getMotsATrouver() async {
        com.motsAtrouver.removeAll()
        let dateLimite = Date.timeIntervalSinceReferenceDate + DELAI_RECHERCHE_MOTS
        if com.totalFiltre > N_TIRAGES {
            if com.optionProches {
                if let randomMot = mots.randomElement() {
                    com.motsAtrouver.append(MotAtrouver(mot: randomMot))
                    repeat {
                        com.motsAtrouver.append(await MotAtrouver(mot: nextMotProche()))
                    } while (com.motsAtrouver.count < N_TIRAGES)
                }
            } else {
                if !com.listeCorr.isEmpty {
                    com.motsAtrouver = com.listeCorr.map { $0.motCorrect }
                }
                repeat {
                    let randomMot = mots.randomElement()
                    if !(com.motsAtrouver.map{$0.mot}.contains(randomMot!)) {
                        if com.optionAnagrammes {
                            if let ana = returnRandomAna(context: viewContext, mot: randomMot) {
                                com.motsAtrouver.append(MotAtrouver(mot: randomMot!, tirage: ana))
                            }
                        } else if com.optionMotPlusUn {
                            if let mpu = returnRandomMotPlusUn(context: viewContext, mot: randomMot) {
                                com.motsAtrouver.append(MotAtrouver(mot: randomMot!, tirage: mpu))
                            }
                        } else {
                            com.motsAtrouver.append(MotAtrouver(mot:randomMot!))
                        }
                    }
                    horsDelai = Date().timeIntervalSinceReferenceDate > dateLimite
                } while com.motsAtrouver.count < N_TIRAGES && !horsDelai
                com.motsAtrouver.shuffle()
            }
            if com.motsAtrouver.count == N_TIRAGES {
                com.pret = true
            }
        } else {
            com.cancelAllOptions()
        }
    }
    func nextMotProche() async -> Mot {
        let lastMot = com.motsAtrouver.last!.mot!.refOds!.graphie!
        let distances = mots
            .filter { !com.motsAtrouver.map{$0.mot}.contains($0) }
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
