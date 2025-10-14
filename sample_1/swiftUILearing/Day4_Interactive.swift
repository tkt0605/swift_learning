//
//  Day4_Interactive.swift
//  sample_1
//
//  Created by 駒田隆人 on 2025/10/14.
//

import SwiftUI

struct InteractiveView: View {
    @State private var isDarkMode = false
    @State private var volume: Double = 0.5
    @State private var level: Int = 1
    var body: some View{
        VStack(spacing: 30){
            Toggle(isDarkMode ? "🌙" : "☀️" , isOn: $isDarkMode)
                .foregroundColor(isDarkMode ? .white : .black)
                .padding()
            VStack{
                Text("音量: \(Int(volume * 100))%")
                    .foregroundColor(isDarkMode ?  .white : .black)
                Slider(value: $volume, in:0...1)
            }
            .padding()
            Stepper("レベル: \(level)", value: $level, in:0...10)
                .foregroundColor(isDarkMode ? .white : .black)
                .padding()
//            Stepper {
//                Text("レベル: \(level)")
//                    .foregroundStyle(isDarkMode ? .black : .white)
//                    .bold()
//            }onIncrement: {
//                if level < 10 {
//                    level += 1
//                }
//            }onDecrement: {
//                if level > 0 {
//                    level -= 1
//                }
//            }
            .padding()
            Spacer()
        }
        .padding()
        .background(isDarkMode ? Color.black : Color.white)
        .animation(.easeInOut(duration: 0.3), value: isDarkMode)
    }
}
#Preview {
    InteractiveView()
}
