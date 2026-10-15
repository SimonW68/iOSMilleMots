//
//  HelpFiltres.swift
//  MilleMots
//
//  Created by Simon Wintz on 28/07/2024.
//

import Foundation
import SwiftUI

struct HelpFiltres: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            List {
                VStack {
                    Text("Signification des Symboles")
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .dynamicTypeSize(.xxLarge)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                    HStack {
                            Text("M")
                            .font(.custom("Chalkduster", size: 16))
                            .dynamicTypeSize(.xLarge)
                            .fontWeight(.bold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color("fondvert"))
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(20.0)
                            .overlay(
                                RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
                        Text("Filtre les monomes (mots sans anagrammes)")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    HStack {
                        HStack (spacing: 6) {
                            ForEach (4..<8) { number in
                                Text("\(number)")
                                    .bold()
                                    .dynamicTypeSize(.xxxLarge)
                            }
                        }
                        .padding(4)
                        .background(Color("fondvert"))
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        .cornerRadius(20.0)
                        .overlay(
                            RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))

                    Text("definit une plage de longueur de mots")
                        .frame(maxWidth: .infinity)
                    }
            
                    HStack {
                        Text(FL_DROITE)
                            .pastille(color: Color("fondvert"))
                        Text(POINTS_SUSP)
                            .pastille(color: Color("fondvert"))
                        Text("Définit si le premier élément du filtre est un préfixe ou pas")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    HStack {
                        Text(FL_GAUCHE)
                            .pastille(color: Color("fondvert"))
                        Text(POINTS_SUSP)
                            .pastille(color: Color("fondvert"))
                        Text("Définit si le dernier élément du filtre est un suffixe ou pas")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    
                    HStack {
                        Text(ET)
                            .pastille(color: Color("fondvert"))
                        Text(OU)
                            .pastille(color: Color("fondvert"))
                        Text("Définit l'opérateur logique à appliquer quand il y a plusieurs éléments (\(ET) = ET \(OU) = OU)")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    
                    HStack {
                        Text(FOCUS)
                            .dynamicTypeSize(.xLarge)
                            .frame(width: 30, height: 30)
                        Text("Indique le point d'insertion de la prochaîne lettre à saisir")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    
                    HStack {
                        Text(CANCEL)
                            .dynamicTypeSize(.xLarge)
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            .background(Color("fondLettre"))
                            .overlay(
                                RoundedRectangle(cornerRadius:6).stroke(Color("bordLettre"), lineWidth: 2))
                        Text("Efface le filtre en cours de la fenêtre de saisie")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    
                    HStack {
                        Text(BACKSPACE)
                            .dynamicTypeSize(.xLarge)
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            .background(Color("fondLettre"))
                            .overlay(
                                RoundedRectangle(cornerRadius:6).stroke(Color("bordLettre"), lineWidth: 2))
                        Text("Efface la dernière saisie (Retour arrière)")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    
                    HStack {
                        Text(NEXT)
                            .dynamicTypeSize(.xLarge)
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            .background(Color("fondLettre"))
                            .overlay(
                                RoundedRectangle(cornerRadius:6).stroke(Color("bordLettre"), lineWidth: 2))
                        Text("Avance le point d'insertion d'un cran")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    
                    HStack {
                        Text(DOUBLE_NEXT)
                            .dynamicTypeSize(.xLarge)
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            .background(Color("fondLettre"))
                            .overlay(
                                RoundedRectangle(cornerRadius:6).stroke(Color("bordLettre"), lineWidth: 2))
                        Text("Avance le point d'insertion de deux crans")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    
                    HStack {
                        Text(RETURN)
                            .dynamicTypeSize(.xLarge)
                            .frame(width: 30, height: 30)
                            .cornerRadius(5)
                            .background(Color("fondLettre"))
                            .overlay(
                                RoundedRectangle(cornerRadius:6).stroke(Color("bordLettre"), lineWidth: 2))
                        Text("Valide le filtre en cours")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    
                    HStack {
                        Text("Σ 53")
                            .foregroundStyle(Color.black)
                            .sigmaBorder(apply: true)
                        Text("Indique le nombre de mots de votre base (hors mots acquis) retenus par le filtre")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    
                    HStack {
                        Text("Σ 250")
                            .foregroundStyle(Color("vert"))
                            .background(Color("fondbleu"))
                            .sigmaBorder(apply: false)
                        Text("Indique le nombre de mots admis retenus par le filtre et absent de votre base et permet d'en afficher la liste.")
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                    }
                    
                    HStack {
                        Image("exercice")
                            .resizable(resizingMode: .stretch)
                            .frame(width: BTN_SIZE, height: BTN_SIZE)
                        Text("Lancer une séquence de jeu sur la totalité du filtre en cours")
                        Spacer()
                    }
                    
                    HStack {
                        Image("trash")
                            .resizable(resizingMode: .stretch)
                            .frame(width: BTN_SIZE, height: BTN_SIZE)
                        Text("Annuler le filtre en cours (y compris plage de longueur)")
                        Spacer()
                    }
                    
                    HStack {
                        Image("save_filtre")
                            .resizable(resizingMode: .stretch)
                            .frame(width: BTN_SIZE, height: BTN_SIZE)
                        Text("Enregistrer le filtre en cours")
                        Spacer()
                    }
                }
                .padding(10)
                .listRowBackground(Color("fondbleufonce"))
                .listRowInsets(.init(top:0, leading:6, bottom:6, trailing:6))
                .background(Color("fondbleu"))
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(20.0)
                .overlay(
                    RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
                
                VStack {
                    Text("Principes de Base")
                        .dynamicTypeSize(.xxLarge)
                        .fontWeight(.bold)
                        .padding(10)
                    Text("Composez un filtre en définissant une plage de longueur de mots puis en saisissant les éléments du filtre, comme dans les exemples suivants :")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicTypeSize(.xSmall)
                    Spacer()
                    HStack (spacing: 6) {
                        Text("Filtre")
                            .padding(4)
                            .frame(width: 100)
                            .bold()
                            .background(Color("fondbleu"))
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(6.0)
                            .overlay(
                                RoundedRectangle(cornerRadius:6.0).stroke(.black, lineWidth: 1))
                        Text("\(DOUBLE_NEXT)")
                        Text("Garde les mots qui :")
                            .bold()
                        Spacer()
                    }
                    HStack (spacing: 6) {
                        Text(POINTS_SUSP + "K" + POINTS_SUSP)
                            .padding(4)
                            .frame(width: 100)
                            .background(Color("fondbleu"))
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(6.0)
                            .overlay(
                                RoundedRectangle(cornerRadius:6.0).stroke(.black, lineWidth: 1))
                        Text("\(DOUBLE_NEXT)")
                        Text("contiennent K")
                        Spacer()
                           
                    }
                    HStack (spacing: 6) {
                        Text("K" + POINTS_SUSP)
                            .padding(4)
                            .frame(width: 100)
                            .background(Color("fondbleu"))
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(6.0)
                            .overlay(
                                RoundedRectangle(cornerRadius:6.0).stroke(.black, lineWidth: 1))
                        Text("\(DOUBLE_NEXT)")
                        Text("commencent par K")
                        Spacer()
                    }
                    
                    HStack (spacing: 6) {
                        Text("\(ET) K\(POINTS_SUSP) \(POINTS_SUSP)L\(POINTS_SUSP)")
                            .padding(4)
                            .frame(width: 100)
                            .background(Color("fondbleu"))
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(6.0)
                            .overlay(
                                RoundedRectangle(cornerRadius:6.0).stroke(.black, lineWidth: 1))
                        Text("\(DOUBLE_NEXT)")
                        Text("commencent par K et contiennent L")
                        Spacer()
                    }
                    
                    HStack (spacing: 6) {
                        Text("\(OU) \(POINTS_SUSP)K\(POINTS_SUSP) \(POINTS_SUSP)Y\(POINTS_SUSP)")
                            .padding(4)
                            .frame(width: 100)
                            .background(Color("fondbleu"))
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(6.0)
                            .overlay(
                                RoundedRectangle(cornerRadius:6.0).stroke(.black, lineWidth: 1))
                        Text("\(DOUBLE_NEXT)")
                        Text("contiennent K ou Y")
                        Spacer()
                    }
                    HStack (spacing: 6) {
                        Text("\(POINTS_SUSP)EUR")
                            .padding(4)
                            .frame(width: 100)
                            .background(Color("fondbleu"))
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(6.0)
                            .overlay(
                                RoundedRectangle(cornerRadius:6.0).stroke(.black, lineWidth: 1))
                        Text("\(DOUBLE_NEXT)")
                        Text("finissent par EUR")
                        Spacer()
                    }
                    HStack (spacing: 6) {
                        Text("\(POINTS_SUSP)K\(POINTS_SUSP)K\(POINTS_SUSP)")
                            .padding(4)
                            .frame(width: 100)
                            .background(Color("fondbleu"))
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .cornerRadius(6.0)
                            .overlay(
                                RoundedRectangle(cornerRadius:6.0).stroke(.black, lineWidth: 1))
                        Text("\(DOUBLE_NEXT)")
                        Text("contiennent au moins deux K")
                        Spacer()
                    }
                    Spacer()
                    Text("§1. Plage de longueur de mots")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                    Text("Faîtes glisser les deux extrémités du cartouche sur la plage de chiffres (de 3 à 9) pour définir la longueur mini et la longueur maxi des mots à garder.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicTypeSize(.xSmall)
                    Spacer()
                    Text("§2. Filtre")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)

                    Text("Saisissez les lettres à l'aide du clavier. Pour ajouter un groupe de lettres séparé du précédent par des points de suspension et un espace, utilisez \(DOUBLE_NEXT). Pour ajouter un groupe de lettre séparé par des points de suspension sans espace, utilisez \(NEXT). Si vous saisissez des groupes de lettres sans espaces à l'aide de \(NEXT), l'ordre d'apparition des éléments sera conservé dans les mots retenus.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicTypeSize(.xSmall)
                    Spacer()
                    Text("§3. Préfixe")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                    Text("Si vous souhaitez ne retenir que les mots qui commencent par le premier groupe de lettres du filtre, cliquez sur les points de suspension \(POINTS_SUSP) qui s'affichent à gauche de la fenêtre de saisie. Une flèche \(FL_DROITE) s'affiche à la place des points de suspension et l'option préfixe est appliquée. (Les points de suspensions en début de ligne sont supprimés).")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicTypeSize(.xSmall)
                    Spacer()
                    Text("§4. Suffixe")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                    Text("Si vous souhaitez ne retenir que les mots qui finissent par le dernier groupe de lettres du filtre, cliquez sur les points de suspension \(POINTS_SUSP) qui s'affichent à droite de la fenêtre de saisie. Une flèche \(FL_GAUCHE) s'affiche à la place des points de suspension et l'option suffixe est appliquée. (Les points de suspensions en fin de ligne sont supprimés).")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicTypeSize(.xSmall)
                    Spacer()
                    Text("§5. Opérateur logique \(ET) - \(OU) (ET - OU)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                    Text("Si vous mettez plusieurs groupe de lettres dans le filtre, vous pouvez choisir quel opérateur logique appliquer. L'opérateur \(ET) retiendra les mots qui remplissent chacun des critères alors que l'opérateur \(OU) retiendra tous les mots qui remplissent au moins un des critères.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicTypeSize(.xSmall)
                    Spacer()
                    Text("§6. Résultats")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                    Text("Dès que vous validez un filtre par \(RETURN), le clavier virtuel disparaît et le résultat s'affiche en trois colonnes. En-dessous sont affichés les nombres Σ correspondant à la taille de chaque liste : en noir à droite, les mots de votre base (hors mots acquis) et en vert à gauche tous les autres mot admis. Pour afficher la liste des mots admis cliquez sur le chiffre vert. De là, si vous cliquez sur un des mots de la liste en vert, vous avez la possibilité d'ajouter directement ce mot à votre base. Si vous cliquez sur un mot en noir, le détail du mot s'affichera et vous pourrez l'éditer en cliquant dessus.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicTypeSize(.xSmall)
                    Spacer()
                    Text("§7. Excercices sur les filtres")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                    Text("Lorsque vous avez défini un filtre vous pouvez vous exercer dessus. Si vous choisissez la commande \"exercice\" vous passerez directement en revue la totalité des mots filtrés. Si vous enregistrez le filtre, une pastille rouge apparait pour marquer que le filtre est enregistré. Vous pouvez alors quitter le filtre et lancer des séquences aléatoires à partir de l'écran d'accueil. Dans les deux cas, les mots sur lesquels vous butez sont automatiquement réactivés.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicTypeSize(.xSmall)
                    Spacer()
                }
                .padding(10)
                .listRowBackground(Color("fondbleufonce"))
                .listRowInsets(.init(top:0, leading:6, bottom:0, trailing:6))
                .background(Color("fondbleu"))
                .scrollContentBackground(.hidden)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(20.0)
                .overlay(
                    RoundedRectangle(cornerRadius:20).stroke(.black, lineWidth: 1))
                
                Button() {
                    self.dismiss()
                } label:{
                    Image("quitter")
                        .resizable(resizingMode: .stretch)
                        .frame(width: BTN_SIZE, height: BTN_SIZE)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .listRowBackground(Color("fondbleufonce"))
            }
            .navigationBarBackButtonHidden()
            .clipped()
            .listStyle(PlainListStyle())
            .listStyle(.grouped)
            .background(Color("fondbleufonce"))
        }
    }
}
