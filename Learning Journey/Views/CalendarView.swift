import SwiftUI

struct CalendarView: View {
    let viewModel: LearningViewModel
   
    @Environment(\.dismiss) private var dismiss

    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1 // Sunday
        return calendar
    }()

    private let weekDays = [
        "SUN", "MON", "TUE", "WED",
        "THU", "FRI", "SAT"
    ]

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 0),
        count: 7
    )

    private let orange = Color(
        red: 1, green: 0.56, blue: 0.15
    )

    // MARK: - Months

    
    private var months: [Date] {

        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())

        guard let january = calendar.date(
            from: DateComponents(year: year, month: 1, day: 1)
        ) else {
            return []
        }

        return (0..<12).compactMap { offset in
            calendar.date(
                byAdding: .month,
                value: offset,
                to: january
            )
        }
    }
    // MARK: - Current Month

    private var currentMonth: Date {
        Calendar.current.dateInterval(
            of: .month,
            for: Date()
        )?.start ?? Date()
    }

    // MARK: - UI

    var body: some View {

        VStack(spacing: 0) {

            // Header
            HStack {

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                    // MARK: - Calendar Button Glass
                    .glassEffect(
                        .regular,
                        in: Circle()
                    )
                }

                Spacer()

                Text("Activities")
                    .font(.system(size: 17, weight: .semibold))

                Spacer()

                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // MARK: - Scrollable Calendar

            ScrollViewReader { proxy in

                ScrollView(.vertical) {

                    LazyVStack(spacing: 24) {

                        ForEach(months, id: \.self) { month in

                            monthView(month)
                                .id(month)

                        }
                    }
                }
                .onAppear {
                    proxy.scrollTo(currentMonth, anchor: .top)
                }
            }
            .scrollIndicators(.visible)
            .frame(maxHeight: .infinity)
           
        }
        
        .background(Color.black.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Month View

    private func monthView(_ month: Date) -> some View {

        let leadingDays =
            calendar.component(.weekday, from: month) - 1

        let numberOfDays =
            calendar.range(of: .day, in: .month, for: month)?.count ?? 30

        return VStack(alignment: .leading, spacing: 14) {

            Text(monthTitle(month))
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)

            LazyVGrid(columns: columns, spacing: 14) {

                // Weekday names
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 11))
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity)
                }

                // Calendar dates
                ForEach(0..<(leadingDays + numberOfDays), id: \.self) { index in

                    if index < leadingDays {
                        Color.clear
                            .frame(height: 38)
                    } else {

                        let day = index - leadingDays + 1

                        if let date = calendar.date(
                            byAdding: .day,
                            value: day - 1,
                            to: month
                        ) {
                            dayCell(date, day: day)
                        }
                    }
                }
            }

            Divider()
                .overlay(Color.white.opacity(0.12))
        }
    }

    // MARK: - Day Cell

    private func dayCell(_ date: Date, day: Int) -> some View {
        let dayRecords = viewModel.records.filter {
            Calendar.current.isDate(
                $0.date,
                inSameDayAs: date
            )
        }

        let status: DayStatus? =
            dayRecords.first {
                $0.goalID == viewModel.activeGoal?.id
            }?.status
            ?? (
                Calendar.current.isDateInToday(date)
                ? nil
                : dayRecords.first?.status
            )


        let isToday = Calendar.current.isDateInToday(date)

        // 2. Circle background
        let backgroundColor: Color =
            status == .learned ? Color(red: 0.16, green: 0.09, blue: 0.03) :
            status == .frozen ? Color(red: 0.03, green: 0.19, blue: 0.23) :
            isToday ? Color(red: 1, green: 0.56, blue: 0.15) :
            .clear

        // 3. Day number color
        let textColor: Color =
            status == .learned ? Color(red: 1, green: 0.60, blue: 0.20) :
            status == .frozen ? .cyan :
            .white

        return Text("\(day)")
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity)
            .frame(height: 38)
            .background {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 36, height: 36)
            }
    }


    // MARK: - Month Title

    private func monthTitle(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        CalendarView(viewModel: LearningViewModel())
    }
    .preferredColorScheme(.dark)
}
