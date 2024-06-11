//
//  TodoListPage.swift
//  TodoList
//
//  Created by 橋本丈太郎 on 2024/05/05.
//

import SwiftUI

struct ToDoItem {
    var isChecked: Bool
    var task: String
}

struct TodoListPage: View {
    @State var newTask: String = ""
    @State var todoLists: [ToDoItem] = []
    @State var showAlert = false
    @State var text = ""
    
    // 現在の日付を取得する関数
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: Date())
    }
    
    var body: some View {
        VStack {
            Text(getCurrentDate())
            ForEach(todoLists.indices, id: \.self) { index in
                HStack {
                    Button(action: {
                        todoLists[index].isChecked.toggle()
                    }, label: {
                        Image(systemName:
                                todoLists[index].isChecked ? "checkmark.square" : "square"
                        )
                        .imageScale(.large)
                        .foregroundStyle(.pink)
                    })
                    if todoLists[index].isChecked {
                        Text(todoLists[index].task)
                            .strikethrough()
                    } else {
                        Text(todoLists[index].task)
                    }
                }
                .padding(.top, 1)
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            Button {
                showAlert = true
            } label: {
                Text("＋")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .frame(width:80, height:80)
                    .background(Color("bottonColor"))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            }
        }
        .alert("タスクの追加", isPresented: $showAlert, actions: {
            TextField("新規タスク", text: $newTask)
            Button("キャンセル", action: {})
            Button("追加する", action: {
                if !newTask.isEmpty {
                    todoLists.append(
                        ToDoItem(isChecked: false, task: newTask)
                    )
                    newTask = ""
                }
            })
        })
    }
}

#Preview {
    TodoListPage()
}
