//
//  Day6_Navigation.swift
//  sample_1
//
//  Created by 駒田隆人 on 2025/10/16.
//
import SwiftUI

struct TodoItem: Identifiable{
    let id = UUID().uuidString
    var title: String = ""
    var isDone: Bool = false
}

struct ListsForEachView: View{
    @State private var newItem = ""
    @State private var items: [TodoItem] = []
    var body: some View{
        NavigationStack{
            VStack{
                HStack{
                    TextField("新しい項目を追加", text: $newItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    Button(action:{
                        guard !newItem.isEmpty else {return}
                        items.append(TodoItem(title: newItem))
                        newItem = ""
                    }){
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
                .padding()
                
                List{
                    ForEach($items){ $item in
                        NavigationLink(destination: DetailView(item: $item)){
                            HStack{
                                Toggle(isOn: $item.isDone){}
                                    .toggleStyle(.switch)
                                    .padding(20)
                                Text(item.title)
                                    .strikethrough(item.isDone, color: .gray)
                                    .foregroundColor(item.isDone ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                        }
                    }
                }
                .navigationTitle("ToDOリスト")
            }
        }
    }
}
struct DetailView: View {
    @Binding var item: TodoItem
    var body: some View{
        VStack(spacing: 20){
            Text(item.title)
                .font(.largeTitle)
                .bold()
            Toggle("完了済み", isOn: $item.isDone)
                .padding()
                .toggleStyle(.switch)
            Spacer()
        }
        .padding()
        .navigationTitle("詳細")
    }
}

#Preview{
    ListsForEachView()
}
