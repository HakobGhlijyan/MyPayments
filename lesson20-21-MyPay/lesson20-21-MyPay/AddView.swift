//
//  AddView.swift
//  lesson20-21-MyPay
//
//  Created by Hakob Ghlijyan on 27.05.2023.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var expense: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    let types = ["Pesronal", "Business"]
    
    var body: some View {
        
        NavigationView {
            Form {
                TextField("Name Payments", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(self.types, id: \.self){
                        Text($0)
                    }
                }
                TextField("Pay Money", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add Payment")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if let actualAmount = Int(self.amount) {
                            let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                            self.expense.items.append(item)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expense: Expenses())
    }
}
