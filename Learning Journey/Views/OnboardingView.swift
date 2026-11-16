import SwiftUI

enum OnboardingDuration: String, CaseIterable {
    //CaseIterable عشان نقدر نعرض جميع الخيارات باستخدام ForEach بدون ما نكرر تصميم الزر ثلاث مرات.
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
struct OnboardingView: View {

    // MARK: - Properties

    @State private var goalName = ""
    @State private var selectedDuration: OnboardingDuration = .week

    let onStart: (String, String) -> Void

    private let orange = Color(
        red: 0.98,
        green: 0.54,
        blue: 0.16
    )

    // MARK: - UI

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 0) {

                // MARK: - Flame Icon

                Image(systemName: "flame.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(orange)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 64)
                    .padding(.bottom, 84)

                // MARK: - Welcome Text

                Text("Hello **Learner**")
                    .font(.system(size: 34))
                    .foregroundStyle(.white)

                Text("This app will help you learn everyday!")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)

                // MARK: - Learning Goal

                Text("I want to learn")
                    .font(.system(size: 16))
                    .padding(.top, 38)

                TextField(
                    "Swift",
                    text: $goalName,
                    prompt: Text("Swift")
                        .foregroundStyle(.gray)
                )
                .font(.system(size: 17))
                .padding(.vertical, 16)

                Divider()

                // MARK: - Goal Duration

                Text("I want to learn it in a")
                    .font(.system(size: 16))
                    .padding(.top, 32)

                HStack(spacing: 12) {

                    ForEach(
                        OnboardingDuration.allCases,
                        id: \.self
                    ) { duration in

                        Button {
                            selectedDuration = duration
                        } label: {

                            Text(duration.rawValue)
                                .font(.system(size: 17))
                                .foregroundStyle(
                                    selectedDuration == duration
                                    ? Color.white
                                    : Color.gray
                                )
                                .padding(.horizontal, 22)
                                .frame(height: 46)
                                .appGlass(
                                    .capsule,
                                    tint: selectedDuration == duration
                                    ? orange
                                    : nil,
                                    interactive: true
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 14)
            }
            .padding(.horizontal, 20)
        }
        .safeAreaInset(edge: .bottom) {

            // MARK: - Start Learning

            VStack(spacing: 14) {

                Button {
                    onStart(
                        goalName.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ),
                        selectedDuration.rawValue
                    )
                } label: {

                    Text("Start Learning")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .frame(height: 46)
                        .appGlass(
                            .capsule,
                            tint: orange,
                            interactive: true
                        )
                }
                .buttonStyle(.plain)
                .disabled(
                    goalName.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty
                )

                Text("You can edit your desire later")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 12)
            .padding(.bottom, 16)
            .background(Color.black)
        }
        .background {
            Color.black.ignoresSafeArea()
        }
    }
}

#Preview {
    OnboardingView { name, duration in
        print(name, duration)
    }
    .preferredColorScheme(.dark)
}
