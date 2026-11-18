import SwiftUI

struct WeekDayCell: View {

    // MARK: - Properties

    let date: Date // تاريخ اليوم
    let status: DayStatus? // حالة اليوم: تعلم، تجميد، أو بدون تسجيل

    // MARK: - Colors

    private let orange = Color(
        red: 1, green: 0.56, blue: 0.15
    )

    private let darkBrown = Color(
        red: 0.16, green: 0.09, blue: 0.03
    )

    // لون خلفية اليوم المجمد
    private let darkTeal = Color(
        red: 0.03, green: 0.19, blue: 0.23
    )

    // لون نص اليوم المجمد
    private let cyan = Color(
        red: 0.17, green: 0.78, blue: 0.93
    )

    // MARK: - Today

    // يتحقق هل التاريخ هو اليوم الحالي
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    // MARK: - Day Letter

    // يحول التاريخ إلى حرف واحد مثل M أو T
    private var dayLetter: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        //.locale: خاصية تحدد اللغة والمنطقة المستخدمة في التنسيق.
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date)
    }

    // MARK: - Background Color

    // يحدد لون الدائرة حسب حالة اليوم
    private var dayBackground: Color {
        switch status {
        case .learned:
            return darkBrown

        case .frozen:
            return darkTeal

        case nil:
            return isToday ? orange : .clear
        }
    }

    // MARK: - Text Color

    // يحدد لون الرقم حسب حالة اليوم
    private var dayTextColor: Color {
        switch status {
        case .learned:
            return orange

        case .frozen:
            return cyan

        case nil:
            return .white
        }
    }

    // MARK: - UI

    var body: some View {
        VStack(spacing: 12) {

            // حرف اليوم
            Text(dayLetter)
                .font(.system(size: 16))
                .foregroundStyle(.white)

            // رقم اليوم
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(dayTextColor)
                .frame(width: 48, height: 48)
                .background {
                    Circle()
                        .fill(dayBackground)
                }
        }
        .frame(maxWidth: .infinity)
    }
}
//Calendar.component يستخرج رقمًا من التاريخ، بينما DateFormatter يحوّل التاريخ إلى نص بالتنسيق اللي نختاره.
