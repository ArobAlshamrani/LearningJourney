import Foundation
import Observation
import SwiftData

@Observable
final class LearningViewModel {
    
    // MARK: - Daily Records
    
    var records: [DailyRecord] = []
    var activeGoal: LearningGoal?//معناه: الهدف الحالي اللي بنحسب له Learned وFreeze والـStreak.
    
    
    // MARK: - Load Saved Data
   //ModelContext: نوع يوفره SwiftData للتعامل مع البيانات المخزنة، مثل جلبها وإضافتها وحذفها وحفظ التغييرات.
    func loadRecords(from context: ModelContext) {
        do {
            // Load daily records
            records = try context.fetch(
                FetchDescriptor<DailyRecord>()//حدد نوع البيانات اللي نبي نجلبها، وهو DailyRecord.
            )
            let today = Calendar.current.startOfDay(for: Date())

            for record in records {
                if Calendar.current.startOfDay(for: record.date) > today {
                    context.delete(record)
                }
            }

            try context.save()

            records = try context.fetch(
                FetchDescriptor<DailyRecord>()
            )
            // Load active goal
            let goals = try context.fetch(
                FetchDescriptor<LearningGoal>()
            )

            activeGoal = goals.first {
                $0.isActive
            }
            

        } catch {
            print("Failed to load data: \(error)")
        }
    }


    
    // MARK: - Daily Action

    func toggleToday(
        _ status: DayStatus,
        in context: ModelContext
    ) {
        guard let goalID = activeGoal?.id else {
            return
        }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        do {
            // Read the latest saved records
            let descriptor = FetchDescriptor<DailyRecord>()
            let savedRecords = try context.fetch(descriptor)

            // Find records for today and this goal
            let todayRecords = savedRecords.filter {
                calendar.isDate($0.date, inSameDayAs: today)
                && $0.goalID == goalID
            }

            if todayRecords.count == 1,
               let record = todayRecords.first,
               record.status == status {

                // Undo the selected action
                context.delete(record)

            } else if let record = todayRecords.first {

                // Update the existing record
                record.status = status

                // Remove duplicate records
                for duplicate in todayRecords.dropFirst() {
                    context.delete(duplicate)
                }

            } else {

                // Create a new record
                let record = DailyRecord(
                    date: Date(), // يحفظ وقت التسجيل الفعلي
                    status: status,
                    goalID: goalID
                )

                context.insert(record)
            }

            try context.save()
            loadRecords(from: context)

        } catch {
            context.rollback()
            loadRecords(from: context)
            print("Failed to update daily record: \(error)")
        }
    }

    // MARK: - Streak

    func calculateStreak(goalStartDate: Date) -> Int {

        guard let goalID = activeGoal?.id else {
            return 0
        }

        // حساب سجلات الهدف الحالي فقط
        let goalRecords = records.filter {
            $0.goalID == goalID
        }

        return StreakCalculator.calculate(
            records: goalRecords,
            goalStartDate: goalStartDate
        )
        
    }
    // MARK: - Goal Result
    /*true → الهدف مكتمل، نعرض Well done!
     false → انتهت المدة بدون تحقيق الهدف، نعرض Goal Not Met.
     nil → التحدي لسه مستمر.*/
    
    var goalWasMet: Bool? {

        guard let goal = activeGoal else { return nil }

        let calendar = Calendar.current
        let start = calendar.startOfDay(for: goal.startDate)

        let end: Date?

        switch goal.duration {
        case "Week":
            end = calendar.date(byAdding: .day, value: 7, to: start)
        case "Month":
            end = calendar.date(byAdding: .month, value: 1, to: start)
        case "Year":
            end = calendar.date(byAdding: .year, value: 1, to: start)
        default:
            return nil
        }

        guard let end else { return nil }

        let requiredDays = calendar.dateComponents(
            [.day], from: start, to: end
        ).day ?? 0

        let goalRecords = records.filter {
            $0.goalID == goal.id &&
            $0.date >= start &&
            $0.date < end
        }

        let completedDays = Set(goalRecords.map {
            calendar.startOfDay(for: $0.date)
        }).count

        let usedFreezes = goalRecords.filter {
            $0.status == .frozen
        }.count

        let success =
            completedDays == requiredDays &&
            usedFreezes <= freezeLimit(for: goal.duration)

        if success {
            return true
        }

        return Date() >= end ? false : nil
    }

    // MARK: - Freeze Limit
    
    func freezeLimit(for duration: String) -> Int {
        switch duration {
        case "Week":
            return 2
        case "Month":
            return 8
        case "Year":
            return 96
        default:
            return 2
        }
    }
    
    // MARK: - Used Freezes
    var freezesUsed: Int {
        guard let goalID = activeGoal?.id else { return 0 }

        return records.filter {
            $0.goalID == goalID && $0.status == .frozen
            //$0.status == .frozen: نختار الأيام المجمدة فقط.
        }.count
    }

    // MARK: - Learned Days

    var learnedDays: Int {
        guard let goalID = activeGoal?.id else { return 0 }

        return records.filter {
            $0.goalID == goalID && $0.status == .learned
        }.count
    }
    
    // MARK: - Update Goal

    func updateGoal(
        title: String,
        duration: String,
        in context: ModelContext
    ) throws {

        let goals = try context.fetch(
            FetchDescriptor<LearningGoal>()
        )

        // Deactivate previous goal
        for goal in goals where goal.isActive {
            goal.isActive = false
        }

        // Create new goal
        let newGoal = LearningGoal(
            title: title,
            duration: duration
        )

        context.insert(newGoal)

        do {
            try context.save()
            activeGoal = newGoal
        } catch {
            context.rollback()
            throw error
        }
    }



}
