//
//  CommonButtonsView.swift
//  AsafVideoIMG
//
//  Created by Mobile on 19/08/22.
//

import UIKit



class CommonButtonsView: NiblessView{
   
    func btnImages(_ leftBtnImg: UIImage, _ rightBtnImg: UIImage) {
        rightBtn.setImage(rightBtnImg, for: .normal)
        leftBtn.setImage(leftBtnImg, for: .normal)
    }
    
    var delegate: CommonButtonDelegale? = nil
//    var stickerBackbtnDelegate:StickerCollectButtonDelegale? = nil
    
    private let contentView: UIView = {
        let view = UIView()
        view.isHidden = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var rightBtn: UIButton = { /// Flip Camera Button
        let btn = UIButton()
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
        btn.setImage(UIImage(systemName: "flashlight.off.fill"), for: .normal)
       
        btn.tag = 0
        btn.addTarget(self, action: #selector(btnTapped(btn: )), for: .touchUpInside)
        return btn
    }()
    
    lazy var leftBtn: UIButton = { /// Flip Camera Button
        let btn = UIButton()
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
        btn.setImage(UIImage(systemName: "repeat"), for: .normal)
        btn.tag = 1
        btn.addTarget(self, action: #selector(btnTapped(btn:)), for: .touchUpInside)
        return btn
    }()
 
    
    public init() {//(_delegate: CommonButtonDelegale?) {
        
        super.init(frame: .zero)
//        self.delegate = _delegate
            self.setupView()
            self.layout()
    }
    
    private func setupView() {
        self.backgroundColor = .white
       
    }
    
    private func layout() {
        addSubview(contentView)
        contentView.addSubview(rightBtn)
        contentView.addSubview(leftBtn)
     
        contentView.layout {
            $0.leading.equal(to: self.leadingAnchor, offsetBy: 0)
            $0.trailing.equal(to: self.trailingAnchor, offsetBy: 0)
            $0.top.equal(to: self.topAnchor, offsetBy: 8)
            $0.bottom.equal(to: self.bottomAnchor, offsetBy: 0)
        }
        rightBtn.layout{
            $0.height.equal(to: contentView.heightAnchor,multiplier: 0.95)
            $0.width.equal(to: rightBtn.heightAnchor,multiplier: 1)
            $0.centerY.equal(to: contentView.centerYAnchor)
//            $0.top.equal(to: contentView.topAnchor,offsetBy: 0)
            $0.leading.equal(to: contentView.leadingAnchor, offsetBy: 30, priority: .defaultHigh, multiplier: 1)
        }
        leftBtn.layout{
            $0.width.equal(to: rightBtn.widthAnchor)
            $0.height.equal(to: rightBtn.heightAnchor)
            $0.centerY.equal(to: rightBtn.centerYAnchor)
            $0.trailing.equal(to: contentView.trailingAnchor, offsetBy: -30, priority: .defaultHigh, multiplier: 1)
        }
    }
    
  @objc  func btnTapped(btn: UIButton){
        
      self.delegate?.commonButtonsAction(sender: btn)
      
    }
    
}

