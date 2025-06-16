//
//  CountriesModel.swift
//  ListOfCountries
//
//  Created by Zak Mills on 6/16/25.
//

import Foundation

struct Country: Decodable {
    let capital: String
    let code: String
    let flag: String
    let name: String
    let region: String
}
