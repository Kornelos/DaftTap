//
//  PlayViewController.swift
//  DaftTap
//
//  Created by Kornel Skórka on 12/05/2019.
//  Copyright © 2019 Kornel Skórka. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    let shapeLayer = CAShapeLayer()
    var topResults = [GameResultModel]()
    var gameModel = GameModel()
    var mainLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLabel()
        setupProgressBar()
        loadTopResults()
        var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountdown), userInfo: nil, repeats: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
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
        mainLabel = UILabel(frame: CGRect(x: w / 2, y: h / 2, width: 240, height: 100))
        mainLabel.center = CGPoint(x: w / 2, y: h / 2)
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont(name: "Helvetica", size: 42)
        mainLabel.textColor = .black
        self.view?.addSubview(mainLabel)
    }
    //MARK: Timers
    @objc func startCountdown() {
        if gameModel.countdown > 0 {
            if(gameModel.countdown - 1 == 0){
                mainLabel.text = "Tap!"
                gameModel.isPlayable = true
                gameModel.startTime = getTime()
                var _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameTimer), userInfo: nil, repeats: true)
                let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
                basicAnimation.toValue = 1
                basicAnimation.duration = 6
                basicAnimation.fillMode = CAMediaTimingFillMode.forwards
                basicAnimation.isRemovedOnCompletion = false
                shapeLayer.add(basicAnimation, forKey: "urSoBasic")
            } else {
                mainLabel.text = String(gameModel.countdown-1)
                mainLabel.alpha = 0
                mainLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                UIView.animate(withDuration: 0.2, animations: {
                    self.mainLabel.alpha = 1
                    self.mainLabel.transform = .identity
                })
                
            }
            gameModel.countdown -= 1
        }
    }
    
    @objc func gameTimer() {
        if gameModel.gameTime > 0 {
            if(gameModel.gameTime == 1){
                gameModel.isPlayable = false
                mainLabel.text = "👌🏻\(gameModel.score)👌🏻"
                addToTop(result: gameModel.score, time: gameModel.startTime)
                finalAlert()
            }
            gameModel.gameTime -= 1
        }
    }
    //MARK: tap handler
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        if(gameModel.isPlayable){
            spawnEmoji(at: tap.location(in: view))
            gameModel.score += 1
            mainLabel.text = String(gameModel.score)
            mainLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.2, animations: {
                self.mainLabel.transform = .identity
            })
            
        }
    }
    //timestamp
    func getTime()->String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
        return dateString
    }
    
    func spawnEmoji(at location: CGPoint){
        let size: CGFloat = 100
        let spawnedEmoji = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        spawnedEmoji.font = UIFont(name: "Helvetica", size: 40)
        spawnedEmoji.center = location
        spawnedEmoji.backgroundColor = .clear
        spawnedEmoji.text = gameModel.emojis.randomElement()
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
    //MARK: end game alert
    func finalAlert(){
        var finalMessage: String = "You scored \(gameModel.score) taps. 🔥"
        if isTop(){
            finalMessage += "This places you on High score board!👏"
        }
        let alertController = UIAlertController(title: "Game finished!", message: finalMessage, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Back to menu.", style: .default) { (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    func isTop()->Bool{
        if topResults.isEmpty == true {
            return true
        }
        for result in topResults{
            if result.taps < gameModel.score{
                return true
            }
        }
        return false
    }
    //MARK: adding data to collection view top list.
    func loadTopResults(){
        if let fetchedData = UserDefaults.standard.data(forKey: "topResults"){
            topResults = try! PropertyListDecoder().decode([GameResultModel].self, from: fetchedData)
        } else{
            topResults = [GameResultModel]()
        }
    }
    func addToTop(result: Int, time: String){
        let result = GameResultModel(with: result, time: time)
        topResults.append(result)
        topResults.sort(by: {return $0.taps > $1.taps})
        if topResults.count > 5{
            topResults = topResults.dropLast()
        }
        let resultsData = try! PropertyListEncoder().encode(topResults)
        UserDefaults.standard.set(resultsData,forKey: "topResults")
    }
}
