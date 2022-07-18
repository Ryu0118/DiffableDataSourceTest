//
//  CollectionViewCell.swift
//  CollectionViewPractice
//
//  Created by 上條栞汰 on 2022/07/18.
//

import UIKit
import SRCircleProgress

class CollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var baseView: SRCircleProgress!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .blue
        
        baseView.setProgress(0.5, animated: true)
        // Initialization code
    }

}
