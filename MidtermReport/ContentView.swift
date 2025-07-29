//
//  ContentView.swift
//  MidtermReport
//
//  Created by Lulu Liao on 2025/7/30.
//
import SwiftUI

struct ContentView: View {
    @State private var city = "Yokohama"
    @State private var weather: WeatherResponse?
    @State private var isLoading = false
    let service = WeatherService()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("輸入城市", text: $city)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("查詢天氣") {
                isLoading = true
                service.fetchWeather(city: city) { result in
                    DispatchQueue.main.async {
                        weather = result
                        isLoading = false
                    }
                }
            }
            .padding()
            
            if isLoading {
                ProgressView()
            }
            
            if let w = weather {
                Text("\(w.location.name), \(w.location.country)")
                    .font(.title)
                Text("目前天氣：\(w.current.condition.text)")
                Text("溫度：\(w.current.temp_c, specifier: "%.1f")°C")
                AsyncImage(url: URL(string: "https:\(w.current.condition.icon)")) { image in
                    image.resizable().frame(width: 64, height: 64)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .padding()
        .frame(width: 300)
    }
}

#Preview {
    ContentView()
}

