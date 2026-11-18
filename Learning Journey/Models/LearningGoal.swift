import Foundation
import SwiftData//- SwiftData: المكتبة نفسها، تحفظ الملفات وتسمح لك ترجعين لها حتى بعد إغلاق التطبيق.

@Model
final class LearningGoal {

    var id: UUID
  /* Universally Unique Identifier، يعني معرّف فريد. وش يعني UUID()؟
   يعطي كل هدف معرّفًا مختلفًا عن الأهداف الثانية. وهذا معرّف إضافي نستخدمه لربط البيانات؛ لأن SwiftData أصلًا يعطي نماذجه هوية داخلية.*/
    var title: String // عنوان الهدف
     var duration: String // مدة الهدف
     var startDate: Date // تاريخ بداية الهدف
     var isActive: Bool // يحدد هل الهدف نشط

     // MARK: - Initializer

     // يحدد القيم عند إنشاء هدف جديد
     init(title: String, duration: String, startDate: Date = .now) {
         self.id = UUID()
         self.title = title
         self.duration = duration
         self.startDate = startDate
         self.isActive = true
     }
}
