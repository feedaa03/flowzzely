//
//  FlowerUnlockManager.swift
//  Flowzzley
//
//  Created by Feda  on 22/02/2026.
//
//
//  FlowerUnlockManager.swift
//  Flowzzely
//
//  Created by Feda on 23/02/2026.
//

import Foundation

struct FlowerUnlockManager {
    
    // MARK: - Private Properties
    private static let storageKey = "UnlockedFlowers"
    
    // MARK: - Public Methods
    static func unlockedFlowers() -> [String: Date] {
        UserDefaults.standard.dictionary(forKey: storageKey) as? [String: Date] ?? [:]
    }
    
    static func canUnlock(_ flower: FlowerType) -> Bool {
        let unlocked = unlockedFlowers()
        
        guard !isAlreadyUnlocked(flower, in: unlocked) else { return true }
        guard !unlocked.isEmpty else { return true }
        
        return wasLastUnlockBeforeToday(in: unlocked)
    }
    
    static func unlock(_ flower: FlowerType) {
        var unlocked = unlockedFlowers()
        unlocked[flower.rawValue] = Date()
        UserDefaults.standard.set(unlocked, forKey: storageKey)
    }
    
    // MARK: - Private Helpers
    private static func isAlreadyUnlocked(_ flower: FlowerType, in unlocked: [String: Date]) -> Bool {
        unlocked[flower.rawValue] != nil
    }
    
    private static func wasLastUnlockBeforeToday(in unlocked: [String: Date]) -> Bool {
        guard let lastDate = unlocked.values.sorted().last else { return false }
        return !Calendar.current.isDateInToday(lastDate)
    }
}
