//
//  Order.swift
//  CupcakeCorner
//
//  Created by Raymond Chen on 3/6/22.
//

import Foundation

class Order: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""
    
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
    
    init() {}
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        extraFrosting = try container.decode(Bool.self, forKey:.extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
    
}
