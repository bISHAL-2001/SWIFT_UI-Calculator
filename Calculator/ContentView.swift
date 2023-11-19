//
//  ContentView.swift Calculator
//
//  Created by Bishal Kumar Ghosh.
//

import SwiftUI

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case mutliply = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"

    var buttonColor: Color {
        switch self {
        case .add, .subtract, .mutliply, .divide, .equal:
            return .blue
        case .clear, .negative, .percent:
            return Color(.lightGray)
        case .decimal, .zero:
            return .yellow
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

extension String {
    var isNumber: Bool {
        return self.range(
            of: "^[0-9]*$", // 1
            options: .regularExpression) != nil
    }
}

extension Float {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

struct ContentView: View {

    @State var value = "0"
    @State var runningNumber = 0.0
    @State var currentOperation: Operation = .none

    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .mutliply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Text display
                HStack {
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                }.padding()

                // Our buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 30))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    func didTap(button: CalcButton) {
        
        switch button {
        case .add, .subtract, .mutliply, .divide, .equal:
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Double(self.value) ?? 0
            }
            else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Double(self.value) ?? 0
            }
            else if button == .mutliply {
                self.currentOperation = .multiply
                self.runningNumber = Double(self.value) ?? 0
            }
            else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Double(self.value) ?? 0
            }
            else if button == .equal {

                let runningValue = self.runningNumber
                let currentValue = Double(self.value) ?? 0.0
                
                print(runningValue, currentValue, self.value)
                switch self.currentOperation {
                    
                    case .add:
                        self.value = "\(runningValue + currentValue)"
                        self.value = String(format: "%0.3f", Double(self.value) ?? 0.0)
                        self.value = String(Float(self.value)?.cleanValue ?? "")
                        print("Adding")
                        
                        self.currentOperation = .none
                        break
                        
                    case .subtract:
                        self.value = "\(runningValue - currentValue)"
                        self.value = String(format: "%0.3f", Double(self.value) ?? 0.0)
                        self.value = String(Float(self.value)?.cleanValue ?? "")
                        print("Subtracting")

                        self.currentOperation = .none
                        break
                        
                    case .multiply:
                        self.value = "\(runningValue * currentValue)"
                        self.value = String(format: "%0.3f", Double(self.value) ?? 0.0)
                        self.value = String(Float(self.value)?.cleanValue ?? "")
                        print("Multiplying")
                        
                        self.currentOperation = .none
                        break
                        
                    case .divide:
                        self.value = "\(runningValue / currentValue)"
                        self.value = String(format: "%0.3f", Double(self.value) ?? 0.0)
                        self.value = String(Float(self.value)?.cleanValue ?? "")
                        print("Dividing")
                    
                        self.currentOperation = .none
                        break
                    
                    case .none:
                        print("Hello")
                        break
                }
            }
            else if button == .decimal{
                let runningValue = self.runningNumber
                let currentValue = Double(self.value) ?? 0
                self.value = "\(runningValue / currentValue)"
                self.value = String(Float(self.value)?.cleanValue ?? "")
            }

            if button != .equal {
                self.value = "0"
            }
        case .clear:
            self.value = "0"
        case .decimal:
            if (self.value).isNumber {
                let val = self.value + "."
                self.value = val
                self.runningNumber = Double(self.value) ?? 0
            }
        case .negative:
            let currentValue = Double(self.value) ?? 0
            self.value = "\(currentValue * -1)"
            self.value = String(Float(self.value)?.cleanValue ?? "")
        case .percent:
            let currentValue = Double(self.value) ?? 0
            self.value = "\(currentValue / 100)"
            self.value = String(format: "%0.7f", Double(self.value) ?? 0.0)
            self.value = String(Float(self.value)?.cleanValue ?? "")
        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            }
            else {
                self.value = "\(self.value)\(number)"
            }
        }
    }

    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
