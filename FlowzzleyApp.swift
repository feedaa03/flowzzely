import SwiftUI

@main
struct FlowzzleyApp: App {

        init() {
            _ = SoundManager.shared
            DailyProgressManager.shared.requestNotificationPermission()
        }
    var body: some Scene {
        
        WindowGroup {
            NavigationStack {
                StartView()
            }
        }
    }
}
