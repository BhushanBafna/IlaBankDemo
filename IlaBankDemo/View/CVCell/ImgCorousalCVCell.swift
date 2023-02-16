//
//  ImgCorousalCVCell.swift
//  IlaBankDemo
//
//  Created by webwerks on 14/02/23.
//

import UIKit

class ImgCorousalCVCell: UICollectionViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }
    
    private func setupUI() {
        imgView.layer.cornerRadius = 5
    }
    
    func setData(headerImgStr: String) {
        imgView.image = UIImage(named: headerImgStr)
    }
}
