//
//  Lettre.swift
//  MilleMots
//
//  Created by Simon Wintz on 03/04/2024.
//

import Foundation

class Tuile {
    var lettre : Character = " "
    var position : Int = 0
    var positionX : Double = 0
    var zoneTransl : Int = 0
    var voisinG : Tuile?
    var voisinD : Tuile?
    
    init(car: Character, ind: Int, voisinG: Tuile?) {
        lettre = car
        position = ind
        self.voisinG = voisinG
        if voisinG != nil {
            voisinG!.voisinD = self
        }
        self.voisinD = nil
    }
    
    init(car: Character, ind: Int) {
        lettre = car
        position = ind
        self.voisinG = nil
        self.voisinD = nil
    }
    
    func decalageG(pasLettre: Double) {
        if self.voisinG != nil {
            
            self.position -= 1
            self.zoneTransl -= 1
            voisinG!.position += 1
            voisinG!.positionX += pasLettre
            voisinG!.zoneTransl += 1
            
            let voisinDeGauche = self.voisinG
            let voisindeDroite = self.voisinD
            
            relier(g: voisinDeGauche!.voisinG, d:self)
            relier(g: self, d: voisinDeGauche)
            relier(g: voisinDeGauche, d: voisindeDroite)
        }
    }
    
    func decalageD(pasLettre: Double) {
        if self.voisinD != nil {
            
            self.position += 1
            self.zoneTransl += 1
            voisinD!.position -= 1
            voisinD!.positionX -= pasLettre
            voisinD!.zoneTransl -= 1
            
            let voisinDeGauche = self.voisinG
            let voisindeDroite = self.voisinD
            
            relier(g: self, d: voisindeDroite!.voisinD)
            relier(g: voisindeDroite, d: self)
            relier(g: voisinDeGauche, d: voisindeDroite!)
        }
    }
    
    private func relier(g: Tuile?, d: Tuile?) {
        if g != nil {
            g!.voisinD = d
        }
        if d != nil {
            d!.voisinG = g
        }
    }
}
