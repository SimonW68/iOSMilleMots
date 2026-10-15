//
//  Const.swift
//  MilleMots
//
//  Created by Simon Wintz on 29/07/2025.
//
import Foundation
import SwiftUI

// M I S E   E N   P A G E
let EP_FILET : Double = 1.0
let BTN_SIZE : CGFloat = 25.0
let SMALL_BTN_SIZE : CGFloat = 20.0
let LARGE_BTN_SIZE : CGFloat = 30.0
let PASTILLE_COUNT_SIZE : CGFloat = 40.0
let SMALL_ICON_SIZE : CGFloat = 20.0
let SELECTOR_SIZE : CGFloat = 40.0
let DECALAGE_BORDURE : Double = 6.0
let FONT_ACTIF : Font = Font.body.weight(.bold)
let FONT_INACTIF : Font = Font.body.weight(.regular)
let FONT_ACQUIS : Font = Font.body.weight(.light).italic()
let ENTRE_TOUCHES : CGFloat = DECALAGE_BORDURE
let GRD_ECRAN: CGFloat = 600
let PETIT_ECRAN: CGFloat = 350
let LONG_MOT_9L: CGFloat = 130
let LARG_COLONNE_GAUCHE: CGFloat = 45
let BLUR_RADIUS: CGFloat = 30
let LETTER_WIDTH: CGFloat = 9

// A N I M A T I O N S  /  T I M E R

let TIMER_TIME_COURT: Int = 30
let TIMER_TIME_LONG: Int = 60
let TIMER_INTERVAL: Double = 0.25 //s
let INHIB_TIME : Int = 1 //s
let WARNING_TIME : Int = 3 //s
let MESSAGE_TIME_MINI: Int = 2 //s
let MESSAGE_SEC_PAR_MOT = 0.3
let SNACK_TIME_SHORT = DispatchTimeInterval.seconds(2)
let SNACK_TIME_LONG = DispatchTimeInterval.seconds(5)
let BULLE_INFO_TIME = DispatchTimeInterval.seconds(8)
let DELAI_SORTIE = DispatchTimeInterval.seconds(1)
let TEMPS_INHIB = DispatchTimeInterval.seconds(1)
let TEMPS_HIDE_FILTRE_TOOL = DispatchTimeInterval.seconds(4)
let TEMPS_HIDE_OPTIONS = DispatchTimeInterval.seconds(2)
let DELAI_RECHERCHE_MOTS: Double = 2.0
let SWIPE_MINI: Double = 50.0

// P A R A M E T R E   D E   J E U
let FRACTION_ROUGE = 5
let LONGUEUR_MOT_MAX = 9
let LONGUEUR_MOT_MIN = 3
let N_MOTS_TAUX_SUCCES : Int = 1000

//F I L T R E S
let CANCEL = "\u{2573}"
let BACKSPACE = "\u{232B}"
let Q_SANS_U = "Qʉ"
let RETURN = "\u{2714}"
let ET = "et"
let OU = "ou"
let NI = "ni"
let SUFFIX_ET = ESPACE + ET + ESPACE
let SUFFIX_OU = ESPACE + OU + ESPACE
let SUFFIX_NI = ESPACE + NI + ESPACE
let ESPACE = "\u{0020}"
let VIDE = ""
let WILDCARD = "*"
let CLEAR = "\u{2327}"

let NON_VELOS = "\u{2082}\u{208A}"
let DEUX = "\u{2082}"
let TROIS = "\u{2083}"
let QUATRE = "\u{2084}"
let DIX = "\u{2081}\u{2080}"
let DEUX_FOIS = "2x"
let TROIS_FOIS = "3x"
let QUATRE_FOIS = "4x"
let LIST_234 = ["2","3","4"]

let LETTRES_A_1 : String = "AEILNORSTU"
let LETTRES_A_2 : String = "DGM"
let LETTRES_A_3 : String = "BCP"
let LETTRES_A_4 : String = "FHV"
let LETTRES_A_8 : String = "JQ"
let LETTRES_A_10 : String = "KWXYZ"
let LETTRES_PAS_VELOS = LETTRES_A_2 + LETTRES_A_3 + LETTRES_A_4 + LETTRES_A_8 + LETTRES_A_10

let CLAVIER_COMPLET = [
    [DEUX_FOIS, TROIS_FOIS, QUATRE_FOIS, NON_VELOS, DEUX, TROIS, QUATRE, DIX],
    ["A", "B", "C", "D", "E", "F", "G", BACKSPACE],
    ["H", "I", "J", "K", "L", "M", "N", "O"],
    ["P", "Q", Q_SANS_U, "R", "S", "T", "U", "V"],
    [CLEAR, "W", "X", "Y", "Z", OU, ET, RETURN]]

let MULTIPLES = [Q_SANS_U, NON_VELOS, DIX]
let GENERIQUES = ["v", DEUX, TROIS, QUATRE, "d"]
let MULTIPLICATEURS = [DEUX_FOIS, TROIS_FOIS, QUATRE_FOIS]
let NON_FORMATTES = ["o","e","2","3","4"]
let CODAGE : [String : String] = [
    OU : "o",
    ET : "e",
    Q_SANS_U : "q",
    NON_VELOS : "v",
    DIX : "d",
    DEUX_FOIS : "2",
    TROIS_FOIS : "3",
    QUATRE_FOIS : "4"
]
let DECODAGE : [String : String] = [
    "o" : SUFFIX_OU,
    "e" : SUFFIX_ET,
    "q" : Q_SANS_U,
    "v" : NON_VELOS,
    "d" : DIX,
    "2" : DEUX_FOIS,
    "3" : TROIS_FOIS,
    "4" : QUATRE_FOIS
]

let REQUETE_VIDE = NSPredicate(value: false)
let REQUETE_PLEINE = NSPredicate(value: true)
let REQUETE_BASE_ACTIVE : NSPredicate = NSPredicate(format: "baseActive == YES")
let REQUETE_PAR_DEFAUT : NSPredicate = NSPredicate(format: "motMort == NO")

// C O N S T A N T E S
let ALLOWED_CAR_NEW : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
let ALLOWED_CAR_EDIT : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
let ALPHABET = ALLOWED_CAR_EDIT
let ALLOWED_CAR_FILENAME = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_."
let ENTETE_SHAREFILE = "Fichier d'Echange MilleMots v1.0"
let VOYANT_ON = "\u{25CF}"
let VOYANT_OFF = "\u{25CB}"
let ETOILES = "\u{2728}"
let HOME = "\u{25C9}" // ◉
let LOUPE = "\u{1F50D}" //
let OE_COLLES = "\u{0152}"
let AE_COLLES = "\u{C6}"
let PREFIX_ORT = "= "
let PREFIX_ANA = "Ana : "
let PREFIX_EXT = "(+1) : "
let PREFIX_RAC = "(-1) : "
let PREFIX_VIRGULE_NLINE = ",\n"
let BACKUPFILE_NAME = "SauvegardeMilleMots.txt"
let BACKUPFOLDER_NAME = "Sauvegarde MilleMots"

// A P P S T O R A G E
let USER_SEQ_SUCC = "seq-succ"
let USER_nTirages = "n-tirages"
let USER_N_SUGG = "n-sugg"
let USER_RATIO_CONSO = "ratio-conso"
let USER_SHAREFILE_NAME = "share-file-name"
let USER_20_20_RECORD = "record-20-20"
let USER_AFFICHE_INACTIFS = "afficher-inactifs"
let USER_ORDER_TRI_BASE_MOTS = "ordre-tri-base-mots"
let FILTRE_STR_PREF = "str-pref"
let FILTRE_STR_SUF = "str-suf"
let FILTRE_STR_CONT = "str-cont"
let FILTRE_STR_EXCL = "str-excl"
let MONOMES_ONLY = "monomes-only"
let FILTRE_L_MAX = "l-max"
let FILTRE_L_MIN = "l-min"
let OPTION_RAPIDE = "option-rapide"
let BUG_AALENIEN = "bug-aalenien"

let DEFAULT_SEQ_SUCC = 5
let DEFAULT_nTirages = 20
let nTirages_MINI = 5
let DEFAULT_N_SUGG = 12
let DEFAULT_RATIO_CONSO = 5.0
let DEFAULT_SHAREFILE_NAME = "MaBaseDeMots.txt"
let DEFAULT_20_20_RECORD = 0
let CUR_OPTION = "current-option"

// S T O R E
let KARNAGE_NOM: String = "Karnage"
let KARNAGE_ID: String = "6748648624"
let KARNAGE_PITCH: String = "Cette version gratuite de Carnaj vous permet de tester le mode \"7 lettres avec conjuguaisons\" avec trois jokers pour vous défendre. Et un lien vers MilleMots qui vous permet d'ajouter les mots que vous découvrez, directement à votre base."

let MILLEMOTS_NOM: String = "MilleMots"
let MILLEMOTS_ID: String = "6504042068"
let MILLEMOTS_PITCH: String = ""

let CARNAJ_NOM: String = "Carnaj"
let CARNAJ_ID: String = "6736951673"
let CARNAJ_PITCH: String = "Version solo du célèbre Jarnac d'Emile Lombard, Carnaj est entièrement basé sur le Dictionnaire Officiel du Scrabble®. Vous jouez contre l'ordinateur qui est impitoyable, mais vous pouvez vous défendre en utilisant judicieusement vos Jokers. Vous pourrez tester plusieurs modes de jeux en choisissant la longueur des mots ou la possibilité de conjuguer les verbes. Avec un lien vers MilleMots pour ajouter tous les mots que vous découvrez, directement à votre base."
let MMLITE_NOM: String = "MilleMotsLite"
let MMLITE_ID: String = "6760645150"
let MMLITE_PITCH: String = "Pour Tester gratuitement le principe de MilleMots !"
