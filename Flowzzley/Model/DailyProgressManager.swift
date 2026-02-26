//
//  DailyProgressManager.swift
//  Flowzzely
//
//  Created by Feda on 23/02/2026.
//

import Foundation
import UserNotifications

@MainActor
final class DailyProgressManager {

    // MARK: - Singleton
    static let shared = DailyProgressManager()
    private init() {}

    // MARK: - Private Properties
    private let unlockedFlowerIndexKey = "UnlockedFlowerIndex"

    // MARK: - Public Properties
    private(set) var unlockedIndex: Int {
        get { UserDefaults.standard.integer(forKey: unlockedFlowerIndexKey) }
        set { UserDefaults.standard.set(newValue, forKey: unlockedFlowerIndexKey) }
    }

    // MARK: - Public Methods
    func isUnlocked(_ flower: FlowerType) -> Bool {
        return flowerOrder(of: flower) <= unlockedIndex
    }

    func markSolved(flower: FlowerType) {
        let order = flowerOrder(of: flower)
        guard order == unlockedIndex else { return }
        unlockedIndex += 1
        scheduleNextFlowerNotification()
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    // MARK: - Private Helpers
    private func flowerOrder(of flower: FlowerType) -> Int {
        return FlowerType.allCases.firstIndex(of: flower) ?? .zero
    }

    private func scheduleNextFlowerNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["nextFlower"])

        // لا يوجد وردة جديدة — كل الورود اتفتحت
        guard unlockedIndex < FlowerType.allCases.count else { return }

        let content = UNMutableNotificationContent()
        content.title = "🌸 Flowzzley"
        content.body = "Your new flower is ready to be solved!"
        content.sound = .default

        // الساعة 12 منتصف الليل من نفس اليوم اللي حلّت فيه
        var dateComponents = DateComponents()
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        // نضيف يوم عشان نوصل لـ 12 AM اليوم التالي
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let tomorrowComponents = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
        dateComponents.year = tomorrowComponents.year
        dateComponents.month = tomorrowComponents.month
        dateComponents.day = tomorrowComponents.day

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "nextFlower", content: content, trigger: trigger)

        center.add(request)
    }
}
