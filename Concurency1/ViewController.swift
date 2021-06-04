//
//  ViewController.swift
//  Concurency1
//
//  Created by Azat Kaiumov on 04.06.2021.
//

import UIKit

class ViewController: UICollectionViewController {
    private var cellSize: CGSize?
    private var spacing: CGFloat = 10
    private let columns = 3
    
    private var urls = [URL]()
    
    private func loadUrls() {
        guard let apiUrl = URL(string: "https://picsum.photos/v2/list?page=1&limit=200") else {
            return
        }
        
        guard let data = try? Data(contentsOf: apiUrl) else {
            return
        }
        
        let decoder = JSONDecoder()
        
        guard let photos = try? decoder.decode([PhotoItem].self, from: data) else {
            return
        }
        
        urls = photos.compactMap { URL(string: $0.download_url) }
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUrls()
    }
    
    
}

extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PhotoCell  else {
            fatalError("Can't dequeue the PhotoCell")
        }
        
        let url = urls[indexPath.item]
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        
        guard let imageData = try? Data(contentsOf: url)  else {
            return cell
        }
        
        let image = UIImage(data: imageData)
        cell.imageView.image = image
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("Can't cast layout to Flow")
        }
        
        let availableSpace =
            view.frame.size.width -
            layout.sectionInset.left -
            layout.sectionInset.right -
            spacing * CGFloat(columns)
        
        let itemSize = availableSpace / CGFloat(columns)
        
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}
