//
//  DailyProgressManager.swift
//  Flowzzley
//
//  Created by Feda  on 22/02/2026.
//


import Foundation

class DailyProgressManager {
    static let shared = DailyProgressManager()

    private let key = "UnlockedFlowerIndex"

    private init() {}

    var unlockedIndex: Int {
        UserDefaults.standard.integer(forKey: key)
    }

    func isUnlocked(_ flower: FlowerType) -> Bool {
        let order = FlowerType.allCases.firstIndex(of: flower) ?? 0
        return order <= unlockedIndex
    }

    func markSolved(flower: FlowerType) {
        let order = FlowerType.allCases.firstIndex(of: flower) ?? 0
        if order == unlockedIndex {
            UserDefaults.standard.set(unlockedIndex + 1, forKey: key)
        }
    }
}
