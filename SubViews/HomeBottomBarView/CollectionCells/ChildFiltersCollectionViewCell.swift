//
//  SubFiltersCollectionViewCell.swift
//  AsafVideoIMG
//
//  Created by Mobile on 18/08/22.
//

import UIKit

class ChildFiltersCollectionViewCell: UICollectionViewCell {
    
    let imageView:UIImageView = {
       let imgVw = UIImageView()
        imgVw.contentMode = .scaleAspectFill
        imgVw.clipsToBounds = true
        imgVw.layer.masksToBounds = true
        return imgVw
    }()
    let nameLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.backgroundColor = .lightGray
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
          }
    
    func addViews(){
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        addSubview(imageView)
        imageView.addSubview(nameLbl)
        imageView.image = UIImage(named: "filterImage")
        imageView.layout{
            $0.leading.equal(to: self.leadingAnchor,offsetBy: 2)
            $0.trailing.equal(to: self.trailingAnchor,offsetBy: -2)
            $0.top.equal(to: self.topAnchor,offsetBy: 2)
            $0.bottom.equal(to: self.bottomAnchor,offsetBy: -5)
        }
        nameLbl.layout{
            $0.centerX.equal(to: self.centerXAnchor,multiplier: 1)
            $0.centerY.equal(to: self.centerYAnchor,multiplier: 1.4)
            $0.width.lessThanOrEqual(to: imageView.widthAnchor)
        }
     
        
     }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    
}
