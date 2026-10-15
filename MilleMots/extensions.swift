//
//  Extensions.swift
//  MilleMots
//
//  Created by Simon Wintz on 29/07/2025.
//

import Foundation
import SwiftUI
import CoreData

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
extension Image {
    func btnStyle(_ size: CGFloat = BTN_SIZE) -> some View {
        self.resizable(resizingMode: .stretch)
            .frame(width: size, height: size)
    }
}
extension Int {
    func egal(_ a: Int) -> Bool {
        return self == a * Int(1 / TIMER_INTERVAL)
    }
    func sup(_ a: Int) -> Bool {
        return self > a * Int(1 / TIMER_INTERVAL)
    }
}
extension Mot {
    var orthoAltNet: String {
        self.orthoAlt.replacingOccurrences(of: PREFIX_ORT, with: "").replacingOccurrences(of: ", ", with: " ")
    }
    var orthoAlt: String {
        let set = self.definition!.graphies! as! Set<Mot>
        return if set.count > 1 {
            PREFIX_ORT + set.filter{ $0.refOds!.graphie != self.refOds!.graphie! }.map{ $0.refOds!.graphie! }.joined(separator: ", ")
        } else {
            ""
        }
    }
}
extension String {
    func dureeMessage() -> Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = self.components(separatedBy: chararacterSet)
        let wordCount = components.filter { !$0.isEmpty }.count
        return max(Int(Double(wordCount) * MESSAGE_SEC_PAR_MOT), MESSAGE_TIME_MINI)
    }
    func toText(_ size: Double = SMALL_BTN_SIZE) -> Text {
        if let image = UIImage(named: self),
           let newImage = convertImageToNewFrame(image: image, newFrameSize: CGSize(width: size, height: size)) {
            return Text(
                Image(uiImage: newImage)
            )
            .baselineOffset(-5.0)
        }
        return Text(Image(systemName: "heart.fill"))
    }
    func delPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    func delSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    func removeDiacritics() -> String {
        let userInput: String = self.replacingOccurrences(of: OE_COLLES, with: "OE").replacingOccurrences(of: AE_COLLES, with: "AE")
        return userInput.folding(options: .diacriticInsensitive, locale: .current)
    }
    func prefix(upTo: Int) -> String {
        let toIndex = self.index(startIndex, offsetBy: upTo)
        return String(self[..<toIndex])
    }
    func suffix(from: Int) -> String {
        let fromIndex = self.index(startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
    var etToNi: String {
        return self.replacingOccurrences(of: ET, with: NI)
    }
    var postTraitement: String {
        return self
            .replacingOccurrences(of: "n", with: SUFFIX_NI)
            .replacingOccurrences(of: "o", with: SUFFIX_OU)
            .replacingOccurrences(of: "e", with: SUFFIX_ET)
            .replacingOccurrences(of: "q", with: "Q sans U")
            .replacingOccurrences(of: "4" + DEUX, with: "4 lettres à 2 points")
            .replacingOccurrences(of: "4" + TROIS, with: "4 lettres à 3 points")
            .replacingOccurrences(of: "4" + QUATRE, with: "4 lettres à 4 points")
            .replacingOccurrences(of: "4d", with: "4 lettres à 10 points")
            .replacingOccurrences(of: "3" + DEUX, with: "3 lettres à 2 points")
            .replacingOccurrences(of: "3" + TROIS, with: "3 lettres à 3 points")
            .replacingOccurrences(of: "3" + QUATRE, with: "3 lettres à 4 points")
            .replacingOccurrences(of: "3d", with: "3 lettres à 10 points")
            .replacingOccurrences(of: "2" + DEUX, with: "2 lettres à 2 points")
            .replacingOccurrences(of: "2" + TROIS, with: "2 lettres à 3 points")
            .replacingOccurrences(of: "2" + QUATRE, with: "2 lettres à 4 points")
            .replacingOccurrences(of: "2d", with: "2 lettres à 10 points")
            .replacingOccurrences(of: DEUX, with: "une lettre à 2 points")
            .replacingOccurrences(of: TROIS, with: "une lettre à 3 points")
            .replacingOccurrences(of: QUATRE, with: "une lettre à 4 points")
            .replacingOccurrences(of: "d", with: "une lettre à 10 points")
            .replacingOccurrences(of: "v", with: "les lettres à plus qu'un point")
            .replacingOccurrences(of: "2", with: "deux ")
            .replacingOccurrences(of: "3", with: "trois ")
            .replacingOccurrences(of: "4", with: "quatre ")
            .replacingOccurrences(of: "  ", with: " ")
    }
    var filtreValide : Bool {
        guard !self.isEmpty else { return true }
        let sep = self.contains("o") ? "o" : "e"
        let strList = self.split(separator: sep)
        let suf = strList.last!
        return (String(self.last!) != sep && !LIST_234.contains(String(suf)) && strList.count(where: {$0 == suf}) < 2)
    }
    func cgSizeWidth(font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        return (self as NSString).size(withAttributes: attributes).width
    }
}
extension [String] {
    func chunked(prefix: String, font: UIFont, maxWidth: CGFloat) -> [[String]] {
        guard !self.isEmpty else { return [] }
        var result: [[String]] = []
        var i: Int = 0
        for j in 0..<self.count {
            let myArray = Array(self[i...j]) + (i == 0 ? [prefix] : [])
            if myArray.length(font: font) > maxWidth {
                result.append(Array(self[i...(j-1)]))
                i = j
            }
        }
        result.append(Array(self[i...(self.count-1)]))
        return result
    }
    
    func length(font: UIFont) -> CGFloat {
        let text = self.joined(separator: ", ")
        return text.cgSizeWidth(font: font)
    }
}
extension Text {
    func formatTouche(toucheSize: Double, isIndice: Bool) -> some View {
        self.dynamicTypeSize(.xLarge)
            .padding(.leading, isIndice ? 6 : 0)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(width: toucheSize, height: toucheSize)
            .background(Color("fondClair"))
            .cornerRadius(5)
    }
    
    func formatLettre(lettreSize: Double, isIndice: Bool) -> some View {
        self.dynamicTypeSize(.small)
            .padding(.leading, isIndice ? 3 : 0)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(width: lettreSize, height: lettreSize)
            .cornerRadius(5)
            .background(Color("fondLettre"))
            .overlay(
                RoundedRectangle(cornerRadius:5).stroke(Color("bordLettre"), lineWidth: 1))
    }
    
    func formatTuile(tuileSize: Double) -> some View {
        self
            .font(.system(size: tuileSize * 3.0 / 4.0, weight: .bold, design: .default))
            .frame(width:tuileSize, height:tuileSize)
            .cornerRadius(5)
            .background(Color("fondLettre"))
            .overlay(
                RoundedRectangle(cornerRadius:5).stroke(Color("bordLettre"), lineWidth: 2))
    }
}
extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
}
extension View {
    func pastille(color: Color) -> some View {
        self.padding(6)
            .dynamicTypeSize(.xxLarge)
            .background(color)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            .cornerRadius(6.0)
            .overlay(
                RoundedRectangle(cornerRadius:6.0).stroke(.black, lineWidth: 1))
    }
    func sigmaBorder(apply: Bool) -> some View {
        self.dynamicTypeSize(.xSmall)
            .frame(width: 50)
            .padding([.horizontal], 4)
            .padding([.vertical], 2)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: apply ? /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/ : 0)
            .cornerRadius(6.0)
            .overlay(RoundedRectangle(cornerRadius:6).stroke(.black, lineWidth: apply ? 1 : 0))
    }
    func formatMessage() -> some View {
        self.frame(maxWidth: .infinity)
            .padding(15)
            .background(Color("bleumarine"))
            .foregroundColor(.white)
            .dynamicTypeSize(.large)
    }
    func formatVue(_ color: String = "fondvert") -> some View {
        self.padding(DECALAGE_BORDURE)
            .background(Color(color))
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            .cornerRadius(12.0)
            .overlay(
                RoundedRectangle(cornerRadius:12).stroke(.black, lineWidth: 1))
    }
    func formatElementHelp(_ color: String = "fondvert") -> some View {
        self.padding(10)
            .listRowBackground(Color("fondbleufonce"))
            .listRowInsets(.init(top:0, leading:6, bottom:6, trailing:6))
            .background(Color("fondbleu"))
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            .cornerRadius(20.0)
            .overlay(
                RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
    }
}

// F U N C T I O N S
func coerce(n: Int) -> Int {
    return n < LONGUEUR_MOT_MIN ? LONGUEUR_MOT_MIN : n > LONGUEUR_MOT_MAX ? LONGUEUR_MOT_MAX : n
}
func combi(lettres: String, output: [String] = [], sofar: String = WILDCARD, n: Int) -> [String] {
    var current = output
    if n == 0 {
        current.append(sofar)
    } else {
        for lettre in lettres {
            let lettrePlusUn = sofar + String(lettre) + WILDCARD
            current = combi(lettres:lettres, output: current, sofar: lettrePlusUn, n: n - 1)
        }
    }
    return current
}
func convertImageToNewFrame(image: UIImage, newFrameSize: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(newFrameSize, false, 0.0)
    image.draw(in: CGRect(origin: .zero, size: newFrameSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
}
func findIndex(of string: String, in str: String) -> Int? {
   for (index, _) in str.enumerated() {
       var found = true
       for (offset, char2) in string.enumerated() {
           if str[str.index(str.startIndex, offsetBy: index + offset)] != char2 {
               found = false
               break
           }
       }
       if found {
           return index
       }
   }
   return nil
}
func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
}
func indexOfUpperCase(in str: String, after ind: Int) -> Int? {
   for (index, char) in str.enumerated() {
       if char.isUppercase && index > ind { return index }
   }
   return nil
}
func levenshtein(_ a:[Character], _ b:[Character]) -> Int {
    let m = a.count
    let n = b.count
    var T : [[Int]] = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
    
    for i in 0...m {
        T[i][0] = i
    }
    for j in 0...n {
        T[0][j] = j
    }
    var cost: Int
    for i in 1...m {
        for j in 1...n {
            cost = (a[i - 1] == b[j - 1]) ? 0 : 1
            T[i][j] = min(
                T[i - 1][j] + 1,
                T[i][j - 1] + 1,
                T[i - 1][j - 1] + cost
            )
        }
    }
    return T[m][n]
}
extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    }

    var appBuild: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "?"
    }
}
