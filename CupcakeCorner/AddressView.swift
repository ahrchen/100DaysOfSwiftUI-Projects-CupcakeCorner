//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Raymond Chen on 3/6/22.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var wrappedOrder: WrappedOrder
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $wrappedOrder.order.name)
                TextField("Street Address", text: $wrappedOrder.order.streetAddress)
                TextField("City", text: $wrappedOrder.order.city)
                TextField("Zip", text: $wrappedOrder.order.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(wrappedOrder: wrappedOrder)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(wrappedOrder.order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(wrappedOrder: WrappedOrder())
    }
}
