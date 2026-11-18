
import SwiftUI

// MARK: - Goal Result Types

// يحدد حالات نتيجة الهدف
enum GoalResult {
    case completed
    case notMet

    // MARK: - Result Symbol

    var symbol: String {
        switch self {
        case .completed:
            return "hands.and.sparkles.fill"
        case .notMet:
            return "xmark.seal.fill"
        }
    }

    // MARK: - Result Title

    var title: String {
        switch self {
        case .completed:
            return "Well done!"
        case .notMet:
            return "You didn't reach your goal this time."
        }
    }

    // MARK: - Result Subtitle

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

    // MARK: - Properties

    let result: GoalResult // يحدد نتيجة الهدف
    let onSetGoal: () -> Void // العملية عند الضغط على الزر

    private let orange = Color(
        red: 1,
        green: 0.56,
        blue: 0.15
    )

    private let gold = Color(
        red: 247.0 / 255,
        green: 181.0 / 255,
        blue: 0
    )

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Result Icon

            // يغير الأيقونة واللون حسب نتيجة الهدف
            Image(systemName: result.symbol)
                .font(.system(
                    size: result == .completed ? 43 : 40
                ))
                .foregroundStyle(
                    result == .completed ? gold : orange
                )
                .frame(height: 55)
                .padding(.bottom, 14)

            // MARK: - Result Title

            Text(result.title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            // MARK: - Result Description

            Text(result.subtitle)
                .font(.system(size: 14))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 6)

            // MARK: - Set a Goal Button

            Button(action: onSetGoal) {
                Label(
                    "Set a goal",
                    systemImage: "pencil.and.outline"
                )
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
    GoalResultView(result: .completed) {}
        .preferredColorScheme(.dark)
}

#Preview("Goal Not Met") {
    GoalResultView(result: .notMet) {}
        .preferredColorScheme(.dark)
}
