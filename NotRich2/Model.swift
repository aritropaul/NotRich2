//
//  Model.swift
//  notRich2
//
//  Created by Aritro Paul on 24/05/21.
//

import Foundation

final class Model: ObservableObject {
    
    @Published var data: [Crypto] = []
    @Published var series: [String : [Double]] = [:]
    @Published var error: String?
 
    init() {
        self.requestData()
    }
    
    
    func requestData() {
        let url = URL(string: "https://data.messari.io/api/v1/assets?fields=id,name,slug,symbol,metrics/market_data")!
        var request = URLRequest(url: url)
        request.addValue("Messari API Key", forHTTPHeaderField: "x-messari-api-key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8))
            let response = try! JSONDecoder().decode(Response.self, from: data)
            if response.error_code == nil {
                DispatchQueue.main.sync {
                    self.data = response.data ?? []
                    print(response)
                    for coin in self.data {
                        self.getTimeSeries(slug: coin.slug)
                    }
                    return
                }
            }
            else {
                DispatchQueue.main.sync {
                    self.error = response.error_message
                    print(error)
                    return
                }
            }
        }
        
        task.resume()
    }
    
    func getTimeSeries(slug: String) {
        let url = URL(string: "https://data.messari.io/api/v1/assets/\(slug)/metrics/price/time-series?start=2021-04-01&interval=1d&columns=close")!
        var request = URLRequest(url: url)
        request.addValue("Messari API Key", forHTTPHeaderField: "x-messari-api-key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8))
            let response = try! JSONDecoder().decode(TimeSeriesResponse.self, from: data)
            DispatchQueue.main.sync {
                let closeValues = response.data?.values.map({ value in
                    return value[1]
                })
                self.series[slug] = closeValues
                print(self.series)
                return
            }
        }
        
        task.resume()
    }
    
}


//MARK:- Response

struct Response: Codable {
    var status: Status
    var data: [Crypto]?
    var error_code: Int?
    var error_message: String?
}

struct Status: Codable {
    var elapsed: Int
    var timestamp: String
}

struct Crypto: Codable, Identifiable {
    var id: String
    var name: String
    var slug: String
    var symbol: String
    var metrics: Metrics
}

struct Metrics: Codable {
    var market_data: MarketData
}


struct MarketData: Codable {
    var price_usd: Double
    var percent_change_usd_last_1_hour: Double?
    var percent_change_usd_last_24_hours: Double
}

struct TimeSeriesResponse: Codable {
    var status: Status
    var data: TimeSeries?
}

struct TimeSeries: Codable {
    var id: String
    var name: String
    var slug: String
    var symbol: String
    var values: [[Double]]
}
