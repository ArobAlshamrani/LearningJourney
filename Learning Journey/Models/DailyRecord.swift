import Foundation
import SwiftData

// MARK: - Day Status

// يحدد حالة اليوم: تعلم أو تجميد
enum DayStatus: String, Codable {
    case learned
    case frozen
}

// MARK: - Daily Record Model

@Model
final class DailyRecord {

    // MARK: - Properties

    var date: Date // تاريخ التسجيل
    var status: DayStatus // حالة اليوم
    var goalID: UUID? // معرّف الهدف المرتبط بالتسجيل

    // MARK: - Initializer

    // يحدد القيم عند إنشاء سجل جديد
    init(
        date: Date,
        status: DayStatus,
        goalID: UUID? = nil
    ) {
        self.date = date
        self.status = status
        self.goalID = goalID
    }
}

    /*- var goalID: UUID? يحدد الهدف اللي ينتمي له سجل اليوم.
      - self.goalID = goalID يخزن هذا المعرّف داخل السجل.
      - = nil يسمح للسجلات القديمة تكون بدون معرّف إلى أن نعالج ربطها بالأهداف.*/



