import SwiftUI

// MARK: - Goal Result Types

enum GoalResult {
    case completed
    case notMet

    var symbol: String {
        switch self {
        case .completed:
            return "hands.clap.fill"
        case .notMet:
            return "xmark.seal.fill"
        }
    }

    var title: String {
        switch self {
        case .completed:
            return "Well done!"
        case .notMet:
            return "You didn't reach your goal this time."
        }
    }

    var subtitle: String {
        switch self {
        case .completed:
            return "Ready for your next goal?"
        case .notMet:
            return "Want to set another goal?"
        }
    }
}

// MARK: - Goal Result View

struct GoalResultView: View {

    let result: GoalResult
    let onSetGoal: () -> Void // هذا يسمح لنا نحدد لاحقًا وش يصير لما المستخدم يضغط Set a goal

    private let orange = Color(
        red: 1,
        green: 0.56,
        blue: 0.15
    )

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Result Icon

            ZStack {

                if result == .completed {

                    Image(systemName: "hands.and.sparkles.fill")
                        .font(.system(size: 43))
                        .foregroundStyle(
                            Color(
                                red: 247.0 / 255,
                                green: 181.0 / 255,
                                blue: 0
                            )
                        )

                

                } else {

                    Image(systemName: "xmark.seal.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(orange)
                }
            }
            .frame(height: 55)
            .padding(.bottom, 14)

            // Result Title
            Text(result.title)
                .font(.system(size: 17, weight: .semibold))                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            // Result Description
            Text(result.subtitle)
                .font(.system(size: 14))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 6)

            // Set a Goal Button
            Button(action: onSetGoal) {
                Label("Set a goal",
                      systemImage: "pencil.and.outline")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .frame(height: 44)
                    .background(orange, in: Capsule())
            }
            .buttonStyle(.plain)
            .padding(.top, 70)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }
}

// MARK: - Previews

#Preview("Goal Completed") {
    GoalResultView(result: .completed) {
        print("Set a goal tapped")
    }
    .preferredColorScheme(.dark)
}

/*#Preview("Goal Not Met") {
    GoalResultView(result: .notMet) {
        print("Set a goal tapped")
    }
    .preferredColorScheme(.dark)
}
*/
