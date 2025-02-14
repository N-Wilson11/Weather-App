//
//  ContentView.swift
//  MBDI_WS4_Weathr
//
//  Created by Nathan Wilson on 14/02/2025.
//

import SwiftUI

struct ContentView: View {
    var size: CGFloat = 50
    var urlString: String = ""
    
    @State var weatherData: WeatherData?
    var body: some View {
        ZStack {
            Image("Lenticular_Cloud")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            VStack{
                Text("Locatie").font(.custom("HelveticaNeueUltraLight",size:size))
                Text(getTemperatureString() + " C").font(.custom("HelveticaNeueUltraLight",size:size))
            }
            
        }.onAppear(perform: loadData)
    }
    
    func loadData(){
        
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            if let error = error{
                print("ERROR: fetch failed; \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("ERROR: no data returned from API call")
                return
            }
            
            var newWeatherData: WeatherData?
            do{
                newWeatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            }
            catch let error as NSError{
                print("ERROR: decoding. In domain= \(error.domain), description= \(error.localizedDescription)")
            }
            if newWeatherData == nil{
                print("")
                return
            }
            self.weatherData = newWeatherData
        }
        
        guard let url = URL(string: urlString) else{
            print("ERROR: failed to construct a URL from string")
            return
        }
    }
    
    func getTemperatureString()->String{
        
        return "?"
    }
    
    
}

#Preview {
    ContentView()
}
