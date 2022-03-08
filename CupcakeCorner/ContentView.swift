//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Raymond Chen on 3/5/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var wrappedOrder = WrappedOrder()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $wrappedOrder.order.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(wrappedOrder.order.quantity)", value: $wrappedOrder.order.quantity, in: 3...20)
                    
                    Section {
                        Toggle("Any special requests?", isOn: $wrappedOrder.order.specialRequestEnabled.animation())
                        
                        if wrappedOrder.order.specialRequestEnabled {
                            Toggle("Add extra frosting", isOn: $wrappedOrder.order.extraFrosting)
                            
                            Toggle("Add extra sprinkles", isOn: $wrappedOrder.order.addSprinkles)
                        }
                    }
                    
                    Section {
                        NavigationLink {
                            AddressView(wrappedOrder: wrappedOrder)
                        } label: {
                            Text("Delivery details")
                        }
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
