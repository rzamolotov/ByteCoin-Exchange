//
//  CoinData.swift
//  ByteCoin
//
//  Created by Роман Замолотов on 17.02.2023.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable{
  let time: String
  let asset_id_base: String
  let asset_id_quote: String
  let rate: Double
}
