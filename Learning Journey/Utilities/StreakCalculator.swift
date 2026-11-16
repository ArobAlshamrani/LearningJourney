
import Foundation

struct StreakCalculator {

    static func calculate(
        records: [DailyRecord],
        goalStartDate: Date,
      //  goalStartDate: هذا  Parameter (مدخل للدالة)، يمثل تاريخ بداية الهدف الحالي.
        now: Date = Date()
    ) -> Int {

        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: goalStartDate)

        let recordsByDay = Dictionary(
            records.map {
                (calendar.startOfDay(for: $0.date), $0.status)
            },
            uniquingKeysWith: { _, latest in latest }
        )

        var day = calendar.startOfDay(for: now)
        var streak = 0

        // Today is still available for logging
        if recordsByDay[day] == nil {
            guard let yesterday = calendar.date(
                byAdding: .day,
                value: -1,
                to: day
            ) else {
                return 0
            }

            day = yesterday
        }

        while day >= startDay {

            guard let status = recordsByDay[day] else {
                break
            }

            if status == .learned {
                streak += 1
            }

            guard let previousDay = calendar.date(
                byAdding: .day,
                value: -1,
                to: day
            ) else {
                break
            }

            day = previousDay
        }

        return streak
    }
}
