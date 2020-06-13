//
//  NetworkManager.swift
//  WeatherApplication
//
//  Created by val on 2/15/20.
//  Copyright © 2020 VL. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private let appId = "ca9db572fae974e04fc67268c81830a9"
    private let apiHost = "api.openweathermap.org"
    private let apiPath = "/data/2.5/weather"
    
    private enum HTTP_Methods {
        static let get = "GET"
        static let post = "POST"
        static let put = "PUT"
        static let delete = "DELETE"
        static let patch = "PATCH"
    }
    
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    
    func getWeatherData(lat: String, lon: String, completion: ((Result<WeatherModel>) -> Void)?) -> () {
        var urlComponents = getBaseComponent()
        let queryItemLan = URLQueryItem(name: "lat", value: lat)
        let queryItemLon = URLQueryItem(name: "lon", value: lon)
        urlComponents.queryItems?.append(queryItemLan)
        urlComponents.queryItems?.append(queryItemLon)
        loadItems(with: urlComponents, completion: completion)
    }
    
    func getWeatherDataByCity(city: String, completion: ((Result<WeatherModel>) -> Void)?) {
        var urlComponents = getBaseComponent()
        let queryItemCity = URLQueryItem(name: "q", value: city)
        urlComponents.queryItems?.append(queryItemCity)
        loadItems(with: urlComponents, completion: completion)
    }
    
    private func getBaseComponent() -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = apiHost
        urlComponents.path = apiPath
        let queryItemUnits = URLQueryItem(name: "units", value: "metric")
        let queryItemToken = URLQueryItem(name: "appid", value: appId)
        urlComponents.queryItems = [queryItemUnits, queryItemToken]
        return urlComponents
    }
    
    private func loadItems<T: Decodable>(with components: URLComponents, completion: ((Result<T>) -> Void)?) {
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTP_Methods.get
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("ERROR: - \(String(describing: responseError))"); return}
            guard let jsonData = responseData else { return }
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: jsonData)
                completion?(.success(decodedData))
            } catch {
                completion?(.failure(error))
            }
        }
        task.resume()
    }
}

