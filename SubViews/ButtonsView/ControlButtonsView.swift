//
//  ControllButtonsView.swift
//  AsafVideoIMG
//
//  Created by Mobile on 03/10/22.
//

import Foundation
import UIKit

class ControlButtonsView: NiblessView{
    
    
    
    private let contentView: UIView = {
        let view = UIView()
        view.isHidden = false
//        view.layer.cornerRadius = 12
        return view
    }()
    
    var delegate:ControlButtonsDelegale!
    var btnsBgColor:UIColor =  UIColor.black.withAlphaComponent(0.5)
    var btnsTintColor:UIColor = .white
    
    let vStack : UIStackView = { // Add Vertical Stack
        let stack = UIStackView()
        stack.axis  = .horizontal
        stack.distribution  = .fillEqually
        stack.spacing = 2
//        stack.alignment = .center
        return stack
    }()
    
    lazy var btn0: UIButton = { /// Flip Camera Button
        let btn = UIButton()
//        btn.contentHorizontalAlignment = .
//        btn.contentVerticalAlignment = .fill
        btn.setImage(ButtonImages.add, for: .normal)
        btn.backgroundColor = btnsBgColor
        btn.tintColor = btnsTintColor
        btn.tag = 0
        btn.addTarget(self, action: #selector(btnTapped(btn: )), for: .touchUpInside)
        return btn
    }()
    lazy var btn1: UIButton = { /// Flip Camera Button
        let btn = UIButton()
//        btn.contentHorizontalAlignment = .fill
//        btn.contentVerticalAlignment = .fill
        btn.setImage(ButtonImages.delete, for: .normal)
        btn.backgroundColor = btnsBgColor
        btn.tintColor = btnsTintColor
        btn.tag = 1
        btn.addTarget(self, action: #selector(btnTapped(btn: )), for: .touchUpInside)
        return btn
    }()
    lazy var btn2: UIButton = { /// Flip Camera Button
        let btn = UIButton()
//        btn.contentHorizontalAlignment = .fill
//        btn.contentVerticalAlignment = .fill
        btn.setImage(ButtonImages.remove, for: .normal)
        btn.backgroundColor = btnsBgColor
        btn.tintColor = btnsTintColor
        btn.tag = 2
        btn.addTarget(self, action: #selector(btnTapped(btn: )), for: .touchUpInside)
        return btn
    }()
    lazy var btn3: UIButton = { /// Flip Camera Button
        let btn = UIButton()
//        btn.contentHorizontalAlignment = .fill
//        btn.contentVerticalAlignment = .fill
        btn.setImage(ButtonImages.undo, for: .normal)
        btn.backgroundColor = btnsBgColor
        btn.tintColor = btnsTintColor
        btn.tag = 3
        btn.addTarget(self, action: #selector(btnTapped(btn:)), for: .touchUpInside)
        return btn
    }()
    lazy var btn4: UIButton = { /// Flip Camera Button
        let btn = UIButton()
//        btn.contentHorizontalAlignment = .fill
//        btn.contentVerticalAlignment = .fill
        btn.setImage(ButtonImages.redo, for: .normal)
        btn.backgroundColor = btnsBgColor
        btn.tintColor = btnsTintColor
        btn.tag = 4
        btn.addTarget(self, action: #selector(btnTapped(btn: )), for: .touchUpInside)
        return btn
    }()
    let view1:UIView = {
        let vw = UIView()
        return vw
    }()
    let view2:UIView = {
        let vw = UIView()
        return vw
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
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(btn0)
        vStack.addArrangedSubview(btn1)
        vStack.addArrangedSubview(view1)
        vStack.addArrangedSubview(btn2)
        vStack.addArrangedSubview(view2)
        vStack.addArrangedSubview(btn3)
        vStack.addArrangedSubview(btn4)
        
//        contentView.addSubview(leftBtn)
      
        contentView.layout {
            $0.leading.equal(to: self.leadingAnchor, offsetBy: 0)
            $0.trailing.equal(to: self.trailingAnchor, offsetBy: 0)
            $0.top.equal(to: self.topAnchor, offsetBy: 0)
            $0.bottom.equal(to: self.bottomAnchor, offsetBy: 0)
        }
        vStack.layout {
            $0.leading.equal(to: contentView.leadingAnchor, offsetBy: 0)
            $0.trailing.equal(to: contentView.trailingAnchor, offsetBy: 0)
            $0.top.equal(to: contentView.topAnchor, offsetBy: 2)
            $0.bottom.equal(to: contentView.bottomAnchor, offsetBy: 0)
        }
        
    }
    @objc  func btnTapped(btn: UIButton){
        print("btnClick")
        self.delegate.controlButtonsAction(sender: btn)
//        self.delegate?.btnClicked(sender: btn)
        
      }
}
