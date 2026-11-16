import SwiftUI

struct StatCardView: View {

    let count: Int
    let title: String
    let symbol: String
    let symbolColor: Color

    var body: some View {

        VStack(spacing: 6) {

            Image(systemName: symbol)
                .font(.system(size: 22))
                .foregroundStyle(symbolColor)

            Text("\(count) \(count == 1 ? "day" : "days")")//وهو اختصار لشرط if / else.
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)

            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 92)
        .appGlass(.card)
    }
}
