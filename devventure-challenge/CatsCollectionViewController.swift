//
//  CatsCollectionViewController.swift
//  devventure-challenge
//
//  Created by Evandro de Paula on 12/06/20.
//  Copyright © 2020 DevVenture. All rights reserved.
//

import UIKit

class CatsCollectionViewController: UICollectionViewController {

    //MARK: - Properties
    var linkData:[ImageLink] = []
    private let reuseIdentifier = "Cell"
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        loadImgurData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Methods
    func loadImgurData() {
        ImgurAPI.loadCatData { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let catData):
                var links:[ImageLink] = []
                for images in catData {
                    for link in images.images{
                        links.append(link)
                    }
                }
                self.linkData = links
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure:
                print("error")
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return linkData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CatImageCollectionViewCell else {return UICollectionViewCell()}
        
        if linkData.count == 0 {
            return cell
        }
    
        let imgurData = linkData[indexPath.row]
        cell.catImageView.downloaded(from: imgurData.link)
        return cell
    }

}
