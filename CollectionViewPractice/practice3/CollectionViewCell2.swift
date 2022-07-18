//
//  CollectionViewCell2.swift
//  CollectionViewPractice
//
//  Created by 上條栞汰 on 2022/07/18.
//

import UIKit

protocol CollectionViewCell2Delegate: AnyObject {
    func cell2DidTap(_ cell: CollectionViewCell2, level: ViewController3.Level)
}

class CollectionViewCell2: UICollectionViewCell {
    
    weak var delegate: CollectionViewCell2Delegate?
    var level: ViewController3.Level?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .blue
        // Initialization code
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellDidTap))
        addGestureRecognizer(tapGesture)
    }
    
    func configure(level: ViewController3.Level) {
        self.level = level
    }
    
    @objc private func cellDidTap() {
        guard let level = level else { return }
        delegate?.cell2DidTap(self, level: level)
    }

}
