//
//  Order.swift
//  CupcakeCorner
//
//  Created by Raymond Chen on 3/6/22.
//

import Foundation

class WrappedOrder: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case order
    }
    
    @Published var order = Order()
    
    init() {}
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(order, forKey: .order)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        order = try container.decode(Order.self, forKey: .order)
    }
}

struct Order: Codable {
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        let trimmed_name_isEmpty = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let trimmed_streetAddress_isEmpty = streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let trimmed_city_isEmpty = city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let trimmed_zip_isEmpty = zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        if trimmed_name_isEmpty || trimmed_streetAddress_isEmpty || trimmed_city_isEmpty || trimmed_zip_isEmpty {
            return false
        }
        
        return true 
    }
    
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        
        // complex cake cost more --> Based on Enum --> Not good
        cost += (Double(type) / 2)
        
        // $1/ cake extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // $0.50/ cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}
