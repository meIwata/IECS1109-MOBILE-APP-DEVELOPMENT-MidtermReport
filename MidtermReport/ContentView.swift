//
//  ContentView.swift
//  MidtermReport
//
//  Created by Lulu Liao on 2025/7/30.
//
import SwiftUI

struct ContentView: View {
    @State private var city = "Niseko"
    @State private var weather: WeatherResponse?
    @State private var isLoading = false
    @State private var showFahrenheit = false
    @State private var shakeAngle: Double = 0
    @State private var isShaking = false
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
                        isShaking = false // 重新查詢時重置搖動
                        shakeAngle = 0
                    }
                }
            }
            .padding()
            
            if isLoading {
                ProgressView()
            }
            
            if let w = weather {
                HStack {
                    Image(systemName: "dot.scope")
                    Text("\(w.location.name), \(w.location.country)")
                        .font(.system(size: 32, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .layoutPriority(1)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                LocalTimeView(localTime: w.location.localtime) // <--- 傳入 API 拿到的當地時間
                Text("目前天氣：\(w.current.condition.text)")
                Text("溫度：\(showFahrenheit ? (w.current.temp_c * 9/5 + 32) : w.current.temp_c, specifier: "%.1f")\(showFahrenheit ? "°F" : "°C")")
                    .onTapGesture {
                        showFahrenheit.toggle()
                    }
                Text("濕度：\(w.current.humidity)%")
                Text("紫外線指數：\(w.current.uv == 0 ? "0" : String(format: "%.1f", w.current.uv))")
                
                AsyncImage(url: URL(string: "https:\(w.current.condition.icon)")) { image in
                    image
                        .resizable()
                        .frame(width: 85, height: 85)
                        .rotationEffect(.degrees(shakeAngle))
                        .onAppear {
                            startShaking()
                        }
                } placeholder: {
                    ProgressView()
                }
                .id(w.current.condition.icon)
            }
        }
        .padding()
        .frame(width: 300)
    }
    
    // 持續旋轉動畫
    func startShaking() {
        shakeAngle = -18        // 先移到 -18 度（動畫起點）
        if !isShaking {
            isShaking = true
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                shakeAngle = 18 // 動畫目標值設為 +18 度
            }
        }
    }
}

#Preview {
    ContentView()
}
