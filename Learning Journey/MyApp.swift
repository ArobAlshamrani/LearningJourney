import SwiftUI
import SwiftData
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) //iPhone: Dark mood
        }
        .modelContainer(for: [
            LearningGoal.self,
            DailyRecord.self
        ])
    }
}
