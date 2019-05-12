//
//  GameResultModel.swift
//  DaftTap
//
//  Created by Mikołaj Hościło on 12/05/2019.
//  Copyright © 2019 Kornel Skórka. All rights reserved.
//

import Foundation

struct GameResultModel: Codable{
    let result: Int
    let time: String
    init(with result: Int,time: String) {
        self.result = result
        self.time = time
    }
    
}
