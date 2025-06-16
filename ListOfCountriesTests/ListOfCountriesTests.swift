//
//  ListOfCountriesTests.swift
//  ListOfCountriesTests
//
//  Created by Zak Mills on 6/16/25.
//

import XCTest
@testable import ListOfCountries

@MainActor
final class ListOfCountriesTests: XCTestCase {
    var viewModel: CountriesViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CountriesViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
        
    func testInitialState() {
        XCTAssertTrue(viewModel.filteredCountries.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }
    
    func testLoadDataWithInvalidURL() async {
        let expectation = XCTestExpectation(description: "Error callback called")
        
        viewModel.onError = { error in
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError).domain, "CountriesViewModel")
            expectation.fulfill()
        }
        
        await viewModel.loadData(from: "")
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertNotNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    
    func testFilterCountriesWithEmptySearch() {
        
        setupMockCountries()
        
        viewModel.filterCountries(with: "")
        
        XCTAssertEqual(viewModel.filteredCountries.count, 3)
    }
    
    func testFilterCountriesByName() {
        setupMockCountries()
        
        viewModel.filterCountries(with: "USA")
        
        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.name, "USA")
    }
    
    func testFilterCountriesByCapital() {
        setupMockCountries()
        
        viewModel.filterCountries(with: "London")
        
        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.capital, "London")
    }
    
    func testFilterCountriesCaseInsensitive() {
        setupMockCountries()
        
        viewModel.filterCountries(with: "usa")
        
        XCTAssertEqual(viewModel.filteredCountries.count, 1)
        XCTAssertEqual(viewModel.filteredCountries.first?.name, "USA")
    }
    
    func testFilterCountriesNoMatch() {
        setupMockCountries()
        
        viewModel.filterCountries(with: "NonExistentCountry")
        
        XCTAssertTrue(viewModel.filteredCountries.isEmpty)
    }
    
    func testCountryAtValidIndex() {
        setupMockCountries()
        
        let country = viewModel.country(at: 0)
        
        XCTAssertNotNil(country)
        XCTAssertEqual(country?.name, "USA")
    }
    
    func testCountryAtInvalidIndex() {
        setupMockCountries()
        
        let country = viewModel.country(at: 10)
        
        XCTAssertNil(country)
    }
    
    func testCountryAtNegativeIndex() {
        setupMockCountries()
        
        let country = viewModel.country(at: -1)
        
        XCTAssertNil(country)
    }
    
    func testOnUpdateCallback() {
        let expectation = XCTestExpectation(description: "Update callback called")
        
        viewModel.onUpdate = {
            expectation.fulfill()
        }
        
        setupMockCountries()
        viewModel.filterCountries(with: "USA")
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func setupMockCountries() {
        
        let mockCountries = [
            Country(capital: "Washington", code: "US", flag: "🇺🇸", name: "USA", region: "Americas"),
            Country(capital: "London", code: "GB", flag: "🇬🇧", name: "UK", region: "Europe"),
            Country(capital: "Paris", code: "FR", flag: "🇫🇷", name: "France", region: "Europe")
        ]
        
        viewModel._injectMockCountries(mockCountries)
    }
}

#if DEBUG
extension CountriesViewModel {
    func _injectMockCountries(_ countries: [Country]) {
        self.setTestCountries(countries)
    }
}
#endif
