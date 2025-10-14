//
//  Day5_ListForEach.swift
//  sample_1
//
//  Created by 駒田隆人 on 2025/10/15.
//

import SwiftUI
struct ToDOItem: Identifiable {
    let id = UUID()
    var title: String
    var isDone: Bool = false
}
struct ListForEachView: View {
    @State private var newItem = ""
    @State private var items: [ToDOItem] = []
    var body: some View {
        VStack{
            HStack{
                TextField("新しい項目を生成", text:$newItem)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action:{
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
                ForEach(items.indices, id: \.self){ index in
                    HStack{
                        Toggle(isOn: items[index].isDone) {
                            Text(items[index].isDone ? "完了" : "未完了")
                        }
                        .toggleStyle(.switch)
                        .padding(.trailing)
                        
                        Text(index.title)
                            .strikethrough(index.isDone, color: .gray)
                            .foregroundColor(index.isDone ? .gray : .primary)
                        
                        Spacer()
                        
                        Button{
                            items.removeAll{ $0.id == index.id }
                        }label: {
                            Image(systemName: "trash"){
                                .foregroundColor(.red)
                            }
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
