//
//  CommonCollectonViewCell.swift
//  AsafVideoIMG
//
//  Created by Mobile on 19/08/22.
//

import UIKit

class GrangCollectionViewCell: UICollectionViewCell {
    
    var imageRounded:Bool?{
        didSet{
            
        }
    }
    
    let vStack : UIStackView = { // Add Vertical Stack
        let stack = UIStackView()
        stack.axis  = .vertical
        stack.distribution  = .fill
        stack.alignment = .center
        stack.spacing   = 0
        return stack
        
    }()
    
    let imageView:UIImageView = {
       let imgVw = UIImageView()
        imgVw.contentMode = .scaleAspectFit
        imgVw.clipsToBounds = true
        return imgVw
    }()
    let nameLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.backgroundColor = .clear
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addViews()
          }

    
    
    func addViews(){
        addSubview(vStack)
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(nameLbl)
//        addSubview(imageView)
//       addSubview(nameLbl)
        imageView.image = UIImage(named: "filterImage")
        
        vStack.layout{
            $0.leading.equal(to: self.leadingAnchor,offsetBy: 0)
            $0.trailing.equal(to: self.trailingAnchor,offsetBy: -2)
            $0.top.equal(to: self.topAnchor, offsetBy: 0)
            $0.bottom.equal(to: self.bottomAnchor, offsetBy: 0)
        }
        
        
        imageView.layout{
            $0.top.equal(to: vStack.topAnchor,offsetBy: 0)
//            $0.centerY.equal(to: vStack.centerYAnchor,multiplier: 0.5)
            $0.centerX.equal(to: vStack.centerXAnchor,multiplier: 1)
            $0.height.equal(to: vStack.heightAnchor,multiplier: 0.4)
            $0.width.equal(to: imageView.heightAnchor,multiplier: 1)
            
        }
        nameLbl.layout{
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: 2)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: -2)
//            if imageHide{
//                $0.centerY.equal(to: vStack.centerYAnchor,multiplier: 1)
//            }else{
                $0.top.equal(to: imageView.bottomAnchor,offsetBy: 0)
//            }
            
//
        }
     
        
     }
    func circleImage(){
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        imageView.layoutIfNeeded()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    
    
}
