import SwiftUI
import SwiftData

struct EditGoalView: View {
    
    @Environment(\.modelContext)
    private var modelContext
    let viewModel: LearningViewModel
    
    // MARK: - Navigation

    @Environment(\.dismiss) private var dismiss

    // MARK: - Saved Goal

    @AppStorage("learningGoalName")
    private var savedGoalName = ""

    @AppStorage("learningGoalDuration")
    private var savedDuration = "Week"

    // MARK: - Temporary Editing State
    @State private var showUpdateConfirmation = false
    
    @State private var goalName = ""

    @State private var selectedDuration: OnboardingDuration = .week

    private let orange = Color(
        red: 0.98,
        green: 0.54,
        blue: 0.16
    )

    // MARK: - UI

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            // MARK: - Header

            HStack {

                Button {
                    dismiss()
                } label: {

                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .appGlass(
                            .circle,
                            interactive: true
                        )
                }
                .buttonStyle(.plain)

                Spacer()

                Text("Learning Goal")
                    .font(.system(size: 17, weight: .semibold))

                Spacer()

                Button {
                    showUpdateConfirmation = true
                } label: {
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .appGlass(
                            .circle,
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
            }

            // MARK: - Goal Name

            Text("I want to learn")
                .font(.system(size: 16))
                .padding(.top, 44)

            TextField("Swift", text: $goalName)
                .font(.system(size: 17))
                .padding(.vertical, 16)

            Divider()

            // MARK: - Duration

            Text("I want to learn it in a")
                .font(.system(size: 16))
                .padding(.top, 30)

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

            Spacer()
        }
        .padding(.horizontal, 20)
        .background {
            Color.black.ignoresSafeArea()
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {

            goalName = savedGoalName

            selectedDuration = OnboardingDuration(
                rawValue: savedDuration
            ) ?? .week
        }
        .overlay {
            if showUpdateConfirmation {
                confirmationPopup
            }
        }
    }
    
    // MARK: - Update Confirmation Popup

    private var confirmationPopup: some View {

        ZStack {

            // Dark background behind the popup
            Color.black.opacity(0.65)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {

                Text("Update goal")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)

                Text("If you update now, your streak will start over.")
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10) {
                    
                    // Dismiss Button
                    Button {
                        print("Dismiss tapped")
                        showUpdateConfirmation = false
                    } label: {
                        Text("Dismiss")
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                Color(red: 0.20, green: 0.20, blue: 0.21),
                                in: Capsule()
                            )
                    }
                    
                    // Update Button
                    Button {
                        print("Update tapped")
                        showUpdateConfirmation = false
                        saveGoal()
                    } label: {
                        Text("Update")
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(orange, in: Capsule())
                    }
                }
                .buttonStyle(.plain)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .buttonStyle(.plain)
                .padding(.top, 8)
            }

            .padding(22)
            .frame(maxWidth: 320)
            .background {
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(red: 0.11, green: 0.11, blue: 0.11))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 28)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Save Changes
    private func saveGoal() {

        let name = goalName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !name.isEmpty else { return }

        do {
            try viewModel.updateGoal(
                title: name,
                duration: selectedDuration.rawValue,
                in: modelContext
            )

            savedGoalName = name
            savedDuration = selectedDuration.rawValue

            dismiss()

        } catch {
            print("Failed to update goal: \(error)")
        }
    }

}

#Preview {
    NavigationStack {
        EditGoalView(viewModel: LearningViewModel())
    }
    .preferredColorScheme(.dark)
}
