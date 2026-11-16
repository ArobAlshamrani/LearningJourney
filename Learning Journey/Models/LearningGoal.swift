import Foundation
import SwiftData//- SwiftData: المكتبة نفسها، تحفظ الملفات وتسمح لك ترجعين لها حتى بعد إغلاق التطبيق.

@Model
final class LearningGoal {

    var id: UUID
  /* Universally Unique Identifier، يعني معرّف فريد. وش يعني UUID()؟
   يعطي كل هدف معرّفًا مختلفًا عن الأهداف الثانية. وهذا معرّف إضافي نستخدمه لربط البيانات؛ لأن SwiftData أصلًا يعطي نماذجه هوية داخلية.*/
    var title: String
    var duration: String
    var startDate: Date
    var isActive: Bool

    init(title: String, duration: String, startDate: Date = .now) {
        self.id = UUID()
        self.title = title
        self.duration = duration
        self.startDate = startDate
        self.isActive = true
    }
}
