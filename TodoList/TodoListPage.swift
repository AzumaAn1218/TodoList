//
//  TodoListPage.swift
//  TodoList
//
//  Created by 橋本丈太郎 on 2024/05/05.
//

import SwiftUI
import CoreData

struct TodoListPage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var todoItems: FetchedResults<TodoItem>

    @State var newTask: String = ""
    @State var showAlert = false
    
    // 現在の日付を取得する関数
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: Date())
    }
    
    var body: some View {
        VStack {
            Text(getCurrentDate())
            ForEach(todoItems) { todoItem in
                HStack {
                    Button(action: {
                        updateTodoItem(todoItem: todoItem)
                    }, label: {
                        Image(systemName:
                                todoItem.isChecked ? "checkmark.square" : "square"
                        )
                        .imageScale(.large)
                        .foregroundStyle(.pink)
                    })
                    if todoItem.isChecked {
                        Text(todoItem.task ?? "")
                            .strikethrough()
                    } else {
                        Text(todoItem.task ?? "")
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
                    addTodoItem(task: newTask)
                    newTask = ""
                }
            })
        })
    }
    
    private func addTodoItem(task: String) {
        withAnimation {
            let newTodoItem = TodoItem(context: viewContext)
            newTodoItem.isChecked = false
            newTodoItem.task = task
            saveContext()
        }
    }
    
    private func updateTodoItem(todoItem: TodoItem) {
        withAnimation {
            todoItem.isChecked.toggle()
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }
}

#Preview {
    TodoListPage()
}
