//
//  Day7_PersistentTodo.swift
//  sample_1
//
//  Created by 駒田隆人 on 2025/10/16.
//

import SwiftUI

struct ToDOItems: Identifiable, Codable, Equatable {
    let id: String
    var title: String
    var isDone: Bool
    
    init(id: String = UUID().uuidString, title: String, isDone: Bool = false){
        self.id = id
        self.title = title
        self.isDone = isDone
    }
}

struct PresistentToDOView: View {
    @State private var newItem = ""
    @State private var items: [ToDOItems] = []{
        didSet{
            saveItems()
        }
    }
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    TextField("新しい項目を追加", text: $newItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button( action: {
                        guard !newItem.isEmpty else {return}
                        items.append(ToDOItems(title: newItem))
                        newItem = ""
                    }){
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
                .padding()
                List{
                    ForEach(items){ item in
                        NavigationLink(value: item.id){
                            HStack{
                                Toggle(isOn: binding(for: item).isDone){}
                                    .toggleStyle(.switch)
                                    .padding(10)
                                Text(item.title)
                                    .strikethrough(item.isDone, color: .gray)
                                    .foregroundColor(item.isDone ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
                .navigationTitle("保存付きToDOリスト")
                .navigationDestination(for: String.self){ id in
                    if let $item = optionalBinding(for: id) {
                        DetailsView(item: $item)
                    }else{
                        Text("項目が存在しません。")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onAppear(perform: loadItem)
        }
    }
    private func binding(for item: ToDOItems) -> Binding<ToDOItems> {
        guard let index = items.firstIndex(of: item) else {
            // もし見つからなければダミー値（クラッシュ防止）
            return .constant(ToDOItems(title: "エラー"))
        }
        return $items[index]
    }
    // ToDOItemsでデータが見つかりなかったら、nilを返すために、?を入れる。
    private func optionalBinding(for id: String) -> Binding<ToDOItems>?{
        guard let index = items.firstIndex(where: { $0.id == id}) else {return nil}
        return $items[index]
    }
    func saveItems(){
        if let encoded = try? JSONEncoder().encode(items){
            UserDefaults.standard.set(encoded, forKey: "ToDOItems")
        }
    }
    func loadItem() {
        if let data = UserDefaults.standard.data(forKey: "ToDOItems"),
           let decoded = try? JSONDecoder().decode([ToDOItems].self, from: data){
            items = decoded
        }
    }
    func deleteItem(at offsets: IndexSet){
        items.remove(atOffsets: offsets)
    }
}

struct DetailsView: View{
    @Binding var item: ToDOItems
    
    var body: some View{
        VStack(spacing: 20){
            Text(item.title)
                .font(.largeTitle)
                .bold()
            Toggle("完了", isOn: $item.isDone)
                .padding()
                .toggleStyle(.switch)
            Spacer()
        }
        .padding()
        .navigationTitle("\(item.title)の詳細")
    }
}
//#Preview(){
//    PresistentToDOView()
//}
