//
//  ImagrAPI.swift
//  devventure-challenge
//
//  Created by Evandro de Paula on 12/06/20.
//  Copyright © 2020 DevVenture. All rights reserved.
//

enum APIError: Error {
    case badURL
    case taskError
    case badResponse
    case invalidStatusCode(Int)
    case noData
    case invalidJSON
}

import Foundation

class ImgurAPI {
    private static let basePath = "https://api.imgur.com/3/gallery/search/?q=cats&q_type=jpg"
    
    private static let configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = false
        configuration.httpAdditionalHeaders = ["Authorization":"Client-ID 1ceddedc03a5d71"]
        configuration.timeoutIntervalForRequest = 30.0
        configuration.httpMaximumConnectionsPerHost = 5
        return configuration
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    class func loadCatData(onComplete: @escaping (Result<[ImgurData], APIError>)->Void) {
        guard let url = URL(string: basePath) else {
            onComplete(.failure(.badURL))
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                onComplete(.failure(.taskError))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                onComplete(.failure(.badResponse))
                return
            }
            if response.statusCode != 200 {
                onComplete(.failure(.invalidStatusCode(response.statusCode)))
                return
            }
            guard let data = data else {
                onComplete(.failure(.noData))
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {return}
                
                if let results = json["data"] {
                    let resultJsonData = try JSONSerialization.data(withJSONObject: results, options: [])
                        let catImages = try JSONDecoder().decode([ImgurData].self, from: resultJsonData)
                    onComplete(.success(catImages))
                }
                
            } catch {
                print(error)
                onComplete(.failure(.invalidJSON))
            }
        }
        task.resume()
    }
}
