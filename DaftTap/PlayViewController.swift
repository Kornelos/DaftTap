//
//  PlayViewController.swift
//  DaftTap
//
//  Created by Mikołaj Hościło on 12/05/2019.
//  Copyright © 2019 Kornel Skórka. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    
    var countdown = 4 //change to 4
    var gameTime = 5
    var label = UILabel()
    var isPlayable: Bool = false
    var score: Int = 0
    let shapeLayer = CAShapeLayer()
    let defaults = UserDefaults.standard
    var topResults = [GameResultModel]()
    let emojis = ["🔥","😂","😎","👍","🙀","👏","👏","👌","🔥","🌈","⚡️"]
    var startTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLabel()
        setupProgressBar()
        loadTopResults()
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountdown), userInfo: nil, repeats: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
//        addToTop(result: 9, time: getTime())
//        addToTop(result: 90, time: getTime())
//        addToTop(result: 21, time: getTime())
//        addToTop(result: 100, time: getTime())
//        addToTop(result: 5, time: getTime())
//        addToTop(result: 1, time: getTime())
        
        // Do any additional setup after loading the view.
    }
    //MARK: SetupUI
    func setupProgressBar(){
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackLayer)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    func setupLabel(){
        let w = view.bounds.width
        let h = view.bounds.height
        label = UILabel(frame: CGRect(x: w / 2, y: h / 2, width: 240, height: 100))
        label.center = CGPoint(x: w / 2, y: h / 2)
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 42)
        label.textColor = .black
        self.view?.addSubview(label)
    }
    //MARK: Timers
    @objc func startCountdown() {
        if countdown > 0 {
            if(countdown - 1 == 0){
                label.text = "Start!"
                isPlayable = true
                startTime = getTime()
                var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameTimer), userInfo: nil, repeats: true)
                let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
                basicAnimation.toValue = 1
                basicAnimation.duration = 6
                basicAnimation.fillMode = CAMediaTimingFillMode.forwards
                basicAnimation.isRemovedOnCompletion = false
                shapeLayer.add(basicAnimation, forKey: "urSoBasic")
            } else {
                label.text = String(countdown-1)
                label.alpha = 0
                label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                UIView.animate(withDuration: 0.2, animations: {
                    self.label.alpha = 1
                    self.label.transform = .identity
                })
                
            }
            countdown -= 1
        }
    }
    
    @objc func gameTimer() {
        if gameTime > 0 {
            if(gameTime == 1){
                isPlayable = false
                label.text = "👌🏻\(score)👌🏻"
                addToTop(result: score, time: startTime)
            }
            gameTime -= 1
        }
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        if(isPlayable){
            spawnEmoji(at: tap.location(in: view))
            score += 1
            label.text = String(score)
            label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.2, animations: {
                self.label.transform = .identity
            })
            
        }
    }
    private func getTime()->String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        return dateString
    }
    private func spawnEmoji(at location: CGPoint){
        let size: CGFloat = 100
        let spawnedEmoji = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        spawnedEmoji.font = UIFont(name: "Helvetica", size: 40)
        spawnedEmoji.center = location
        spawnedEmoji.backgroundColor = .clear
        spawnedEmoji.text = emojis.randomElement()
        view.addSubview(spawnedEmoji)
        spawnedEmoji.alpha = 0
        spawnedEmoji.transform = CGAffineTransform(scaleX: 3, y: 3)
        UIView.animate(withDuration: 0.2, animations: {
            spawnedEmoji.alpha = 1
            spawnedEmoji.transform = .identity
        }, completion: { completed in
            UIView.animate(withDuration: 0.4, animations: {
                spawnedEmoji.alpha = 0
                spawnedEmoji.transform = CGAffineTransform(scaleX: 3, y: 3)
            }, completion: { completed in
                spawnedEmoji.removeFromSuperview()
            })
        })
    }
    func loadTopResults(){
        if let fetchedData = defaults.data(forKey: "topResults"){
         topResults = try! PropertyListDecoder().decode([GameResultModel].self, from: fetchedData)
        } else{
            topResults = [GameResultModel]()
        }
        print(topResults)
    }
    func addToTop(result: Int, time: String){
        let result = GameResultModel(with: result, time: time)
        topResults.append(result)
        topResults.sort(by: {return $0.result > $1.result})
        if topResults.count > 5{
            topResults = topResults.dropLast()
        }
        let resultsData = try! PropertyListEncoder().encode(topResults)
        defaults.set(resultsData,forKey: "topResults")
        }
    
    
}
