import SwiftUI

struct ActivityActionButton: View {

    let isLogged: Bool //يحدد هل تم تسجيل التعلم

    let action: () -> Void//يستقبل العملية اللي تحدث عند الضغط


    private let orange = Color(
        red: 1, green: 0.56, blue: 0.15
    )

    var body: some View {

        Button(action: action) {

            Text(isLogged ? "Logged as Learned" : "Log as Learned")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(
                    isLogged ? Color.gray : Color.white
                )
                .frame(width: 270, height: 270)
                .background {
                    Circle()
                        .fill(//يغير لون الدائرة حسب الحالة

                            isLogged
                            ? Color(red: 0.11, green: 0.11, blue: 0.11)
                            : orange
                        )
                }
                .overlay {
                    Circle()
                        .stroke(
                            Color.white.opacity(isLogged ? 0.08 : 0),
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
   
    }
}
