import Foundation

struct StreakCalculator {

    // MARK: - Calculate Streak

    static func calculate(
        records: [DailyRecord],
        goalStartDate: Date,
        now: Date = Date()
    ) -> Int {

        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: goalStartDate)

        // ترتيب التسجيلات حسب وقتها
        let sortedRecords = records
            .filter {
                $0.date >= startDay && $0.date <= now
            }
            .sorted {
                $0.date < $1.date
            }

        var streak = 0
        var lastRecord: DailyRecord?

        // MARK: - Count Streak

        for record in sortedRecords {

            if let previous = lastRecord {

                // بداية اليوم التالي لآخر تسجيل
                let previousDay = calendar.startOfDay(
                    for: previous.date
                )

                guard let nextDay = calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: previousDay
                ),
                let expiry = calendar.date(
                    byAdding: .hour,
                    value: 32,
                    to: nextDay
                ) else {
                    return 0
                }

                // تصفير الستريك إذا انتهت المهلة
                if record.date > expiry {
                    streak = 0
                }
            }

            // Learned يزيد الستريك
            // Freeze يحافظ عليه بدون زيادة
            if record.status == .learned {
                streak += 1
            }

            lastRecord = record
        }

        // MARK: - Check Current Expiration

        guard let lastRecord else {
            return 0
        }

        let lastDay = calendar.startOfDay(
            for: lastRecord.date
        )

        guard let nextDay = calendar.date(
            byAdding: .day,
            value: 1,
            to: lastDay
        ),
        let expiry = calendar.date(
            byAdding: .hour,
            value: 32,
            to: nextDay
        ) else {
            return 0
        }

        // تصفير الستريك إذا لم يسجل خلال المهلة
        if now > expiry {
            return 0
        }

        return streak
    }
}
