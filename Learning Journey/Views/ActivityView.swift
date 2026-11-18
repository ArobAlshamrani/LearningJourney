import SwiftUI
import SwiftData

struct ActivityView: View {
    
 // MARK: - Properties
    @Environment(\.modelContext)
    private var modelContext // الوصول إلى SwiftData

    // MARK: - Goal Duration
    // يقرأ مدة الهدف الحالي من SwiftData
    private var goalDuration: String {
        viewModel.activeGoal?.duration ?? "Week"
    }// مدة الهدف المحفوظة
    
    // MARK: - Goal Result
    let previewResult: GoalResult?
    init(previewResult: GoalResult? = nil) {
        self.previewResult = previewResult
    }
    // MARK: - Date
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")//Always English
        formatter.dateFormat = "EEEE, d MMMM"
        //EEEE = اسم اليوم كامل
        return formatter.string(from: Date())
    }
    
    @State private var viewModel = LearningViewModel()
    @State private var showEditGoal = false
   
    private var todayStatus: DayStatus? {

        guard let goalID = viewModel.activeGoal?.id else {
            return nil
        }

        return viewModel.records.first {
            Calendar.current.isDateInToday($0.date)
            && $0.goalID == goalID
        }?.status
    }

    private var didLearnToday: Bool {
        todayStatus == .learned
    }

    private var didFreezeToday: Bool {
        todayStatus == .frozen
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 24) {
            // 1. Header
            HStack(alignment: .top, spacing: 12) {
                
                // كود العنوان والتاريخ والأيقونات
                VStack(alignment: .leading, spacing: 8) {
                    Text("Activity")
                        .font(.largeTitle)
                        .bold()
                    
                    Text(formattedDate)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                //NavigationLink for CalendarView
                NavigationLink {
                    CalendarView(viewModel: viewModel)
                } label: {
                    Image(systemName: "calendar")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .glassEffect(
                            .regular.tint(.white.opacity(0.15)),
                            in: Circle()
                        )
                      
                }
                .buttonStyle(.plain)
                
                
                //NavigationLink for EditGoalView
                
                NavigationLink {
                    EditGoalView(viewModel: viewModel)
                } label: {
                    
                    Image(systemName: "pencil.and.outline")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .glassEffect(
                            .regular.tint(.white.opacity(0.15)),
                            in: Circle()
                        )
                     }
                .buttonStyle(.plain)// Removes the default button style

            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            // 2. Weekly Calendar
            HStack(spacing: 0) {
                ForEach(weekDates, id: \.self) { date in

                    let dayRecords = viewModel.records.filter {
                        Calendar.current.isDate(
                            $0.date,
                            inSameDayAs: date
                        )
                    }

                    let record = dayRecords.first {
                        $0.goalID == viewModel.activeGoal?.id
                    } ?? (
                        Calendar.current.isDateInToday(date)
                        ? nil
                        : dayRecords.first
                    )

                    WeekDayCell(
                        date: date,
                        status: record?.status
                    )
                }


            }
            // MARK: - Statistics Cards

            HStack(spacing: 12) {

                // Current Streak
                StatCardView(
                    count: viewModel.activeGoal.map {
                        viewModel.calculateStreak(
                            goalStartDate: $0.startDate
                        )
                    } ?? 0,
                    title: "Streak",
                    symbol: "flame.fill",
                    symbolColor: .orange
                )

                // Used Freezes
                StatCardView(
                    count: viewModel.freezesUsed,
                    title: "Freezed",
                    symbol: "snowflake",
                    symbolColor: .cyan
                )
            }
          
            // MARK: - Goal Status
            if let result = previewResult ?? viewModel.goalWasMet.map({
                $0 ? GoalResult.completed : GoalResult.notMet
            }) {

                GoalResultView(result: result) {
                    showEditGoal = true
                }
                .padding(.top, 45)

            }
            else {
                // MARK: - Learning Action
                ActivityActionButton(isLogged: didLearnToday) {
                    viewModel.toggleToday(.learned, in: modelContext)
                }
                
                .frame(maxWidth: .infinity)
                .padding(.top, 45)
                
                
                // MARK: - Freeze Button
                VStack(spacing: 10) {
                    
                    Button {
                        viewModel.toggleToday(.frozen, in: modelContext)
                    } label: {
                        Text(didFreezeToday ? "Freezed for a day" : "Freeze for a day")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(
                                didFreezeToday ? .gray : .white
                            )
                            .frame(maxWidth: 280)
                            .frame(height: 44)
                            .background(
                                didFreezeToday
                                ? Color(red: 0.11, green: 0.11, blue: 0.11)
                                : Color(red: 0.17, green: 0.78, blue: 0.93),
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(
                        viewModel.freezesUsed >= viewModel.freezeLimit(for: goalDuration)
                        && !didFreezeToday
                    )
                    Text("\(viewModel.freezesUsed) out of \(viewModel.freezeLimit(for: goalDuration)) Freezes used")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 35)
            } // End of else
            
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .onAppear {
            viewModel.loadRecords(from: modelContext)
        }
        .navigationDestination(isPresented: $showEditGoal) {
            EditGoalView(viewModel: viewModel)
        }
         }
    
    private var weekDates: [Date] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 1
        
        guard let start = calendar.dateInterval(
            of: .weekOfYear,
            for: Date()
        )?.start else {
            return []
        }
        
        return (0..<7).compactMap { day in
            calendar.date(
                byAdding: .day,
                value: day,
                to: start
            )
        }
    }
}
#Preview {
    ActivityView()
        .preferredColorScheme(.dark)
}

