//
//  ContentView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 11/3/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var totalCost = ""
    @State private var people = 4
    @State private var tipIndex = 2
    let tipPercentages = [0,5,10,15]
    
    func calculateTotal() ->  Double {
        let tip = Double(tipPercentages[tipIndex])
        let orderTotal = Double(totalCost) ?? 0
        let finalAmount = ((orderTotal / 100 * tip) + orderTotal)
        return finalAmount / Double(people)
        
    }
    
    var body: some View {
        NavigationView{
            Form {
                Section (header: Text("Enter an amount")){
                    TextField("Amount", text: $totalCost).keyboardType(.decimalPad)
                }
                Section (header: Text("Select a tip amount (%)")){
                    Picker ("Tip percentage", selection:$tipIndex){
                        ForEach(tipPercentages.indices, id: \.self) { index in
                            Text("\(tipPercentages[index])%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                }
                Section(header: Text("How many people?")) {
                    Picker("Number of people", selection: $people) {
                        ForEach(1..<25, id: \.self) { number in
                            Text("\(number) people")
                        }
                    }
                }
                Section (header: Text("Total per person")){
                    Text("$ \(calculateTotal(), specifier: "%.2f")")
                }
            }.navigationTitle(Text("Bill Buddy"))
        }
    }
        
}

#Preview {
    ContentView()
}
