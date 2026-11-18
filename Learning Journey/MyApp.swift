import SwiftUI
import SwiftData

@main
struct MyApp: App {

    // MARK: - App Entry Point

    var body: some Scene {

        WindowGroup {

            // أول شاشة تظهر عند تشغيل التطبيق
            ContentView()
                .preferredColorScheme(.dark)
        }

        // MARK: - SwiftData Container

        // تحديد البيانات التي يحفظها التطبيق
        .modelContainer(for: [
            LearningGoal.self,
            DailyRecord.self
        ])
    }
}
