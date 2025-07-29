//
//  WeatherService.swift
//  MidtermReport
//
//  Created by Lulu Liao on 2025/7/30.
//
import Foundation

class WeatherService {
    let apiKey = "f0f54816d5e842a1a48121637250702"
    
    func fetchWeather(city: String, completion: @escaping (WeatherResponse?) -> Void) {
        let urlStr = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(city)&lang=zh_tw"
        guard let url = URL(string: urlStr) else { completion(nil); return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { completion(nil); return }
            let weather = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            completion(weather)
        }.resume()
    }
}
