//
//  TextView.swift
//  AsafVideoIMG
//
//  Created by Mobile on 21/09/22.
//

import Foundation
import UIKit


class TextView: NiblessView{
    
    
     let contentView: UIView = {
        let view = UIView()
        view.isHidden = false
       return view
    }()
    
   
    let vStack : UIStackView = { // Add Vertical Stack
        let stack = UIStackView()
        stack.axis  = .horizontal
        stack.distribution  = .fillEqually
        stack.spacing = 2
//        stack.alignment = .center
        return stack
    }()

    
    let fontButton:UIButton = {
      
        let btn = UIButton()
        btn.backgroundColor = .red
        if #available(iOS 15.0, *) {
            var config = btn.configuration
            config?.image = UIImage(systemName: "textformat.abc")
            config?.imagePlacement = .top
            config?.imagePadding = 15
            
            btn.configuration = config
        } else {
            // Fallback on earlier versions
        }
        btn.setTitle("Font", for: .normal)
        return btn
        
    }()
    let colorButton:UIButton = {
        let btn = UIButton()
//        btn.contentHorizontalAlignment = .fill
//        btn.contentVerticalAlignment = .fill
        btn.setImage(ButtonImages.redo, for: .normal)
        btn.backgroundColor = .red
        
        btn.tag = 4
//        btn.addTarget(self, action: #selector(btnTapped(btn: )), for: .touchUpInside)
        return btn
        
    }()
    let bgButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.setTitle("BG Color", for: .normal)
        return btn
        
    }()
    let alignmentButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.setTitle("Alignment", for: .normal)
        return btn
        
    }()
    
    
    public init() {
        
        super.init(frame: .zero)
        
            self.setupView()
            self.layout()
    }
    
    
    func setupView(){
        
    }
    func layout(){
        
        self.addSubview(contentView)
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(fontButton)
        vStack.addArrangedSubview(colorButton)
        vStack.addArrangedSubview(bgButton)
        vStack.addArrangedSubview(alignmentButton)
                
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
}
