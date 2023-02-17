//
//  ViewController+CollectionViewDatasourceDelegate.swift
//  IlaBankDemo
//
//  Created by webwerks on 17/02/23.
//

import UIKit

//MARK: Collection vieew datasource & delegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = viewModel?.getCarousalDataArr() {
            return data.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VcConstants.carouselCollectionCell, for: indexPath) as? CarouselCollectionCell
        if let carousalDataArr = viewModel?.getCarousalDataArr(), let headerImage = carousalDataArr[indexPath.item].headerImage {
            cell?.setData(headerImgStr: headerImage)
        }
        return cell ?? UICollectionViewCell()
    }
}
