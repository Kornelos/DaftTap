//
//  ViewController.swift
//  30sec
//
//  Created by Mikołaj Hościło on 12/05/2019.
//  Copyright © 2019 Kornel Skórka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = view.bounds.size.height
        //title
        let title = UILabel(frame: .zero)
        title.text = "Daft Tap Challange"
        title.textAlignment = .center
        title.font = UIFont(name: "Helvetica", size: 36)
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        title.topAnchor.constraint(equalTo: self.view.topAnchor, constant:  screenHeight/9).isActive = true
        title.heightAnchor.constraint(equalToConstant: screenHeight/9).isActive = true
        title.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        title.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        //button
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: title.bottomAnchor, constant: screenHeight/9).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        button.heightAnchor.constraint(equalToConstant:  screenHeight/9).isActive = true
        button.addTarget(self, action: #selector(self.playClicked), for: .touchUpInside)
        button.titleLabel?.font = UIFont.init(name: "Helvetica", size: 30)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("PLAY", for: .normal)
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 1.0
        //collection
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 60)
        let collectionFrame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 400)
        let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibCell = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "MyCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: screenHeight/9).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 2 * screenHeight/3)
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        collectionView.backgroundColor = .white
        view.backgroundColor = .white
    }
   @objc func playClicked(sender: UIButton!)
    {
        print("Click")
        let vc = PlayViewController() //change this to your class name
        self.present(vc, animated: true, completion: nil)
    }

}
extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CollectionViewCell
        //cell.backgroundColor = .black
        // Configure the cell
        cell.nameLabel.text = "TEST"
        return cell
    }
    
    
}
