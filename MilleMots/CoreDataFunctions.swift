//
//  CoreDataFunctions.swift
//  MilleMots
//
//  Created by Simon Wintz on 02/05/2024.
//  Updated on 08/12/2024.
//

import Foundation
import CoreData

func totalBase(context: NSManagedObjectContext) -> Int {
    let request: NSFetchRequest<Mot> = Mot.fetchRequest()
    request.entity = Mot.entity()
    do {
        return try context.fetch(request).count
    } catch {
        return 0
    }
}
func totalCoups(context: NSManagedObjectContext) -> Int {
    let request: NSFetchRequest<Mot> = Mot.fetchRequest()
    request.entity = Mot.entity()
    do {
        return try context.fetch(request).map { Int($0.nEssai) }.reduce(0, +)
    } catch {
        return 0
    }
}
func tauxSucces(context: NSManagedObjectContext) -> Double {
    let request: NSFetchRequest<Mot> = Mot.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "nChrono", ascending: false)]
    request.entity = Mot.entity()
    do {
        let dernMots = try context.fetch(request).prefix(N_MOTS_TAUX_SUCCES)
        return  1.0 - Double(dernMots.map { Int($0.nEchec) }.reduce(0, +)) / Double(dernMots.map { Int($0.nEssai) }.reduce(0, +))
    } catch {
        return 0
    }
}

func clearAllMots(context: NSManagedObjectContext) {
    clearAllDefs(context: context)
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Mot")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try context.execute(deleteRequest)
    } catch let error as NSError {
        print("erreur de suppression des mots : \(error)")
    }
}
func clearAllDefs(context: NSManagedObjectContext) {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Definition")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
        try context.execute(deleteRequest)
    } catch let error as NSError {
        print("erreur de suppression des mots : \(error)")
    }
}

func returnRandomMotPlusUn(context: NSManagedObjectContext, mot: Mot?) -> String? {
    guard let mot = mot else {
        return nil
    }
    let graphie = mot.refOds!.graphie!
    var results: [String] = []
    for i in graphie.indices {
        var graphieMoinsUn = graphie
        let un = graphieMoinsUn.remove(at: i)
        if let result = estUnMot(context: context, spectre: String(graphieMoinsUn.sorted())) {
            if result + String(un) != graphie {
                results.append(result + String(un))
            }
        }
    }
    return results.isEmpty ? nil : results.randomElement()
}

func estUnMot(context: NSManagedObjectContext, spectre: String) -> String? {
    let request: NSFetchRequest<Ods9> = Ods9.fetchRequest()
    request.entity = Ods9.entity()
    request.predicate = NSPredicate(format: "spectre == %@", spectre)
    
    do {
        return try context.fetch(request).first?.graphie
    } catch {
        return nil
    }
}

func returnRandomAna(context: NSManagedObjectContext, mot: Mot?) -> String? {
    guard let mot = mot else {
        return nil
    }
    let spectre = mot.refOds!.spectre!
    let graphie = mot.refOds!.graphie!
    let req: NSFetchRequest<Ods9> = Ods9.fetchRequest()
    req.entity = Ods9.entity()
    var anas: [Ods9] = []
    do {
        req.predicate = NSPredicate(format: "spectre = %@ AND graphie != %@", spectre, graphie)
        anas = try context.fetch(req)
        return anas.isEmpty ? nil : anas.map(\.graphie!).randomElement()
    } catch {
        print("Erreur anagrammes")
        return nil
    }
}
func getAcc(context: NSManagedObjectContext,  mot: Mot?) -> Accessoires {
    guard let mot = mot else {
        return Accessoires()
    }
    return Accessoires(
        ana: getAna(context: context, ods: mot.refOds),
        rac: getRac(context: context, ods: mot.refOds),
        ext: getExt(context: context, ods: mot.refOds)
    )
}
func getAna(context: NSManagedObjectContext, ods: Ods9?) -> [String] {
    guard let ods = ods else {
        return []
    }
    let spectre = ods.spectre ?? VIDE
    let graphie = ods.graphie ?? VIDE
    let req: NSFetchRequest<Ods9> = Ods9.fetchRequest()
    req.entity = Ods9.entity()
    var anas: [Ods9] = []
    do {
        req.predicate = NSPredicate(format: "spectre = %@ AND graphie != %@", spectre, graphie)
        anas = try context.fetch(req)
    } catch {
        print("Erreur anagrammes")
    }
    return anas.map { $0.graphie ?? "" }
}
func getExt(context: NSManagedObjectContext, ods: Ods9?) -> [String] {
    guard let ods = ods else {
        return []
    }
    let graphie = ods.graphie ?? VIDE
    let req: NSFetchRequest<Ods9> = Ods9.fetchRequest()
    req.entity = Ods9.entity()
    
    var exts: [Ods9] = []
    do {
        req.predicate = NSPredicate(format:"graphie LIKE %@ OR graphie LIKE %@","?\(graphie)","\(graphie)?")
        exts = try context.fetch(req)
    } catch {
        print("Erreur extensions")
    }
    return exts.map { $0.graphie ?? "" }
}
func getRac(context: NSManagedObjectContext, ods: Ods9?) -> [String] {
    guard let ods = ods else {
        return []
    }
    let graphie = ods.graphie ?? ""
    let xMot = String(graphie.dropFirst(1))
    let motX = String(graphie.dropLast(1))
    let req: NSFetchRequest<Ods9> = Ods9.fetchRequest()
    req.entity = Ods9.entity()
    
    var racs: [Ods9] = []
    do {
        req.predicate = NSPredicate(format:"graphie = %@ OR graphie = %@",xMot, motX)
        racs = try context.fetch(req)
    } catch {
        print("Erreur raccourcis")
    }
    return racs.map { $0.graphie ?? "" }
}
func addDef(context: NSManagedObjectContext, def: String) -> Definition {
    let newDef = Definition(context: context)
    newDef.enonce = def
    return(newDef)
}

func addMots(context: NSManagedObjectContext, mots: String, def: String) -> Int {
    var definition: Definition?
    var n = 0
    let motList = mots.components(separatedBy: " ").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
    for mot in motList.dropFirst() {
        if let refOds = getOdsRef(context: context, mot: mot) {
            if let mot = refOds.mot {
                definition = mot.definition
                break
            }
        }
    }
    if definition == nil { definition = addDef(context: context, def: def) }
    for mot in motList {
        if let refOds = getOdsRef(context: context, mot: mot) {
            if refOds.mot == nil {
                let newMot = Mot(context: context)
                newMot.definition = definition
                newMot.refOds = refOds
                n += 1
            }
        }
    }
    saveContext(context: context)
    return n
}

func transfSugToMot(context: NSManagedObjectContext, sugList: [SuggItem]) -> Int {
    var count = 0
    for sug in sugList {
        let definition = addDef(context: context, def: sug.sug.def!)
        print("Definition : \(definition.enonce!) ajoutée")
        for mot in sug.motsList {
            if let refOds = getOdsRef(context: context, mot: mot) {
                print("Ods : \(refOds.graphie!) trouvée")
                if refOds.mot == nil {
                    let newMot = Mot(context: context)
                    newMot.definition = definition
                    newMot.refOds = refOds
                    newMot.motMort = sug.onGarde ? false : true
                    newMot.baseActive = sug.onGarde ? true : false
                    count += 1
                    print("ajouté")
                } else {
                    print("mot :\(mot) déja présent")
                }
            } else {
                print("mot :\(mot) non reconnu")
            }
        }
    context.delete(sug.sug)
    }
    saveContext(context: context)
    return count
}

func deleteMot(context: NSManagedObjectContext, mot: Mot) -> Void {
    let set = mot.definition!.graphies! as! Set<Mot>
    if set.count == 1 {
        context.delete(mot.definition!)
    }
    context.delete(mot)
    saveContext(context: context)
}

func toggleStatusMot(context: NSManagedObjectContext, mot: Mot) -> Void {
    let motUpdate = mot as NSManagedObject
    if mot.motMort {
        motUpdate.setValue(false, forKey: "motMort")
        motUpdate.setValue(true, forKey: "baseActive")
    } else if mot.baseActive {
        motUpdate.setValue(false, forKey: "baseActive")
    } else {
        motUpdate.setValue(true, forKey: "baseActive")
        motUpdate.setValue(mot.nSession + 1, forKey: "nSession")
        motUpdate.setValue(0, forKey: "sqSucces")
    }
    saveContext(context: context)
}

func reactiveMots(context: NSManagedObjectContext, listMots: [RevItem]) -> Int {
    var count = 0
    for mot in listMots {
        let motUpdate = mot.mot as NSManagedObject
        if mot.onGarde {
            count += 1
            motUpdate.setValue(0, forKey: "sqSucces")
            motUpdate.setValue(mot.mot.nSession + 1, forKey: "nSession")
            motUpdate.setValue(true, forKey: "baseActive")
        } else {
            motUpdate.setValue(true, forKey: "motMort")
        }
        saveContext(context: context)
    }
    return count
}

func delExistingSug(context: NSManagedObjectContext, listImport: [ImportItem]) -> Int {
    var count = 0
    for item in listImport {
        if let sug = checkSugg(context: context, mot: item.motsList[0]) {
            count += 1
            context.delete(sug)
        }
    }
    saveContext(context: context)
    return count
}

func addToSug(context: NSManagedObjectContext, listImport: [ImportItem]) {
    for item in listImport {
        let sugItem = Sugg(context: context)
        sugItem.mots = item.mots
        sugItem.def = item.def
        sugItem.timeStamp = Date()
        }
    saveContext(context: context)
}

func addImportToSugg(context: NSManagedObjectContext, listImport: [ImportItem])  -> Int {
    let count = delExistingSug(context: context, listImport:listImport)
    addToSug(context: context, listImport:listImport )
    return listImport.count - count
}


func sontDansOds(context: NSManagedObjectContext, mots: [String]) -> [String] {
    let request: NSFetchRequest<Ods9> = Ods9.fetchRequest()
    request.entity = Ods9.entity()
    request.predicate = NSPredicate(format: "graphie IN %@", mots)
    
    do {
        return try context.fetch(request).map {$0.graphie!}
    } catch {
        print("Erreur recherche ods")
        return [String]()
    }
}

func getOdsRef(context: NSManagedObjectContext, mot: String) -> Ods9? {
    let request: NSFetchRequest<Ods9> = Ods9.fetchRequest()
    request.entity = Ods9.entity()
    request.predicate = NSPredicate(format: "graphie == %@", mot)
    do {
        let ods = try context.fetch(request)
        return ods.isEmpty ? nil : ods[0]
    } catch {
        print("Erreur recherche ods")
        return nil
    }
}

func estDansOds(context: NSManagedObjectContext, mot: String) -> Bool {
    let request: NSFetchRequest<Ods9> = Ods9.fetchRequest()
    request.entity = Ods9.entity()
    request.predicate = NSPredicate(format: "graphie LIKE %@", mot)
    
    do {
        return try context.fetch(request).count > 0
    } catch {
        print("Erreur recherche ods")
        return false
    }
}

func checkSugg(context: NSManagedObjectContext, mot: String) -> Sugg? {
        let request: NSFetchRequest<Sugg> = Sugg.fetchRequest()
        request.entity = Sugg.entity()
        request.predicate = NSPredicate(format: "mots CONTAINS %@", mot)
    
    do {
        let result = try context.fetch(request)
        
        if result.count > 0 {
            for sug in result {
                let sugList = sug.mots!.split(separator: " ").map {String($0)}
                if sugList.contains(mot) {
                    return sug
                }
            }
            return nil
        } else {
            return nil
        }
    } catch {
        print("La recherche de suggestions poour le mot \(mot) a échoué. Erreur \(error)")
        return nil
    }
}

func saveContext(context: NSManagedObjectContext) {
    do {
        try context.save()
    } catch {
        let error = error as NSError
        fatalError("An error occured: \(error)")
    }
}
