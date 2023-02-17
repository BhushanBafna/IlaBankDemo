//
//  NaturePicListingTableCell.swift
//  IlaBankDemo
//
//  Created by webwerks on 17/02/23.
//

import UIKit

class NaturePicListingTableCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setupUI() {
        imgView.layer.cornerRadius = 5
    }
    
    func setupData(data: ImageDetails) {
        descLbl.text = data.text
        if let imgNameStr = data.img {
            imgView.image = UIImage(named: imgNameStr)
        }
    }
}
