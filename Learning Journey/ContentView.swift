import SwiftUI
import SwiftData
struct ContentView: View {
    // MARK: - SwiftData

    @Environment(\.modelContext)
    private var modelContext
    
    @AppStorage("learningGoalName")
    private var goalName = ""

    @AppStorage("learningGoalDuration")
    private var goalDuration = "Week"

    var body: some View {

        if goalName.isEmpty {

            OnboardingView { name, duration in
                // حفظ أول هدف في SwiftData
                do {
                    let viewModel = LearningViewModel()

                    try viewModel.updateGoal(
                        title: name,
                        duration: duration,
                        in: modelContext
                    )

                    goalDuration = duration
                    goalName = name

                } catch {
                    print("Failed to create goal: \(error)")
                }
            }
        } else {
            NavigationStack {
                ActivityView()
                    .toolbar(.hidden, for: .navigationBar)
            }
        
        }
    }
    
    private var currentMonth: Date {
        Calendar.current.dateInterval(
            of: .month,
            for: Date()
        )!.start
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
