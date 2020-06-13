//
//  WeatherModel.swift
//  WeatherApplication
//
//  Created by val on 2/15/20.
//  Copyright © 2020 VL. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    
    var main: MainData
    var weather: [WeatherData]
    var wind: WindData
    var name: String
    let timeRange = 5..<22
    
    func getWeatherIconImage(condition: Int) -> String {
        
        let hour = Calendar.current.component(.hour, from: Date())
           switch (condition) {
            
           case 200...232 :
               switch hour {
               case timeRange :
                   return "storm"
               default :
                   return "storm-night"
               }
               
           case 300...321 :
               switch hour {
               case timeRange :
                   return "hail"
               default :
                   return "night-rain"
               }
               
           case 500...531 :
               switch hour {
               case timeRange :
                   return "storm"
               default :
                   return "night-rain"
               }
               
           case 600...622 :
               switch hour {
               case timeRange :
                   return "snowy"
               default :
                   return "night-snow"
               }
               
           case 701...741 :
               return "fog"
               
           case 800 :
               switch hour {
               case timeRange :
                   return "sun"
               default :
                   return "night-4"
               }
               
           case 801 :
               return "cloudy-3"
               
           case 802 :
               switch hour {
               case timeRange :
                   return "cloud"
               default :
                   return "cloud-moon"
               }
               
           case 803...804 :
               return "cloudy"
               
           default:
               return "windy"
            
           }
        
       }
    
    func getConditionWeatherImage(condition: String) -> String {
        
        let hour = Calendar.current.component(.hour, from: Date())
        switch (condition) {
            
        case "Thunderstorm" :
            switch hour {
            case timeRange :
                return "thunderstorm-day-image"
            default :
                return "thunderstorm-night-image"
            }
            
        case "Drizzle" :
            switch hour {
            case timeRange :
                return "rain-day-image"
            default :
                return "rain-night-image"
            }
            
        case "Rain" :
            switch hour {
            case timeRange :
                return "rain-day-image"
            default :
                return "rain-night-image"
            }
            
        case "Snow" :
            switch hour {
            case timeRange :
                return "snow-day-image"
            default :
                return "snow-night-image"
            }
            
        case "Mist", "Smoke","Haze", "Dust", "Fog", "Sand", "Ash", "Squall", "Tornado":
            switch hour {
            case timeRange :
                return "fog-image"
            default :
                return "fog-night-image"
            }
            
        case "Clear" :
            switch hour {
            case timeRange :
                return "sunny-day-image"
            default :
                return "noclouds-night-image"
            }
            
        case "Clouds":
            switch hour {
            case timeRange :
                return "partlycloudy-day-image"
            default :
                return "noclouds-night-image"
            }

        default:
            return "noclouds-night-image"
        }
        
    }
    
}

struct MainData: Codable {
    var temp: Float
    var pressure: Int
    var humidity: Int
}

struct WeatherData: Codable {
    var id: Int
    var main: String
    var description: String
}

struct WindData: Codable {
    var speed: Float
    var deg: Float
}
