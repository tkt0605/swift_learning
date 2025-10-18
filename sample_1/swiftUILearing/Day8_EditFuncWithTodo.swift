//
//  Day8_EditFuncWithTodo.swift
//  sample_1
//
//  Created by 駒田隆人 on 2025/10/18.
//

import SwiftUI

struct TodosItem: Identifiable, Codable, Equatable{
    let id: String
    var title: String
    var isDone: Bool
    init(id: String = UUID().uuidString, title: String, isDone: Bool = false){
        self.id = id
        self.title = title
        self.isDone = isDone
    }
}
struct PersistentToDOView: View{
    @State private var newItem = ""
    @State private var items: [TodosItem] = []{
        didSet{
            SaveItem()
        }
    }
    var body: some View{
        NavigationStack{
            VStack{
                HStack{
                    TextField("新しい項目を追加してください。", text: $newItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    Button{
                        guard !newItem.isEmpty else{return}
                        items.append(TodosItem(title: newItem))
                        newItem = ""
                    } label: {
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
                .navigationTitle("ToDOエヂィター")
                .navigationDestination(for: String.self) {id in
                    if let $item = optionalBindings(for: id) {
                        EditableDetailView(item: $item)
                    }else{
                        Text("項目が存在しません。")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onAppear(perform: LoadItems)
        }
    }
    private func binding(for item: TodosItem) -> Binding<TodosItem>{
        guard let index = items.firstIndex(of: item) else{
            return .constant(TodosItem(title: "Error"))
        }
        return $items[index]
    }
    
    private func optionalBindings(for id: String)  -> Binding<TodosItem>? {
        guard let index = items.firstIndex(where: { $0.id == id }) else {return nil}
        return $items[index]
    }
    
    private func SaveItem(){
        if let encoded = try? JSONEncoder().encode(items){
            UserDefaults.standard.set(encoded, forKey: "TodosItem")
        }
    }
    
    private func LoadItems(){
        if let data = UserDefaults.standard.data(forKey: "TodosItem"),
           let decoded = try? JSONDecoder().decode([TodosItem].self, from: data){
            items = decoded
        }
    }
    
    private func deleteItem(at offsets: IndexSet){
        items.remove(atOffsets: offsets)
    }
}

struct EditableDetailView: View {
    @Binding var item: TodosItem
    @State private var isEditing = false
    @FocusState private var focus: Bool
    var body: some View {
        VStack(spacing: 20){
            if isEditing{
                TextField("タイトルを入力", text: $item.title)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($focus)
                    .onSubmit {
                        isEditing = false
                    }
            }else{
                Text(item.title)
                    .font(.largeTitle)
                    .bold()
                    .onTapGesture {
                        isEditing = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                            focus = true
                        }
                    }
            }
            Toggle("完了", isOn: $item.isDone)
                .padding()
                .toggleStyle(.switch)
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: isEditing)
        .navigationTitle("\(item.title)・編集")
    }
}

#Preview{
    PersistentToDOView()
}
