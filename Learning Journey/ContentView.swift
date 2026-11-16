
import SwiftUI

struct ContentView: View {

    @AppStorage("learningGoalName")
    private var goalName = ""

    @AppStorage("learningGoalDuration")
    private var goalDuration = "Week"

    var body: some View {

        if goalName.isEmpty {

            OnboardingView { name, duration in

                goalDuration = duration
                goalName = name
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
