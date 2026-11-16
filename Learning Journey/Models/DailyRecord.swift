import Foundation
import SwiftData

enum DayStatus: String, Codable {
    /*Codable
     يخلينا نحول البيانات لصيغة قابلة للحفظ والاسترجاع، مثل JSON.*/
    case learned
    case frozen
}

@Model
final class DailyRecord {

    var date: Date
    var status: DayStatus
    var goalID: UUID?

   
    init(
        date: Date,
        status: DayStatus,
        goalID: UUID? = nil
    ) {
        self.date = date
        self.status = status
        self.goalID = goalID
    }
    /*- var goalID: UUID? يحدد الهدف اللي ينتمي له سجل اليوم.
      - self.goalID = goalID يخزن هذا المعرّف داخل السجل.
      - = nil يسمح للسجلات القديمة تكون بدون معرّف إلى أن نعالج ربطها بالأهداف.*/

}

