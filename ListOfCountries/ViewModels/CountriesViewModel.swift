//
//  CountriesViewModel.swift
//  ListOfCountries
//
//  Created by Zak Mills on 6/16/25.
//

import Foundation

@MainActor
class CountriesViewModel {
    private var allCountries: [Country] = []
    private(set) var filteredCountries: [Country] = []
    private(set) var isLoading = false
    private(set) var error: Error?
    
    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func loadData(from urlString: String) async {
        guard let url = URL(string: urlString) else {
            let urlError = NSError(domain: "CountriesViewModel", code: 0,
                                   userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            self.error = urlError
            onError?(urlError)
            return
        }
        
        isLoading = true
        onUpdate?()
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            allCountries = try JSONDecoder().decode([Country].self, from: data)
            filteredCountries = allCountries
            error = nil
        } catch {
            print("error loading data: \(error)")
            self.error = error
            onError?(error)
        }
        isLoading = true
        onUpdate?()
    }
    
    func filterCountries(with searchText: String) {
        if searchText.isEmpty {
            filteredCountries = allCountries
        } else {
            filteredCountries = allCountries.filter { country in
                country.name.lowercased().contains(searchText.lowercased()) ||
                country.capital.lowercased().contains(searchText.lowercased())
            }
        }
        onUpdate?()
    }
    
    func country(at index: Int) -> Country? {
        guard index >= 0 && index < filteredCountries.count else { return nil }
        return filteredCountries[index]
    }
    
    @MainActor
    func setTestCountries(_ countries: [Country]) {
        self.allCountries = countries
        self.filterCountries(with: "")
    }
    
    @MainActor
    func loadCountries() async {
        guard let url = countriesURL else {
            self.error = URLError(.badURL)
            return
        }
        await loadData(from: url.absoluteString)
    }
    
    private var countriesURL: URL? {
        guard let countriesURL = Bundle.main.object(forInfoDictionaryKey: "CountriesURL") as? String else {
            return nil
        }
        return URL(string: countriesURL)
    }
}
