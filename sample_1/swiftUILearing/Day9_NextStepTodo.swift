//
//  Day9_NextStepTodo.swift
//  sample_1
//
//  Created by 駒田隆人 on 2025/10/19.
//

import SwiftUI
import UIKit

//プライオリチィーのバー
enum Priority: String, Codable, CaseIterable{
    case high = "高"
    case medium = "中"
    case low = "低"
}

//ToDOのDB
struct ToDOsItem: Identifiable, Codable, Equatable{
    let id: String
    var title: String
    var isDone: Bool
    var priority: Priority
    var createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        title: String,
        isDone: Bool = false,
        priority: Priority = .medium,
        createdAt: Date = Date()
    ){
        self.id = id
        self.title = title
        self.isDone = isDone
        self.priority = priority
        self.createdAt = createdAt
    }
}

//基本的なToDOの機能
struct PersistentToDOsView: View {
    @State private var newItem = ""
    //プライオリティの選択
    @State private var selectedPriority: Priority = .medium
    @State private var items: [ToDOsItem] = []{
        didSet {
            saveItems_1()
        }
    }
    
    private var completionRate: Double {
        guard !items.isEmpty else {return 0.0 }
        let doneCount = items.filter{ $0.isDone }.count
        return Double(doneCount) / Double(items.count)
    }
    var body: some View {
        NavigationStack{
            VStack(spacing: 16){
                //進捗バー
                VStack(alignment: .leading){
                    Text("進捗率: \(Int(completionRate * 100))%")
                        .font(.subheadline)
                        .bold()
                    ProgressView(value: completionRate)
                        .tint(.green)
                        .animation(.easeInOut, value: completionRate)
                }
                .padding(.horizontal)
                //追加フォーム
                HStack{
                    TextField("新しい項目を追加", text: $newItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Picker("優先度", selection: $selectedPriority){
                        ForEach(Priority.allCases, id: \.self){ level in
                            Text(level.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                    Button{
                        guard !newItem.isEmpty else {return}
                        items.append(ToDOsItem(title: newItem, priority: selectedPriority))
                        newItem = ""
                    }label:{
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal)
                
                List{
                    ForEach(items){ item in
                        NavigationLink(value: item.id){
                            TodoCardView(item: binding(for: item))
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
                .listStyle(.plain)
                .navigationTitle("Clearswift ToDos")
                //詳細画面への遷移処理
                .navigationDestination(for: String.self){ id in
                    if let item = optionalBinding_1(for: id){
                        EditableDetailsView(item: item)
                    }else{
                        Text("項目がありません。")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onAppear(perform: LoadItems_1)
        }
    }
  
    private func binding(for item: ToDOsItem) -> Binding<ToDOsItem>{
        guard let index = items.firstIndex(of: item) else{
            
            return .constant(ToDOsItem(title: "Error"))
        }
        return $items[index]
    }
    
    private func optionalBinding_1(for id: String) -> Binding<ToDOsItem>?{
        guard let index = items.firstIndex(where: { $0.id == id}) else { return nil }
        return $items[index]
    }
    
    private func saveItems_1(){
        if let encoded = try? JSONEncoder().encode(items){
            UserDefaults.standard.set(encoded, forKey: "ToDosItem")
        }
    }
    
    private func LoadItems_1(){
        if let data = UserDefaults.standard.data(forKey: "ToDOsItem"),
            let decoded = try? JSONDecoder().decode([ToDOsItem].self, from: data){
            items = decoded
        }
    }
    
    private func deleteItem(at offsets: IndexSet){
        items.remove(atOffsets: offsets)
    }
}

struct TodoCardView: View {
    @Binding var item: ToDOsItem
    private var priorityColor: Color{
        switch item.priority {
        case .high:
                .red.opacity(0.8)
        case .medium:
                .orange.opacity(0.7)
        case .low:
                .blue.opacity(0.6)
        }
    }
    var body: some View {
        HStack(spacing: 12){
            Rectangle()
                .fill(priorityColor)
                .frame(width: 6)
                .cornerRadius(3)
            VStack(alignment: .leading, spacing: 5){
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(item.isDone ? .gray : .primary)
                    .strikethrough(item.isDone, color: .gray)
                Text(item.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Toggle("", isOn: $item.isDone)
                .labelsHidden()
        }
        .padding(8)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

struct EditableDetailsView: View {
    @Binding var item: ToDOsItem
    @State private var isEditing = false
    @FocusState private var focus: Bool
    var body: some View {
        VStack(spacing: 20){
            if isEditing{
                TextField("タイトルを入力", text: $item.title)
                    .font(.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focus)
                    .onSubmit { isEditing = false}
            }else{
                Text(item.title)
                    .font(.largeTitle)
                    .bold()
                    .onTapGesture {
                        isEditing = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ focus = true }
                    }
            }
            Toggle("完了", isOn: $item.isDone)
                .toggleStyle(.switch)
            Picker("優先度", selection: $item.priority){
                ForEach(Priority.allCases, id: \.self){ p in
                    Text(p.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.vertical)
            
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: isEditing)
        .navigationTitle("\(item.title)・編集モード")
    }
}
#Preview{
    PersistentToDOsView()
}
