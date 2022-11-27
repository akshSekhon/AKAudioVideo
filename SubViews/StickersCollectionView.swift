//
//  StickersCollectionView.swift
//  AsafVideoIMG
//
//  Created by Mobile on 21/09/22.
//

import Foundation
import UIKit



class StickersCollectionView: NiblessView, CommonButtonDelegale{
    func commonButtonsAction(sender: UIButton) {
        btnDelegate?.btnClickedFromStickers(sender: sender)
    }
  
    
    public var filterNames  = [String]()
     var selectedIndex = -1
    public var cellId = "StickerCollectionCell"
    var sliderValue:Float = 0
  
    var namesArr = [Any](){
        didSet{
            grandCollectnVw.reloadData()
        }
    }
    
    var currentWorkFor:GrandCollectnWork?
    var delegate:StickerCollectionDelegate?
    var btnDelegate:StickerCollectButtonDelegale?
    
    private let contentView: UIView = {
        let view = UIView()
        view.isHidden = false
       return view
    }()
    
    var btnView:CommonButtonsView = {
        let vw = CommonButtonsView()
        return vw
    }()

    
    let vStack : UIStackView = { // Add Vertical Stack
        let stack = UIStackView()
        stack.frame = UIScreen.main.bounds
        stack.axis  = .vertical
        stack.distribution  = .fill
        stack.alignment = .center
        stack.spacing   = 5
        return stack
        
    }()
    
    private let grandCollectnVw:UICollectionView = { // --- collctionview
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectnView = UICollectionView(frame: CGRect.zero,collectionViewLayout: layout)
        collectnView.backgroundColor = .clear
        collectnView.showsHorizontalScrollIndicator = false
        collectnView.showsVerticalScrollIndicator = false
        layout.scrollDirection = .vertical
        return collectnView
    }()
     let filterSlider:UISlider = {
        let slider = UISlider()
        slider.isHidden = true
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 0
        return slider
    }()
    
    public init() {
        super.init(frame: .zero)
//        btnView? = CommonButtonsView(_delegate: btnDelegate)
//        btnView.stickerBackbtnDelegate = self
        btnView.delegate = self
        self.setupView()
        self.layout()
        btnView.btnImages(ButtonImages.backArrow!, ButtonImages.backArrow!)
        btnView.leftBtn.isHidden = true
        let name = "stick"
        for i in 1...8{
        let nm = name + "\(i)"
            namesArr.append(nm)
        }
        
        
        currentWorkFor = .filter
    }
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) { // Slider Controller Action
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("touch begain")
            case .moved:
                print("touch move")
                sliderValue = slider.value
                Compositions.sliderValue = slider.value
                let vai = ((0 - sliderValue) / 50)
                
                print("slider range 1 to -1 range is ",vai)
            case .ended:
                print("touch ended")
            default:
                break
            }
        }
    }
    
    private func setupView() { // ----Init methods
        self.backgroundColor = .white
        grandCollectnVw.delegate = self
        grandCollectnVw.dataSource = self
        grandCollectnVw.register(StickerCollectionCell.self, forCellWithReuseIdentifier: cellId)
        filterSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .allTouchEvents)
    }
    
    private func layout() {
        addSubview(contentView)
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(filterSlider)
        vStack.addArrangedSubview(grandCollectnVw)
        vStack.addArrangedSubview(btnView)
        contentView.backgroundColor = .systemGray4
        contentView.layout {
            $0.leading.equal(to: self.leadingAnchor, offsetBy: 0)
            $0.trailing.equal(to: self.trailingAnchor, offsetBy: 0)
            $0.top.equal(to: self.topAnchor, offsetBy: 0)
            $0.bottom.equal(to: self.bottomAnchor, offsetBy: 0)
        }
        
        vStack.layout{
            $0.leading.equal(to: contentView.leadingAnchor,offsetBy: 0)
            $0.trailing.equal(to: contentView.trailingAnchor,offsetBy: -2)
            $0.top.equal(to: contentView.topAnchor, offsetBy: 0)
            $0.bottom.equal(to: contentView.bottomAnchor, offsetBy: 0)
        }
        
        filterSlider.layout {
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: 10)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: 10)
            $0.top.equal(to: vStack.topAnchor)
            $0.height.equal(to: 40)
        }
        btnView.layout{
            $0.height.equal(to: 40)
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: 2)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: -2)
//            $0.top.equal(to: filterSlider.bottomAnchor, offsetBy: 2)
            $0.bottom.equal(to: vStack.bottomAnchor, offsetBy: 2)
        }
        grandCollectnVw.layout{
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: 2)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: -2)
            $0.top.equal(to: filterSlider.bottomAnchor, offsetBy: 2)
            $0.bottom.equal(to: btnView.topAnchor, offsetBy: 2)
        }
       
        
    } // MARK: -  View Layouts
    
    
}
//MARK: - Collection View Methods
extension StickersCollectionView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return namesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = grandCollectnVw.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StickerCollectionCell

                cell.imageView.isHidden = false
                let stickerName = namesArr[indexPath.row] as! String
                cell.nameLbl.text = stickerName
        
                cell.imageView.image = UIImage(named: stickerName)
       
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
    return CGSize(width: grandCollectnVw.frame.width / 5, height: grandCollectnVw.frame.height / 10)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = grandCollectnVw.cellForItem(at: indexPath) as! StickerCollectionCell
        selectedIndex = indexPath.row
        if let img = cell.imageView.image{
            self.delegate?.didSelectItem(indexPath: indexPath, image: img)
        }
//        grandCollectnVw.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = grandCollectnVw.cellForItem(at: indexPath)
        cell?.backgroundColor = .lightGray
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = grandCollectnVw.cellForItem(at: indexPath)
        cell?.backgroundColor = .clear
    }
}
