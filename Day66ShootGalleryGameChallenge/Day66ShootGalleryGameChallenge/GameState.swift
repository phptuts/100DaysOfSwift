//
//  GameState.swift
//  Day66ShootGalleryGameChallenge
//
//  Created by Noah Glaser on 1/15/22.
//

import Foundation
import SpriteKit

struct GameState {
    var bullets = 6
    var targetsHit = 0
    var evilDucks = 0
    var targetsMissed = 0
    var protectedDucks = 0
    var timeLeft = 25
    var playReloadSound = false
    var playFireSound = false
    var playEmptySound = false
    var spriteToFade: SKNode?
    
    
    mutating func reload() {
        self.bullets = 6
        self.playReloadSound = true
    }
    
    mutating func fireBullet(_ hitSprite: SKNode?) {
        
        if self.bullets == 0 {
            self.playEmptySound = true
            return
        }
        
        if self.bullets > 0 {
            self.bullets -= 1
            self.playFireSound = true
        }
        
        
        guard let sprite = hitSprite else { return }
        
        if sprite.name == "target0" {
            targetsHit += 1
        }
        
        if sprite.name == "target1" {
            protectedDucks += 1
        }
        
        if sprite.name == "target3" {
            evilDucks += 1
        }

        
        spriteToFade = hitSprite
    }
    
    var isGameOver: Bool {
        return timeLeft == 0
    }
    
    var score: Int {
        return targetsHit * 3 - (protectedDucks * 5) + (evilDucks * 7)
    }
    
}
