# Wind Surfing Weather App
# Overview
The Wind Surfing Weather App allows users to view current weather conditions in popular windsurfing cities around the world, based on their selected country and city. In addition to displaying the weather, the app also calculates optimal surfing conditions and sorts surfing times within the next 240 hours based on the highest surfing points.

# Features
Search for windsurfing cities: The user selects a country and a city from a list of popular windsurfing locations.
Weather Conditions: After selecting a city, the user can navigate to a detailed view displaying the current weather conditions, including temperature, wind speed, and a surfing score based on these conditions.
Optimal Surfing Times: A list of optimal surfing times within the next 240 hours, sorted by the highest surfing score. This data helps users plan their surfing sessions.
# Architecture
The app follows a MVVM (Model-View-ViewModel) design pattern:

# Model:
 - Weather Data: The weather data is fetched from an external API, which provides information such as temperature, wind speed, and weather description.
 - Optimal Surfing Times: A separate data model calculates and stores the optimal surfing times based on the weather data (e.g., wind speed, temperature).
# View:
 - City and Country Selection: The main screen allows the user to select the country and city from predefined lists.
 - Weather Conditions View: Once a city is selected, the user navigates to a detailed view displaying weather data and optimal surfing times.
# ViewModel:
 - WeatherAPIManager: A class responsible for interacting with the weather API, fetching the weather data, and processing the surfing times. It is responsible for transforming the data into a format that the view can display.
 - Error Handling: Custom error handling is implemented to handle network errors, invalid data, or city not found situations.
# Technical Details
Technologies Used
SwiftUI: For building the app’s UI in a declarative manner.
Combine: For handling asynchronous tasks and managing the app’s state.
Weather API: A custom API service to fetch the weather data for selected cities.
Asynchronous Programming: The app makes use of Swift’s async/await pattern to fetch weather data asynchronously.
# Key Classes and Functions
WeatherAPIManager:
fetchWeather(for city: String, countryCode: String) async throws: Fetches the weather data for the selected city and country.
calculateSurfingScore(weather: WeatherData): Calculates a score based on weather conditions that indicate optimal surfing times.
Error Handling:
Custom error enum WeatherAPIError is used to handle specific errors:
networkError: When there’s a failure in network connectivity.
invalidData: When the fetched data is not in the expected format.
cityNotFound: When the city is not found in the weather API.
unknownError: For any unexpected errors.
# App Flow
User selects a country and city.
The app requests weather data for the selected city from the weather API.
The app then calculates optimal surfing times for the next 240 hours based on the weather conditions (e.g., wind speed, temperature).
The user is presented with:
Current weather conditions, including temperature, wind speed, and surfing score.
A list of optimal surfing times sorted by the highest surfing score.
Error Handling: In case of any issues, a descriptive error message is shown to the user.
# Requirements
iOS 16.0 or higher
Xcode 15.0 or higher
# Setup Instructions
Clone the repository.
Open the project in Xcode.
Build and run the app on a simulator or physical device.
# Known Issues
The weather API may occasionally return incomplete or incorrect data.
Error handling could be enhanced for edge cases (e.g., handling empty responses from the API).

Explanation of Added Sections
Overview: Provides a quick summary of the app's purpose and core features.
Architecture: Explains the design pattern (MVVM) used and breaks down how the app is structured in terms of models, views, and view models.
Technologies Used: Details the technologies and frameworks used (SwiftUI, Combine, etc.).
Key Classes and Functions: Describes the core logic in the app, especially focusing on the WeatherAPIManager and its methods.
App Flow: Walks through the user experience and the logic behind fetching and displaying weather data.
Error Handling: Adds specific details about the error handling mechanism using the custom WeatherAPIError enum.
