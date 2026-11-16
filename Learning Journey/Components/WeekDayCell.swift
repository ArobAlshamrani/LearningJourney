import SwiftUI

struct WeekDayCell: View {

    // MARK: - Properties
    let date: Date
    let status: DayStatus?
    
    // MARK: - Colors

    private let orange = Color(
        red: 1, green: 0.56, blue: 0.15
    )

    private let darkBrown = Color(
        red: 0.16, green: 0.09, blue: 0.03
    )

    // Frozen background
    private let darkTeal = Color(
        red: 0.03, green: 0.19, blue: 0.23
    )

    // Frozen text
    private let cyan = Color(
        red: 0.17, green: 0.78, blue: 0.93
    )

    // MARK: - Today
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    // MARK: - Day Letter
    private var dayLetter: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date)
    }

    // MARK: - Background Color
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

            Text(dayLetter)
                .font(.system(size: 16))
                .foregroundStyle(.white)

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
