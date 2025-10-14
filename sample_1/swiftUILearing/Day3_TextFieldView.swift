//
//  Day3_TextFieldView.swift
//  sample_1
//
//  Created by 駒田隆人 on 2025/10/13.
//
import SwiftUI

struct TextFieldView: View{
    @State private var name = "" // 変数定義
    @State private var MaxLength: Int = 15
    var body: some View{
        TextField("名前を入力してください。", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .onChange(of: name) { oldValue, newValue in
                if newValue.count > 10 {
                    name = String(newValue.prefix(15))
                }
            }
        if !name.isEmpty{
            Text("こんにちは！ \(name)")
                .font(.title)
                .bold()
            if (name.count > 10) {
                Text("⚠️ 入力された文字数が10文字を超えています。")
                    .font(.title)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .padding()
                    .bold()
            }else{
                Text("入力された名前の文字数 \(name.count)")
                    .font(.title2)
                    .foregroundStyle(.green)
                    .clipShape(Capsule())
                    .padding()
                    .bold()
            }
        }else{
            Text("名前を入力すると、挨拶します。")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    TextFieldView()
}
