//
//  Country.swift
//  Day59Challenge
//
//  Created by Noah Glaser on 1/8/22.
//

import Foundation




struct CountryName: Codable {
    let common: String;
    let official: String;
}

struct Country: Codable {
    let name: CountryName
    let population: Double
    let flags: Flags
    let languages: [String: String]?
    let currencies: [String: Currency]?
    
    var rows: [(title: String, subtitle: String)] {
        var rows: [(title: String, subtitle: String)] = [
            (title: "Population", subtitle: Int(population).withCommas()),
        ]
        
        if let languages = self.languages {
            rows.append((title: "Languages", subtitle: languages.enumerated().map{ $0.element.value   }.joined(separator: ", ")))
        }
        
        if let currencies = self.currencies {
            if let currencyName = currencies.first?.value.name {
                rows.append((title: "Currency Name", subtitle: currencyName))
            }

            if let currencySymbol = currencies.first?.value.symbol {
                rows.append((title: "Currency Symbol", subtitle: currencySymbol))
            }
        }
       
        
        
        return rows
    }
}

struct Currency: Codable {
    let name: String?
    let symbol: String?
}

struct Flags: Codable {
    let png: String
    let svg: String
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
