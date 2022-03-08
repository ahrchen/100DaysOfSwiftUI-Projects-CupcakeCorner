//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Raymond Chen on 3/6/22.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var wrappedOrder: WrappedOrder
    
    @State private var confirmationMessage = ""
    @State private var confirmationHeader = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(wrappedOrder.order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
            
            
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert(confirmationHeader, isPresented: $showingConfirmation) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(wrappedOrder) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedWrappedOrder = try JSONDecoder().decode(WrappedOrder.self, from: data)
            confirmationHeader = "Thank you!"
            confirmationMessage = "Your order for \(decodedWrappedOrder.order.quantity) x \(Order.types[decodedWrappedOrder.order.type].lowercased()) cupcakes is on it's way!"
        } catch {
            confirmationHeader = "Sorry, please try again later"
            confirmationMessage = "Checkout failed."
        }
        showingConfirmation = true
        
        
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(wrappedOrder: WrappedOrder())
    }
}
