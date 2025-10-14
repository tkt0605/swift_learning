//
//  Day2_CounterView.swift
//  sample_1
//
//  Created by 駒田隆人 on 2025/10/13.
//

import SwiftUI
struct CounterView: View{
    @State private var count = 0
    
    var body: some View{
        VStack(spacing: 20){
            if(count == 10){
                Text("👍すごい!")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                Button("カウントリセット"){
                    withAnimation(.easeInOut(duration: 0.2)){
                        count = 0
                    }
                }
                .font(.title3)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }else{
                Text("カウント: \(count)")
                    .font(.largeTitle)
                    .bold()
                Button("カウントアップ"){
                    withAnimation(.easeInOut(duration: 0.25)){
                        count += 1
                    }
                }
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .padding()
    }
}
#Preview {
    CounterView()
}
