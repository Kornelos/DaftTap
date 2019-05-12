//
//  ViewController.swift
//  30sec
//
//  Created by Mikołaj Hościło on 12/05/2019.
//  Copyright © 2019 Kornel Skórka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var topResults: [(String,String)] = []
    let defaults = UserDefaults.standard
    
    let topLabel: UILabel = {
        let title  = UILabel(frame: .zero)
        title.text = "Daft Tap Challange"
        title.textAlignment = .center
        title.font = UIFont(name: "Helvetica", size: 36)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    let playButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.init(name: "Helvetica", size: 30)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("PLAY", for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playClicked), for: .touchUpInside)
        return button
    }()
    let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 60)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let nibCell = UINib(nibName: "CollectionViewCell", bundle: nil)
        collection.register(nibCell, forCellWithReuseIdentifier: "MyCell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        return collection
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setupConstraints()
        loadTopResults()
        
        view.backgroundColor = .white
    }
    private func setupConstraints(){
        let screenHeight = view.bounds.size.height
        //title
        view.addSubview(topLabel)
        topLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant:  screenHeight/9).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: screenHeight/9).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        topLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        //button
        view.addSubview(playButton)
        playButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: screenHeight/9).isActive = true
        playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        playButton.heightAnchor.constraint(equalToConstant:  screenHeight/9).isActive = true
        //collection
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: screenHeight/9).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 2 * screenHeight/3)
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    @objc func playClicked(sender: UIButton!)
    {
        print("Click")
        let vc = PlayViewController()
        self.present(vc, animated: true, completion: nil)
    }
    func loadTopResults(){
        let top = defaults.object(forKey: "topResults") as? [String:String] ?? [String:String]()
        topResults = top.map({return ($0.key,$0.value)} )
        
    }
}
extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CollectionViewCell
        //cell.backgroundColor = .black
        // Configure the cell
        cell.scoreLabel.text = "\(indexPath.row+1).Score: \(topResults[indexPath.row].0)"
        cell.timeLabel.text = topResults[indexPath.row].1
        return cell
    }
    
    
}
