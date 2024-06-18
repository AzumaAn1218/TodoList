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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TodoItem.number, ascending: false)]) // number属性の降順でソートする
    private var todoItems: FetchedResults<TodoItem>

    @State var newTask: String = ""
    @State var addTaskAlert = false
    @State var deleteTaskAlert = false
    
    // 現在の日付を取得する関数
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: Date())
    }
    
    var body: some View {
        VStack {
            Text(getCurrentDate())
            List {
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
                .onMove(perform: moveTodoItem)
                .deleteDisabled(true)
            }
            .environment(\.editMode, .constant(.active))
            
            Spacer()
            HStack{
                Button {
                    addTaskAlert = true
                } label: {
                    Text("＋")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .frame(width:80, height:80)
                        .background(Color("bottonColor"))
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                }
                Button {
                    deleteTaskAlert = true
                } label: {
                    Text("ー")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .frame(width:80, height:80)
                        .background(Color("bottonColor"))
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                }
            }
        }
        .alert("タスクの追加", isPresented: $addTaskAlert, actions: {
            TextField("新規タスク", text: $newTask)
            Button("キャンセル", action: {})
            Button("追加する", action: {
                if !newTask.isEmpty {
                    addTodoItem(task: newTask)
                    newTask = ""
                }
            })
        })
        .alert("完了済みタスクを削除する", isPresented: $deleteTaskAlert, actions: {
            Button("キャンセル", action: {})
            Button("削除する", action: {
                let completedTasks = todoItems.filter { $0.isChecked }
                completedTasks.forEach { viewContext.delete($0) }
                saveContext()
            })
        })
    }
    
    private func addTodoItem(task: String) {
        withAnimation {
            let newTodoItem = TodoItem(context: viewContext)
            newTodoItem.isChecked = false
            newTodoItem.task = task
            newTodoItem.timestamp = Date()
            newTodoItem.number = Int16(todoItems.first?.number ?? 0) + 1 // number属性に採番する
            saveContext()
        }
    }
    
    private func updateTodoItem(todoItem: TodoItem) {
        withAnimation {
            todoItem.isChecked.toggle()
            saveContext()
        }
    }
    
    private func moveTodoItem(from source: IndexSet, to destination: Int) {
        
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
