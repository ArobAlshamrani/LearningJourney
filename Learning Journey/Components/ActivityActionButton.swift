import SwiftUI

struct ActivityActionButton: View {
    // MARK: - Properties
    
    let isLogged: Bool //يحدد هل تم تسجيل التعلم
    let action: () -> Void // العملية التي تحدث عند الضغط
    // () -> Void يعني لا يستقبل مدخلات ولا يرجع قيمة

    private let orange = Color(
        red: 1, green: 0.56, blue: 0.15
    )

    // MARK: - Body

    var body: some View {

        Button(action: action) {
            // MARK: - Button Text

            Text(isLogged ? "Logged as Learned" : "Log as Learned")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(
                    isLogged ? Color.gray : Color.white
                )
            // MARK: - Circle Design
                .frame(width: 270, height: 270)
                .background {
                    Circle()
                        .fill(//يغير لون الدائرة حسب حالةالتسجيل
                            isLogged
                            ? Color(red: 0.11, green: 0.11, blue: 0.11)
                            : orange
                        )
                }
            // MARK: - Circle Border
                .overlay {
                    Circle()
                        .stroke( // يظهر الحد عند تسجيل التعلم
                            Color.white.opacity(isLogged ? 0.08 : 0),
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
   
    }
}
