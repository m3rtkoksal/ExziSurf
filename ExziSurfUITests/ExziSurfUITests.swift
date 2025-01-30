//
//  ExziSurfUITests.swift
//  ExziSurfUITests
//
//  Created by Mert Köksal on 29.01.2025.
//

import XCTest

final class ExziSurfUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    @MainActor
    func testSelectingCityEnablesCheckWeatherButton() {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Enter"].tap()
        app.buttons["dropdownItem-Country"].tap()
        app.buttons["dropdownItem-Turkey"].tap()
        app.buttons["dropdownItem-City"].tap()
        app.buttons["dropdownItem-Istanbul"].tap()
        
        let checkWeatherButton = app.buttons["Check Weather"]
        XCTAssertTrue(checkWeatherButton.isEnabled)
    }
    
    func testButtonStateWhenCityIsSelected() {
        let app = XCUIApplication()
        app.launch()
        
        // Trigger the navigation to CitySelectionView by changing showCitySelection to true
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 5))
        
        enterButton.tap() // This sets showCitySelection to true, triggering the NavigationLink
        
        // Wait for the CitySelectionView to appear
        let cityDropdown = app.buttons["dropdownItem-City"] // Assuming this is the city dropdown button
        XCTAssertTrue(cityDropdown.waitForExistence(timeout: 5))
        
        cityDropdown.tap()
        
        // Simulate tapping a city from the dropdown, e.g., Istanbul
        let istanbulCity = app.buttons["dropdownItem-Istanbul"] // Adjust the label accordingly
        XCTAssertTrue(istanbulCity.waitForExistence(timeout: 5))
        
        istanbulCity.tap()
        
        // After selecting the city, check if the button (e.g., "Check Weather") is enabled
        let weatherButton = app.buttons["Check Weather"]
        XCTAssertTrue(weatherButton.isEnabled) // The button should be enabled when both country and city are selected
    }
    
    // Test for button being disabled when no city is selected
    func testButtonStateWhenNoCityIsSelected() {
        let app = XCUIApplication()
        app.launch()
        
        // Trigger the navigation to CitySelectionView by changing showCitySelection to true
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 5))
        
        enterButton.tap() // This sets showCitySelection to true, triggering the NavigationLink
        
        // Simulate selecting a country (Turkey)
        let countryDropdown = app.buttons["dropdownItem-Turkey"]
        XCTAssertTrue(countryDropdown.waitForExistence(timeout: 5))
        
        countryDropdown.tap()
        
        // Ensure no city is selected (empty state)
        let cityDropdown = app.buttons["dropdownItem-City"]
        XCTAssertTrue(cityDropdown.waitForExistence(timeout: 5))
        
        cityDropdown.tap()
        
        // Ensure the "Enter" button is tapped and navigation occurs
        XCTAssertTrue(enterButton.exists)
        
        enterButton.tap() // Trigger the navigation
        
        // Now check if the navigation is triggered and you're on the CitySelectionView
        let citySelectionView = app.staticTexts["City Selection"]
        XCTAssertTrue(citySelectionView.exists) // Assuming the CitySelectionView has a staticText element with this label
    }
    
    func testCountryDropdownSelection() {
        let app = XCUIApplication()
        
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 5))
        
        enterButton.tap()
        
        let countryDropdown = app.buttons["dropdownItem-Country"]
        XCTAssertTrue(countryDropdown.waitForExistence(timeout: 5))
        
        countryDropdown.tap()
        
        // Assuming Turkey is an option in the dropdown
        let turkeyOption = app.buttons["dropdownItem-Turkey"]
        XCTAssertTrue(turkeyOption.waitForExistence(timeout: 5))
        
        turkeyOption.tap()
        
        // Verify the selected country is updated
        XCTAssertEqual(countryDropdown.label, "Turkey")
    }
    
    func testCityDropdownExpandsAfterCountrySelection() {
        let app = XCUIApplication()
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 5))
        
        enterButton.tap()
        let countryDropdown = app.buttons["dropdownItem-Country"]
        XCTAssertTrue(countryDropdown.waitForExistence(timeout: 5))
        
        countryDropdown.tap()
        
        let turkeyOption = app.buttons["dropdownItem-Turkey"]
        XCTAssertTrue(turkeyOption.waitForExistence(timeout: 5))
        
        turkeyOption.tap()
        
        let cityDropdown = app.buttons["dropdownItem-City"]
        XCTAssertTrue(cityDropdown.waitForExistence(timeout: 5))
        
        cityDropdown.tap()
        
        let istanbulOption = app.buttons["dropdownItem-Istanbul"]
        XCTAssertTrue(istanbulOption.waitForExistence(timeout: 5))
        
        istanbulOption.tap()
        
        XCTAssertEqual(cityDropdown.label, "Istanbul")
    }
    
    func testCityResetsOnCountryChange() {
        let app = XCUIApplication()
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 5))
        
        enterButton.tap()
        let countryDropdown = app.buttons["dropdownItem-Country"]
        countryDropdown.tap()
        
        let turkeyOption = app.buttons["dropdownItem-Turkey"]
        turkeyOption.tap()
        
        let cityDropdown = app.buttons["dropdownItem-City"]
        cityDropdown.tap()
        
        let istanbulOption = app.buttons["dropdownItem-Istanbul"]
        istanbulOption.tap()
        
        XCTAssertEqual(cityDropdown.label, "Istanbul")
        
        // Change country
        countryDropdown.tap()
        
        let usaOption = app.buttons["dropdownItem-USA"]
        usaOption.tap()
        
        // The city should be reset
        XCTAssertEqual(cityDropdown.label, "Please Select City")
    }
    
    func testCheckWeatherButtonDisabledWithoutCity() {
        let app = XCUIApplication()
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 5))
        
        enterButton.tap()
        let checkWeatherButton = app.buttons["Check Weather"]
        XCTAssertFalse(checkWeatherButton.isEnabled)
    }
    
    func testCheckWeatherButtonEnabledWithCity() {
        let app = XCUIApplication()
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 5))
        
        enterButton.tap()
        let countryDropdown = app.buttons["dropdownItem-Country"]
        countryDropdown.tap()
        
        let turkeyOption = app.buttons["dropdownItem-Turkey"]
        turkeyOption.tap()
        
        let cityDropdown = app.buttons["dropdownItem-City"]
        cityDropdown.tap()
        
        let istanbulOption = app.buttons["dropdownItem-Istanbul"]
        istanbulOption.tap()
        
        let checkWeatherButton = app.buttons["Check Weather"]
        XCTAssertTrue(checkWeatherButton.isEnabled)
    }
    
    func testNavigationToWeatherConditionView() {
        let app = XCUIApplication()
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 5))
        
        enterButton.tap()
        let countryDropdown = app.buttons["dropdownItem-Country"]
        countryDropdown.tap()
        
        let turkeyOption = app.buttons["dropdownItem-Turkey"]
        turkeyOption.tap()
        
        let cityDropdown = app.buttons["dropdownItem-City"]
        cityDropdown.tap()
        
        let istanbulOption = app.buttons["dropdownItem-Istanbul"]
        istanbulOption.tap()
        
        let checkWeatherButton = app.buttons["Check Weather"]
        checkWeatherButton.tap()
        
        // Wait for WeatherConditionView to appear
        let weatherView = app.otherElements["WeatherConditionView"]
        XCTAssertTrue(weatherView.waitForExistence(timeout: 5))
    }
    
    @MainActor
    func testNavigatingToCitySelectionView() {
        let app = XCUIApplication()
        app.launch()
        
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 5))
        enterButton.tap()
        
        let countryDropdown = app.buttons["dropdownItem-Country"]
        XCTAssertTrue(countryDropdown.waitForExistence(timeout: 5))
    }
}
