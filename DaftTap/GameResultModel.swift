//
//  GameResultModel.swift
//  DaftTap
//
//  Created by Mikołaj Hościło on 12/05/2019.
//  Copyright © 2019 Kornel Skórka. All rights reserved.
//

import Foundation

struct GameResultModel: Codable{
    let taps: Int
    let time: String
    init(with result: Int,time: String) {
        self.taps = result
        self.time = time
    }
    
}
