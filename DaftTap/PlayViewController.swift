//
//  PlayViewController.swift
//  DaftTap
//
//  Created by Mikołaj Hościło on 12/05/2019.
//  Copyright © 2019 Kornel Skórka. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    var countdown = 1 //change to 4
    var gameTime = 6
    var label = UILabel()
    var isPlayable: Bool = false
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let w = view.bounds.width
        let h = view.bounds.height
        
        label = UILabel(frame: CGRect(x: w / 2, y: h / 2, width: 240, height: 100))
        label.text = "3"
        label.center = CGPoint(x: w / 2, y: h / 2)
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 20)
        label.textColor = .black
        self.view?.addSubview(label)
        view.backgroundColor = .white
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountdown), userInfo: nil, repeats: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
       

        // Do any additional setup after loading the view.
    }
    
    @objc func startCountdown() {
        //you code, this is an example
        if countdown > 0 {
           // print("\(countdown) seconds")
            if(countdown - 1 == 0){
                label.text = "Start!"
                isPlayable = true
                 var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameTimer), userInfo: nil, repeats: true)
            } else {
                label.text = String(countdown-1)
                
            }
            countdown -= 1
        }
    }
    @objc func gameTimer() {
        //you code, this is an example
        if gameTime > 0 {
            //label.text = "left:\(gameTime)"
            if(gameTime == 1){
                isPlayable = false
                label.text = "FINISH!! \(score)"
            }
            gameTime -= 1
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        if(isPlayable){
            score += 1
            label.text = "Score: \(score) Time left:\(gameTime)"
        }
    }
        
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
