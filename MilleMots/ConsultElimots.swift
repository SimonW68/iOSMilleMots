//
//  Soup.swift
//  MilleMots
//
//  Created by Simon Wintz on 13/12/2024.
//
import Foundation
import SwiftSoup

class ConsultElimots : ObservableObject {
    @Published var elimot : Elimot = Elimot()
    
    func getDef(mot: String, completion:@escaping (Elimot) -> ()) {
        guard let url = URL(string: "https://elimots.com/ods?mot=\(mot)") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let html = String(data: data!, encoding: .utf8) else {
                self.elimot.message = "Erreur de lecture du dictionnaire."
                return
            }
            do {
                let doc : Document = try SwiftSoup.parse(html)
                if let infosMot = try doc.getElementById("infosMot") {
                    let motDic = try infosMot.getElementsByTag("b")[1].text()
                    let inf = try infosMot.text()
                    self.parseInfosMot(motDic: motDic, inf: inf)
                }
            } catch {
                self.elimot.message = "Mot non reconnu."
            }
            DispatchQueue.main.async {
                completion(self.elimot)
            }
        }.resume()
    }
    
    private func parseInfosMot(motDic: String, inf: String) {
        let defElimot =
            if let iStart = findIndex(of: "Définition : ", in : inf) {
                if let iEnd = findIndex(of: "🕒", in : inf) {
                    inf.prefix(upTo: iEnd).suffix(from: iStart + "Définition : \(motDic)".count).trimmingCharacters(in: .whitespacesAndNewlines)
                } else { "" }
            } else { "" }
        let iso = findIndex(of: "(=", in: defElimot)
        let ieo = (iso != nil) ? findIndex(of: ")", in: defElimot.suffix(from: iso! + 2)) : nil
        var ort = (iso != nil) ? defElimot.suffix(from: iso! + 2).prefix(upTo: ieo!).trimmingCharacters(in: .whitespacesAndNewlines).removeDiacritics() : ""
        if let iVirg = findIndex(of: ",", in: ort) {
            ort = String(ort.prefix(upTo: iVirg))
        }
        let longOrt = ort.split(separator: " ").filter { $0.count > LONGUEUR_MOT_MAX }
        var def = ort.isEmpty ? defElimot : defElimot.prefix(upTo: iso!) + (String(defElimot.last!) != ")" ? (defElimot.suffix(from: iso! + 2).suffix(from: ieo! + 2)) : "")
        var premMot = (motDic.contains(",") ? motDic.prefix(upTo: findIndex(of: ",", in: motDic)!) : motDic)
        if premMot.contains("(S\')") {
            premMot = premMot.prefix(upTo: findIndex(of: "(", in: premMot)!)
            def = "(S\') " + def
        }
        if premMot.contains("(SE)") {
            premMot = premMot.prefix(upTo: findIndex(of: "(", in: premMot)!)
            def = "(SE) " + def
        }
        if !longOrt.isEmpty {
            def = "(=" + longOrt.joined(separator: " ") + ") " + def
        }
        let mots = (premMot + (ort.isEmpty ? "" : " " + ort)).removeDiacritics()
        self.elimot.def = def
        self.elimot.motDic = motDic
        self.elimot.defElimots = defElimot
        self.elimot.mots = mots.split(separator: " ").filter { $0.count <= LONGUEUR_MOT_MAX }.joined(separator: " ")
    }
}




