import Foundation
import SwiftData

@Model
final class LearningGoal {

    var title: String
    var duration: String
    var startDate: Date
    var isActive: Bool

    init(title: String, duration: String, startDate: Date = .now) {
        self.title = title
        self.duration = duration
        self.startDate = startDate
        self.isActive = true
    }
}
