//
//  FlowerUnlockManager.swift
//  Flowzzley
//
//  Created by Feda  on 22/02/2026.
//


import Foundation

struct FlowerUnlockManager {

    private static let key = "UnlockedFlowers"

    static func unlockedFlowers() -> [String: Date] {
        UserDefaults.standard.dictionary(forKey: key) as? [String: Date] ?? [:]
    }

    static func canUnlock(_ flower: FlowerType) -> Bool {
        let unlocked = unlockedFlowers()

        // إذا الوردة مفتوحة قبل → مسموح
        if unlocked[flower.rawValue] != nil {
            return true
        }

        // عدد الورود المفتوحة
        let count = unlocked.count

        // مسموح وردة وحدة فقط كل يوم
        if count == 0 { return true }

        // آخر تاريخ فتح
        if let lastDate = unlocked.values.sorted().last {
            return !Calendar.current.isDateInToday(lastDate)
        }

        return false
    }

    static func unlock(_ flower: FlowerType) {
        var unlocked = unlockedFlowers()
        unlocked[flower.rawValue] = Date()
        UserDefaults.standard.set(unlocked, forKey: key)
    }
}