import SwiftUI

struct ContentView: View {
    @State private var numberGrades: [Int] = Array(repeating: 0, count: 7)
    @State private var classTypes: [Int] = Array(repeating: 0, count: 7)
    
    let classTypeOptions = ["Regular", "Honors", "Dual-Credit", "AP"]
    
    func saveData() {
        UserDefaults.standard.set(numberGrades, forKey: "numberGrades")
        UserDefaults.standard.set(classTypes, forKey: "classTypes")
    }
    
    func loadData() {
        if let savedNumberGrades = UserDefaults.standard.array(forKey: "numberGrades") as? [Int],
           let savedClassTypes = UserDefaults.standard.array(forKey: "classTypes") as? [Int] {
            numberGrades = savedNumberGrades
            classTypes = savedClassTypes
        }
    }
    
    func singleClassGPA(grade: Int, classType: Int) -> Double {
        let maxGPA: Double
        
        switch classType {
        case 0:
            maxGPA = 4.0
        case 1:
            maxGPA = 5.0
        case 2:
            maxGPA = 5.5
        case 3:
            maxGPA = 6.0
        default:
            maxGPA = 4.0
        }
        
        return maxGPA - (Double(100 - grade) * 0.1)
    }
    
    func overallGPA() -> Double {
        var sum = 0.0
        
        for i in 0..<7 {
            sum += singleClassGPA(grade: numberGrades[i], classType: classTypes[i])
        }
        
        return sum / 7.0
    }
    
    var body: some View {
        VStack {
            ForEach(0..<7) { i in
                HStack {
                    TextField("Grade \(i+1)", value: $numberGrades[i], formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .padding()
                        .onChange(of: numberGrades[i], perform: { _ in
                            saveData()
                        })
                    
                    Picker("Class Type", selection: $classTypes[i]) {
                        ForEach(0..<classTypeOptions.count) { index in
                            Text(classTypeOptions[index]).tag(index)
                        }
                    }.pickerStyle(MenuPickerStyle())
                    .frame(width: 150, height: 40)
                    .onChange(of: classTypes[i], perform: { _ in
                        saveData()
                    })
                }
            }
            
            Text("Weighted GPA: \(overallGPA(), specifier: "%.3f")")
                .font(.largeTitle)
                .padding(.top)
        }
        .padding()
        .onAppear(perform: loadData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
