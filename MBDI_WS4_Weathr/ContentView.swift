//
//  ContentView.swift
//  MBDI_WS4_Weathr
//
//  Created by Nathan Wilson on 14/02/2025.
//

import SwiftUI

struct ContentView: View {
    var size: CGFloat = 50
    var urlString: String = "https://api.openweathermap.org/data/2.5/weather?q=s-Hertogenbosch&appid=3b7c0bb2df5778f696d6dfc53b6189c9&units=metric"
    @State var weatherData: WeatherData?
    var body: some View {
        ZStack {
            Image("Lenticular_Cloud")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            VStack{
                Text(getLocationString()).font(.custom("HelveticaNeueUltraLight",size:size))
                Text(getTemperatureString() + " C").font(.custom("HelveticaNeueUltraLight",size:size))
            }
            
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let url = URL(string: urlString) else {
            print("ERROR: failed to construct a URL from string")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("ERROR: fetch failed; \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("ERROR: no data returned from API call")
                return
            }
            
            var newWeatherData: WeatherData?
            do {
                newWeatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            } catch let error as NSError {
                print("ERROR: decoding. In domain= \(error.domain), description= \(error.localizedDescription)")
            }
            
            if newWeatherData == nil {
                print("ERROR: Weather data is nil")
                return
            }
            DispatchQueue.main.async {
                self.weatherData = newWeatherData
            }
            
        }
        
        task.resume() // Don't forget to resume the task
    }

    
    func getTemperatureString()->String{
        guard let weatherData = weatherData else {
                    return "?"
                }
                
                // Return the temperature as a string with 1 decimal place
                let temperature = weatherData.main.temp
                return String(format: "%.1f", temperature)
    }
    
    func getLocationString() -> String {
        // If weatherData is nil, return "?"
        guard let weatherData = weatherData else {
            return "?"
        }
           // Return the city name
        return weatherData.name
       }
    
    
}

#Preview {
    ContentView()
}
