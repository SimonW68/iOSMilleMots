//
//  Help.swift
//  MilleMots
//
//  Created by Simon Wintz on 29/04/2024.
//

import Foundation
import SwiftUI

struct Help: View {
    @AppStorage(USER_SEQ_SUCC) var seqSucc : Int = DEFAULT_SEQ_SUCC
    @AppStorage(USER_nTirages) var nTirages : Int = DEFAULT_nTirages
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                Text("Aide MilleMots - V.\(Bundle.main.appVersion) (\(Bundle.main.appBuild))")
                    .frame(maxWidth: .infinity, alignment: .top)
                    .dynamicTypeSize(.xLarge)
                    .fontWeight(.bold)
                    .padding(12)
                List {
                    VStack {
                        Text("Commandes Principales")
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .dynamicTypeSize(.xxLarge)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                        HStack {
                            Image("exercice")
                                .btnStyle()
                            Text("Démarrer une séquence de jeu")
                            Spacer()
                        }
                        HStack {
                            Image("dico")
                                .btnStyle()
                            Text("Rechercher un mot, pour éventuellement l'ajouter s'il n'est pas dans la base ou l'éditer s'il y est déjà.")
                            Spacer()
                        }
                        HStack {
                            Image("settings")
                                .btnStyle()
                            Text("Accéder à l'aide, aux utilitaires et aux paramètres.")
                            Spacer()
                        }
                        HStack {
                            Image("essence")
                                .btnStyle()
                            Text("Accéder aux listes de mots à réactiver pour consolidation, ou bien importés d'autres bases")
                            Spacer()
                        }
                        HStack {
                            IconeTri(ordreTri: .alpha)
                            Text("Choix de l'ordre de tri de la liste des mots (alphabétique, etc.)")
                            Spacer()
                        }
                        HStack {
                            Text("333")
                                .font(.caption)
                                .lineLimit(1)
                                .foregroundColor(Color("fondbleu"))
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.5))
                                        .frame(width: PASTILLE_COUNT_SIZE, height: PASTILLE_COUNT_SIZE)
                                )
                                .padding(.trailing, DECALAGE_BORDURE)
                            Text("Affichage toute la base ou seulement les mots actifs")
                            Spacer()
                        }
                        HStack {
                            Image("cible")
                                .btnStyle()
                            Text("Valider le mot présent sur la réglette")
                            Spacer()
                        }
                        HStack {
                            Image("loupe")
                                .btnStyle()
                            Text("Révéler la définition du mot à trouver")
                            Spacer()
                        }
                        HStack {
                            Image("classement_az")
                                .btnStyle()
                            Text("Remettre le tirage dans l'ordre alphabétique")
                            Spacer()
                        }
                        HStack {
                            Image("share")
                                .btnStyle()
                            Text("Partage de sa base avec d'autres utilisateurs / Sauvegarde")
                            Spacer()
                        }
                        HStack {
                            Image("backup")
                                .btnStyle()
                            Text("Sauvegarde de sa base de mots")
                            Spacer()
                        }
                        HStack {
                            Image("tri_feux")
                                .btnStyle()
                            Text("Indication du taux d'erreur cumulé sur un mot (rouge = mot difficile)")
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Text("Cliquez sur l'entête de la liste de mots (par défaut: \"Tous les mots de votre base active\") pour créer un filtre")
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Text("Quant un filtre est actif, balayez la liste de mots vers la droite pour faire apparaître la liste des mots hors-base (en vert).")
                            Spacer()
                        }
                        Spacer()
                    }
                    .dynamicTypeSize(.xSmall)
                    .listRowBackground(Color("fondbleu"))
                    VStack {
                        Text("Principes de Base")
                            .dynamicTypeSize(.xxLarge)
                            .fontWeight(.bold)
                            .padding(20)
                        Text("§1. Jeu (Exercice de mémorisation)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        Text("Effectuez des séquences de \(nTirages) interrogations aléatoires pour mémoriser les mots de votre base active. Lorsque vous trouvez un mot donné, \(seqSucc) fois consécutives (valeur réglable), celui-ci est désactivé. Vous pouvez alors ajouter d'autres mots à votre base pour maintenir un nombre constant de mots actifs (conseillé : 200 à 300)\n")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                        Text("§2. Ajouter un mot à votre base active")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        Text("Cliquez sur \("dico".toText()) pour rechercher le mot que vous souhaitez ajouter. Si le mot est déjà dans la base il apparaît en noir et vous pouvez l'éditer (cf.§4 ci-dessous), sinon il apparaît en vert (s'il est en rouge, vérifiez l'orthographe car cela signifie qu'il n'est pas reconnu). Si vous êtes en ligne, les détails du mot vont s'afficher et vous pourrez les modifier avant d'ajouter le mot à votre base active par l'icône \("ajouter".toText()).\n")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                        Text("§3. Alimenter votre base")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        Text("Vous pouvez entrer dans votre base les mots que vous rencontrez au cours de parties de Scrabble® par exemple. Si vous utilisez les applications Karnage ou Carnaj, vous pourrez ajouter directement dans MilleMots les mots que vous y découvrez (cf. section \("store".toText())).\nQuand vous aurez pratiqué MilleMots quelques temps, vous pourrez également choisir de réactiver des mots désactivés depuis un certain temps (C'est un excellent moyen de consolider sa mémoire). Pour cela, dans la section \("reglages".toText()) précisez si vous souhaitez réactiver plutôt les mots les plus anciens ou alors ceux qui vous on posé le plus de difficultés (taux d'erreur élevé).\nEnfin, vous pouvez charger une base de mots reçue d'un autre utilisateur de MilleMots (cf §8 ci-dessous). Les mots importés sont accessible par l'icône \("essence".toText()) et vous pouvez les ajouter à votre base au fur et à mesure de vos besoins.\n")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                        Text("§4. Edition d'un mot")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        Text("Cliquez sur \("dico".toText()) pour rechercher le mot que vous souhaitez éditer. Si le mot est bien présent dans la base il apparaît en noir et vous pouvez l'éditer : ajouter une graphie, éditer sa définition, ou changer son statut courant (actif, acquis). Puis vous enregistrez les modifications par l'icône \(RETURN).\nVous pouvez également le supprimer de votre base par l'icône \("trash".toText()).\n")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text("§5. Option de jeu")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        Text("""
                    Avant de démarrer une séquence de jeu, vous pouvez sélectionner un mode de jeu optionnel parmis les trois proposés:
                    - mots proches: les mots proposés sont le plus semblable possible les uns aux autres,
                    - anagramme : il faut retrouver le mot à partir d'une de ses anagrammes,
                    - mot-plus-un : retrouver le mot à partir d'un mot plus court et une lettre.
                    Pour l'option mots proches, il est préférable d'avoir une base de mot la plus étendue possible, donc d'afficher les mots inactifs de la base.\n
                    """)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicTypeSize(.xSmall)
                        Spacer()
                        Text("§6. Filtres")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        Text("""
                    En cliquant sur l'entête de la liste de mot qui par défaut affiche \"Tous les mots de votre base active\", vous pouvez construire un filtre qui permet d'appliquer des critères à votre liste de mots. Les critères applicables sont :\n
                    - la longueur : plage de longueur de mot de 3 à 9 lettres\n
                    - le préfixe (exemple : tous les mots commençant par K)\n
                    - le contenu (exemple : tous les mots contenant un Y et un Z)\n
                    - le suffixe (exemple : tous les mots se terminant par IDE)\n
                    - les exclusions (exemple : tous les mots qui ne comportent ni A ni E)\n
                    Pour les contenus et les exclusions, vous disposez de caractères génériques qui se réfèrent aux points des lettres du Scrabble® (exemple : lettre a 10 points, lettres à plus de 2 points, etc.) et des multiplicateurs (exemple: 3L pour les mots qui doivent contenir trois fois la lettre L)\n
                    Enfin, en sélectionnant l'option monômes : \("monomes".toText()) vous ne gardez que les mots qui ont zéro anagramme.\n
                    Lorsque vous avez défini un filtre, sa description s'affiche dans l'entête, la liste de mots est mise à jour et les séquences de jeux ultérieures sont basées sur ce filtre.\n
                    """)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicTypeSize(.xSmall)
                        Spacer()
                        Text("§7. Réglages")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        Text("""
                    Pour régler les paramètres suivant vos préférences cliquez sur \("reglages".toText()). Vous pourrez :\n
                    - choisir la séquence de succès (c'est le nombre de réponses exactes requises sur un mot pour qu'il soit désactivé),\n
                    - choisir la taille du lot de consolidations ou d'importations (voir §3 ci-dessus)\n
                    - désactiver l'option \"temps limité\" ou changer la durée allouée par mot\n
                    - persponnaliser le nom du fichier de partage (voir §8 ci-dessous).\n
                    """)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicTypeSize(.xSmall)
                        Spacer()
                        Text("§8. Partage de votre base de mots")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        Text("Vous pouvez partager votre base de mots par mèl avec un autre utilisateur, à l'aide de la commande \("export".toText()) dans la section \("share".toText()). De même, vous pouvez recevoir la base de mot d'un autre utilisateur, par mèl (en l'enregistrant dans le répertoire download de votre smartphone), à l'aide de la commande \("_import".toText()). Les mots reçus qui ne sont pas déjà présents dans votre base sont ajoutés au stock d'importations (cf. §3 ci-dessus).\n")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                        Text("§9. Sauvegarde de la base")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fontWeight(.bold)
                        Text("Dans le menu \("share".toText()) vous avez la possibilité d'effectuer une sauvegarde \("backup".toText()) de votre base de mots sous forme d'un fichier txt, pour pouvoir la recharger \("restaure".toText()) sur un autre appareil ou bien sur le même appareil, après ré-installation de l'application.\n")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .dynamicTypeSize(.xSmall)
                        Spacer()
                        
                    }
                    .listRowBackground(Color("fondbleu"))
                    DataPolicy()
                        .listRowBackground(Color("fondbleu"))
                    
                    InfoElimots()
                        .listRowBackground(Color("fondbleu"))
                }
                .listStyle(PlainListStyle())
                .background(Color("fondbleu"))
                .scrollContentBackground(.hidden)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(10.0)
                .overlay(
                    RoundedRectangle(cornerRadius:10).stroke(.black, lineWidth: 1))
                HStack {
                    Spacer()
                    Button() {
                        self.dismiss()
                    } label:{
                        Image("quitter")
                            .btnStyle()
                    }
                    Spacer()
                    NavigationLink(value: DataObject.init(name: "reglages")) {
                        Image("reglages")
                            .btnStyle()
                    }
                    Spacer()
                    NavigationLink(value: DataObject.init(name:"store")) {
                        Image("store")
                            .btnStyle()
                    }
                    Spacer()
                    NavigationLink(value: DataObject.init(name: "share")) {
                        Image("share")
                            .btnStyle()
                    }
                    Spacer()
                }
                .padding(12)
                .background(Color("fondbleufonce"))
            }
        }
        .navigationBarBackButtonHidden()
        .padding(DECALAGE_BORDURE)
        .background(Color("fondbleufonce"))
        .ignoresSafeArea(.keyboard, edges: .all)  
    }
}
