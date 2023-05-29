//
//  ContentView.swift
//  lesson20-21-MyPay
//
//  Created by Hakob Ghlijyan on 27.05.2023.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let endcoded = try? encoder.encode(items) {
                UserDefaults.standard.set(endcoded, forKey: "Items")
            }
        }
    }
    
    init() {
        
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
    }
    
}

struct ContentView: View {
    @State private var showingAddExpense = false
    @ObservedObject var expenses = Expenses()
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                   
                    HStack {
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                    }
                    
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("My Payments")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showingAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showingAddExpense) {
                        AddView(expense: self.expenses)
                    }
                }
            }
        }
    }
    
    func removeItems(as offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
