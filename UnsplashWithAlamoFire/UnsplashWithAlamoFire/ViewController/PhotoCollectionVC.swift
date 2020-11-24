//
//  PhotoCollectionVC.swift
//  UnsplashWithAlamoFire
//
//  Created by sangheon on 2020/11/20.
//

import UIKit

class PhotoCollectionVC: BaseVC,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var collectionView:UICollectionView!
    var Photoarr:[Photo] = [Photo]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        UIDesine()
        collectionView.reloadData()
    }
    func fetchData() {
        MyAlamoFiremanager
            .shared
            .getPhotos(searchTerm: self.vcTitle, completion: {
            [weak self]result in
                switch result {
                case .success(let fetchedPhotos) :
                    print("HomeVC -getPhotos.success -fetchedPhotos.count: \(fetchedPhotos.count)")
                    self?.Photoarr = fetchedPhotos
                    print("HomeVC -getPhotos.success -fetchedPhotos.coun:\(self!.Photoarr)")
                case .failure(let error):
                    print("HOmeVC - getPhotos.failure - error: \(error.rawValue)")
                }
        })
    }
    
    func UIDesine() {
        let collectionLayout:UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 260 , height: 200 )
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets.zero
            layout.scrollDirection = .vertical
            return layout
        }()
        collectionView.collectionViewLayout = collectionLayout
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Photoarr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell:PhotoCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCollectionCell else {
            return UICollectionViewCell()
        }
        let photoTest:Photo = self.Photoarr[indexPath.item]
        
        cell.Image?.image = nil
        
        DispatchQueue.global().async {
            
            guard let imageURL:URL = URL(string:photoTest.thumnail) else {
                print("@@@@@@@@@@@@@@@@@@@@@@\(photoTest.thumnail)")
                return
            }
            print("@@@@@@@@@@@@@@@\(imageURL)")
            
            guard let imageData: Data = try? Data(contentsOf: imageURL) else {
                return
            }
            DispatchQueue.main.async {
                if let index:IndexPath = collectionView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.Image?.image = UIImage(data: imageData)
                        cell.setNeedsLayout()
                        cell.layoutIfNeeded()
                    }
                }
            
            }
        }
        return cell
        
    }
    
}
