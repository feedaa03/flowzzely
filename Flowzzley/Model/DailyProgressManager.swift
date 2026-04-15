//
//  DailyProgressManager.swift
//  Flowzzley
//
//  Created by Feda on 23/02/2026.
//

import Foundation
import Combine
import UserNotifications

class DailyProgressManager: ObservableObject {

    // MARK: - Singleton
    static let shared = DailyProgressManager()

    // MARK: - Storage key
    private let solvedDatesKey = "FlowerSolvedDates"

    // MARK: - Timer
    private var midnightTimer: Timer?

    private init() {
        scheduleMidnightRefresh()
    }

    // MARK: - Solved dates  [flowerRawValue: timeIntervalSince1970]
    private var solvedDates: [String: Double] {
        get { UserDefaults.standard.dictionary(forKey: solvedDatesKey) as? [String: Double] ?? [:] }
        set { UserDefaults.standard.set(newValue, forKey: solvedDatesKey) }
    }

    // MARK: - Public API

    func isUnlocked(_ flower: FlowerType) -> Bool {
        let index = FlowerType.allCases.firstIndex(of: flower) ?? 0

        // الوردة الأولى دايماً مفتوحة
        if index == 0 { return true }

        // الوردة السابقة لازم تكون محلولة
        let prevFlower = FlowerType.allCases[index - 1]
        guard let solvedInterval = solvedDates[prevFlower.rawValue] else { return false }

        // الساعة 12 AM بعد يوم الحل لازم تكون فاتت
        let solvedDate = Date(timeIntervalSince1970: solvedInterval)
        return Date() >= nextMidnight(after: solvedDate)
    }

    /// سبب قفل الوردة — nil تعني إنها مفتوحة
    enum LockReason {
        case previousNotSolved   // الوردة السابقة ما اتحلت بعد
        case waitingForMidnight  // محلولة بس لسا ما صارت 12 AM
    }

    func lockReason(for flower: FlowerType) -> LockReason? {
        guard !isUnlocked(flower) else { return nil }
        let index = FlowerType.allCases.firstIndex(of: flower) ?? 0
        if index == 0 { return nil }
        let prevFlower = FlowerType.allCases[index - 1]
        if solvedDates[prevFlower.rawValue] != nil {
            return .waitingForMidnight
        }
        return .previousNotSolved
    }

    func markSolved(flower: FlowerType) {
        var dates = solvedDates
        guard dates[flower.rawValue] == nil else { return } // محلولة أصلاً
        dates[flower.rawValue] = Date().timeIntervalSince1970
        solvedDates = dates
        scheduleNotification(for: flower)
        objectWillChange.send()
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    // MARK: - Midnight refresh

    private func scheduleMidnightRefresh() {
        midnightTimer?.invalidate()
        let delay = nextMidnight(after: Date()).timeIntervalSinceNow
        midnightTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.objectWillChange.send()
            self?.scheduleMidnightRefresh() // جدول للمنتصف الليل القادم
        }
    }

    // MARK: - Notifications

    private func scheduleNotification(for solvedFlower: FlowerType) {
        let allCases = FlowerType.allCases
        guard let index = allCases.firstIndex(of: solvedFlower),
              index + 1 < allCases.count else { return }

        let nextFlower = allCases[index + 1]
        let unlockDate = nextMidnight(after: Date())

        let content = UNMutableNotificationContent()
        content.title = "🌸 Flowzzley"
        content.body = "\(nextFlower.rawValue.capitalized) is now ready to solve!"
        content.sound = .default

        let comps = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: unlockDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["flower_\(nextFlower.rawValue)"])
        let request = UNNotificationRequest(
            identifier: "flower_\(nextFlower.rawValue)",
            content: content,
            trigger: trigger
        )
        center.add(request)
    }

    // MARK: - Helpers

    private func nextMidnight(after date: Date) -> Date {
        let calendar = Calendar.current
        let nextDay = calendar.date(byAdding: .day, value: 1, to: date)!
        return calendar.startOfDay(for: nextDay)
    }
}
