//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "3EDDDC0B-0FA1-4667-A153-5BC29D873536"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        //1. Create a URL
        if let url  = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                } // если ошибка не равна нулю возвращаем функцию и продолжаем работать, если есть ошибка - печатаем ее в консоле
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice) //форматируем цену для валюты
                        self.delegate?.didUpdateCurrency(price: priceString, currency: currency) //получаем данные для вью
                    }
                } // получаем данные из сети
            }
            //4. Start the task
            task.resume()
        }
    }
    func parseJSON (_ data: Data) -> Double? {
        let decoder = JSONDecoder () // создаем константу декодирования
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data) //выбираем, что декодировать
            let lastPrice = decodedData.rate //декодируем цену биткоина в валюте
            print(lastPrice)
            return lastPrice // возвращаем цену в функцию
        } catch {
            delegate?.didFailWithError(error: error)
            return nil // если не получается декодировать данные пишем ошибку
        }
    }
}
