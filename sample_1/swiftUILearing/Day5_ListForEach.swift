//
//  Day5_ListForEach.swift
//  sample_1
//
//  Created by 駒田隆人 on 2025/10/15.
//

import SwiftUI

//List・ForEachで識別子として使用する構造体。
struct ToDOItem: Identifiable {
    let id = UUID().uuidString
    var title: String
    var isDone: Bool = false
}
struct ListForEachView: View {
    //テキストフィールドの入力を保持
    @State private var newItem = ""
    //ToDOの配列データ取得
    @State private var items: [ToDOItem] = []
    var body: some View {
        VStack{
            HStack{
                //入力フォーム・$newItemでバインディング）
                TextField("新しい項目を生成", text:$newItem)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                //入力内容をToDOに追加
                Button(action:{
                    //空文字にならないように設定。
                    guard !newItem.isEmpty else {return}
                    items.append(ToDOItem(title: newItem))
                    newItem = ""
                }){
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
            .padding()
            
            List{
////           indexを用いて、配列要素を双方向接続する。
//                ForEach(items.indices, id: \.self){ index in
//                    HStack{
//                        //チェック状態の切り替えのUI
//                        Toggle(isOn: $items[index].isDone) {
//                            Text(items[index].isDone ? "完了" : "未完了")
//                        }
//                        .toggleStyle(.switch)
//                        .padding(.trailing)
//                        //ToDOのタイトルのみを表示
//                        Text(items[index].title)
//                            //完了していれば、打ち消し線をつける。
//                            .strikethrough(items[index].isDone, color: .gray)
//                            .foregroundColor(items[index].isDone ? .gray : .primary)
//                        
//                        Spacer()
//                        
//                        Button{
//                            items.removeAll{ $0.id == items[index].id }
//                        }label: {
//                            Image(systemName: "trash")
//                                .foregroundColor(.red)
//                            
//                        }
//
//                    }
//                }
                ForEach($items){ $item in
                    HStack{
                        Toggle(isOn: $item.isDone) {
                        }
                        .toggleStyle(.switch)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(item.title)
                            .strikethrough(item.isDone, color:  Color.gray)
                            .foregroundColor(item.isDone ? .gray : .primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button{
                            items.removeAll{ $0.id == item.id }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ListForEachView()
}
