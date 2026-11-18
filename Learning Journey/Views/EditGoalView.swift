
import SwiftUI
import SwiftData

struct EditGoalView: View {

    // MARK: - Properties

    // الوصول إلى SwiftData لحفظ التغييرات
    @Environment(\.modelContext)
    private var modelContext

    // الوصول إلى بيانات الهدف الحالي ودوال التحديث
    let viewModel: LearningViewModel

    // MARK: - Navigation

    // الرجوع إلى الشاشة السابقة
    @Environment(\.dismiss) private var dismiss

    // MARK: - Temporary Editing State

    // التحكم في ظهور نافذة تأكيد التحديث
    @State private var showUpdateConfirmation = false

    // تخزين التعديلات مؤقتًا قبل حفظها
    @State private var goalName = ""
    @State private var selectedDuration: OnboardingDuration = .week

    // MARK: - Colors

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

                // زر الرجوع بدون حفظ
                Button {
                    dismiss()
                } label: {

                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .glassEffect(
                            .regular.interactive(),
                            in: Circle()
                        )
                }
                .buttonStyle(.plain)

                Spacer()

                Text("Learning Goal")
                    .font(.system(size: 17, weight: .semibold))

                Spacer()

                // زر عرض رسالة تأكيد التحديث
                Button {
                    showUpdateConfirmation = true
                } label: {

                    Image(systemName: "checkmark")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .glassEffect(
                            .regular
                                .tint(orange)
                                .interactive(),
                            in: Circle()
                        )
                }
                .buttonStyle(.plain)

                // منع التحديث إذا كان اسم الهدف فارغًا
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

            // ربط حقل النص باسم الهدف المؤقت
            TextField("Swift", text: $goalName)
                .font(.system(size: 17))
                .padding(.vertical, 16)

            Divider()

            // MARK: - Goal Duration

            Text("I want to learn it in a")
                .font(.system(size: 16))
                .padding(.top, 30)

            HStack(spacing: 12) {

                // عرض جميع خيارات المدة
                ForEach(
                    OnboardingDuration.allCases,
                    id: \.self
                ) { duration in

                    Button {

                        // تحديث المدة المختارة مؤقتًا
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

                            // تمييز الخيار المحدد باللون البرتقالي
                            .glassEffect(
                                .regular
                                    .tint(
                                        selectedDuration == duration
                                        ? orange
                                        : nil
                                    )
                                    .interactive(),
                                in: Capsule()
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

        // MARK: - Load Current Goal

        .onAppear {

            // قراءة بيانات الهدف الحالي من SwiftData
            guard let goal = viewModel.activeGoal else {
                return
            }

            // تعبئة الحقول بالقيم الحالية
            goalName = goal.title

            selectedDuration = OnboardingDuration(
                rawValue: goal.duration
            ) ?? .week
        }

        // MARK: - Confirmation Overlay

        .overlay {

            // عرض نافذة التأكيد عند الضغط على علامة الصح
            if showUpdateConfirmation {
                confirmationPopup
            }
        }
    }

    // MARK: - Update Confirmation Popup

    private var confirmationPopup: some View {

        ZStack {

            // تعتيم الخلفية خلف نافذة التأكيد
            Color.black.opacity(0.65)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {

                Text("Update goal")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)

                // تنبيه المستخدم أن التحديث سيصفر الستريك
                Text("If you update now, your streak will start over.")
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10) {

                    // MARK: - Dismiss Button

                    Button {

                        // إغلاق النافذة دون حفظ التغييرات
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

                    // MARK: - Update Button

                    Button {

                        // إغلاق النافذة ثم حفظ الهدف الجديد
                        showUpdateConfirmation = false
                        saveGoal()

                    } label: {

                        Text("Update")
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(orange, in: Capsule())
                    }
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .buttonStyle(.plain)
                .padding(.top, 8)
            }

            // MARK: - Popup Design

            .padding(22)
            .frame(maxWidth: 320)
            .glassEffect(
                .regular,
                in: RoundedRectangle(cornerRadius: 28)
            )
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Save Changes

    private func saveGoal() {

        // حذف المسافات الزائدة من اسم الهدف
        let name = goalName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // إيقاف الحفظ إذا كان الاسم فارغًا
        guard !name.isEmpty else { return }

        do {

            // إنشاء هدف جديد وحفظه في SwiftData
            try viewModel.updateGoal(
                title: name,
                duration: selectedDuration.rawValue,
                in: modelContext
            )

            // الرجوع بعد نجاح الحفظ
            dismiss()

        } catch {

            // طباعة الخطأ إذا فشل حفظ الهدف
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
