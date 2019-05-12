//
//  GameModel.swift
//  DaftTap
//
//  Created by Kornel Skórka on 12/05/2019.
//  Copyright © 2019 Kornel Skórka. All rights reserved.
//

import Foundation

struct GameModel{
    var countdown = 4
    var gameTime = 5
    var isPlayable: Bool = false
    var score: Int = 0
    let emojis = ["🔥","😂","😎","👍","🙀","👏","😮","👌","🔥","🌈","⚡️"]
    var startTime: String = ""
}
