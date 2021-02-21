//
//  DefaultManager.swift
//  iFlappy
//
//  Created by Aaryan Kothari on 16/02/21.
//

import Foundation

class DefaultManager {
    
    func saveHighScore(_ score: Int) {
        if fetchHighScore() < score {
        UserDefaults.standard.set(score, forKey: "highscore")
        }
    }
    
    func fetchHighScore() -> Int {
        UserDefaults.standard.integer(forKey: "highscore")
    }
    
}
