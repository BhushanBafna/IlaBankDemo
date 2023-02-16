//
//  ViewController+CollectionViewDatasourceDelegate.swift
//  IlaBankDemo
//
//  Created by webwerks on 14/02/23.
//

import UIKit

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = viewModel?.getCarousalDataArr() {
            return data.count
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgCorousalCVCell", for: indexPath) as? ImgCorousalCVCell
        if let carousalDataArr = viewModel?.getCarousalDataArr(), let headerImage = carousalDataArr[indexPath.item].headerImage {
            cell?.setData(headerImgStr: headerImage)
        }
        return cell ?? UICollectionViewCell()
    }
}