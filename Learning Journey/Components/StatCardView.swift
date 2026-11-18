
import SwiftUI

struct StatCardView: View {

    // MARK: - Properties

    let count: Int // عدد الأيام
    let title: String // عنوان الكارد
    let symbol: String // اسم الأيقونة
    let symbolColor: Color // لون الأيقونة

    // MARK: - Body

    var body: some View {

        VStack(spacing: 6) {

            // MARK: - Card Icon

            Image(systemName: symbol)
                .font(.system(size: 22))
                .foregroundStyle(symbolColor)

            // MARK: - Days Count

            // يعرض day للمفرد و days للجمع
            Text("\(count) \(count == 1 ? "day" : "days")")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)

            // MARK: - Card Title

            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(.gray)
        }

        // MARK: - Card Design

        .frame(maxWidth: .infinity) // عرض مرن
        .frame(height: 92) // ارتفاع ثابت
        .glassEffect(
            .regular,
            in: RoundedRectangle(cornerRadius: 24)
        )
    }
}
