import Foundation

class DailyProgressManager {
    static let shared = DailyProgressManager()

    private let key = "UnlockedFlowerIndex"

    private init() {}

    var unlockedIndex: Int {
        UserDefaults.standard.integer(forKey: key)
    }

    func isUnlocked(_ flower: FlowerType) -> Bool {
        flower.order <= unlockedIndex
    }

    func markSolved(flower: FlowerType) {
        if flower.order == unlockedIndex {
            UserDefaults.standard.set(unlockedIndex + 1, forKey: key)
        }
    }
}