//
//  CommonCollectionView.swift
//  AsafVideoIMG
//
//  Created by Mobile on 19/08/22.
//

import UIKit
import MetalPetal


class GrandCollectionView: NiblessView{
     
    private var selectedIndex = -1
    public var cellId = "CommonCollectionViewCell"
    
    var categorys:[GrandCollectnWork] = [GrandCollectnWork]()
    var dataArray = [Any](){
        didSet{
            grandCollectnVw.reloadData()
        }
    }
    
    var currentWorkFor:GrandCollectnWork? = .filter
    var selectedBlend:MTIBlendMode?
    var delegate:GrandCollectionDelegate?
    var textOptionDelegate:TextOptionsDelegate?
    var textPropertyDelegate:TextPropertiesDelegate?
    var currentAligmentImage:UIImage = UI_Images.centerAlign!
    private var alignCount = 0
    var selectedBgColor:UIColor?{
        didSet{
            grandCollectnVw.reloadData()
        }
    }
    var selectedColor:UIColor?{
        didSet{
            grandCollectnVw.reloadData()
        }
    }
    private let contentView: UIView = {
        let view = UIView()
        view.isHidden = false
       return view
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
    let centerLayout:CenterAlignedCollectionViewFlowLayout = {
        let ly = CenterAlignedCollectionViewFlowLayout()
        ly.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        ly.scrollDirection = .horizontal
        
        return ly
    }()
     let grandCollectnVw:UICollectionView = { // --- collctionview
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectnView = UICollectionView(frame: CGRect.zero,collectionViewLayout: layout)
        collectnView.backgroundColor = .clear
        collectnView.showsHorizontalScrollIndicator = false
        collectnView.showsVerticalScrollIndicator = false
        layout.scrollDirection = .horizontal
        
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
    
    
//MARK: - View Initialisation
    public init() {
        super.init(frame: .zero)
        self.setupView()
        self.layout()
        categorys.append(contentsOf: GrandCollectnWork.allCases)
//        if currentWorkFor == .text{
//            grandCollectnVw.collectionViewLayout = centerLayout
//        }
//        currentWorkFor = .filter
        
        
    }
    
    private func setupView() { // ----Init methods
        self.backgroundColor = .white
        grandCollectnVw.delegate = self
        grandCollectnVw.dataSource = self
        grandCollectnVw.register(GrangCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        filterSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .allTouchEvents)
    }
    // Slider Controller Action
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("touch begain")
            case .moved:
                print("touch move")
                
                Compositions.sliderValue = slider.value
            case .ended:
                print("touch ended")
            default:
                break
            }
        }
    }
    
    // MARK: -----  View Concetraints Layouts
    private func layout() {
        addSubview(contentView)
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(filterSlider)
        vStack.addArrangedSubview(grandCollectnVw)
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
        
        grandCollectnVw.layout{
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: 2)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: -2)
            $0.top.equal(to: filterSlider.bottomAnchor, offsetBy: 2)
            $0.bottom.equal(to: vStack.bottomAnchor, offsetBy: 2)
        }
        
    }
    

}
//MARK: - Collection DataSouce Methods
extension GrandCollectionView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataArray.count != 0{
            return dataArray.count
        }
        else{
            return categorys.count
    }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = grandCollectnVw.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GrangCollectionViewCell
        if dataArray.count != 0{
            switch currentWorkFor {
            case .overlay:
                cell.imageView.isHidden = true
                let filtername = dataArray[indexPath.row] as! MTIBlendMode
                cell.nameLbl.text = filtername.rawValue
            case .focus:
                cell.imageView.isHidden = false
                let focusName = dataArray[indexPath.row] as! BlurFilterEnum
                cell.nameLbl.text = focusName.rawValue
                cell.imageView.image = UIImage(named: "\(focusName.rawValue)Ui")
            case .text:
                cell.imageView.isHidden = false
                let option = dataArray[indexPath.row] as! TextFilterOptions
                cell.nameLbl.text = option.rawValue
                cell.nameLbl.font = UIFont.systemFont(ofSize: 10)
//                cell.imageView.image = UIImage(named: option.rawValue)
                switch option {
                case .font:
                    cell.imageView.image = UI_Images.font
                case .alignment:
                    cell.imageView.image = currentAligmentImage
                case .color:
                    cell.circleImage()
                    
                    if let selectedColor{
                        if selectedColor == UIColor.clear{
                            cell.imageView.image = UI_Images.transBoxes
                        }else{
                            cell.imageView.backgroundColor = selectedColor
                        }
                    }else{
                        cell.imageView.backgroundColor = .black
                    }
                                       
                case.bgColor:
                    cell.circleImage()
                    
                    if let selectedBgColor {
                        if selectedBgColor == UIColor.clear{
                            cell.imageView.image = UI_Images.transBoxes
                        }else{
                            cell.imageView.backgroundColor = selectedBgColor
                        }
                    }else{
                        cell.imageView.image = UI_Images.transBoxes
                    }
                   
//                    cell.imageView.layer.cornerRadius = cell.imageView.frame.height / 2
//                    cell.imageView.layer.borderWidth = 2
//                    cell .imageView.layer.borderColor = UIColor.black.cgColor
                default:
                    cell.imageView.image = UIImage(named: "\(option.rawValue)Ui")
                }
                
            default:
                break
            }
    
        }else{
            let text = categorys[indexPath.row].rawValue
            cell.nameLbl.text = text//images[indexPath.row]
            cell.imageView.isHidden = false
            cell.imageView.image = UIImage(named: text)
        }
         if indexPath.row == selectedIndex{
            cell.imageView.tintColor = .systemBlue
            cell.nameLbl.textColor = .systemBlue
        }
        else{
            cell.imageView.tintColor = .black
            cell.nameLbl.textColor = .black
        }
        
        return cell
    }

  
}
//MARK: -------- Collectionview DidSelect Delegate Method
extension GrandCollectionView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
//        let selectedType = dataArray[indexPath.row] as! MTIBlendMode
        
        switch currentWorkFor{
        case .filter:
            let selectedType = categorys[indexPath.row]
            didselectForNormal(indexPath: indexPath, selectedcategory: selectedType)
        case .overlay:
            didselectForOverlay(indexPath: indexPath)
        case .focus:
            didselectForFocus(indexPath: indexPath)
        case.text:
            didselectForTextOptions(indexPath: indexPath)
        default:
            let selectedType = categorys[indexPath.row]
            didselectForNormal(indexPath: indexPath, selectedcategory: selectedType)
        }
        grandCollectnVw.reloadData()
        
    }
    // --- didselectForHomeScreen
    func didselectForNormal(indexPath:IndexPath,selectedcategory:GrandCollectnWork){
        if let working = currentWorkFor{
        delegate?.didSelectItem(selectedType: selectedcategory,workFor: working)
        }
    }
//    ---- didselectForOverlay
    func didselectForOverlay(indexPath:IndexPath){
        if let working = currentWorkFor{
            delegate?.didSelectItem(selectedType: nil,workFor: working)
        }
        let selected = dataArray[indexPath.row] as! MTIBlendMode
        selectedBlend = selected
        if let blend = selectedBlend{
            FilterImage.shared.blendMode = blend
    }
}
//    ------- didselectForFocus
    func didselectForFocus(indexPath:IndexPath){
        let txt = dataArray[indexPath.row] as! BlurFilterEnum
        if indexPath.row > 0{
            FilterImage.shared.isApplyFilter = true
            if let img = UIImage(named: txt.rawValue ) {
                FilterImage.shared.blurMaskImg = img
                FilterImage.shared.selectedBlurFilter = txt
            }
        }
        else
        {
            FilterImage.shared.blurMaskImg = nil
        }

    }
    func didselectForTextOptions(indexPath:IndexPath){
        let selected = dataArray[indexPath.row] as! TextFilterOptions
        textOptionDelegate?.didSelectItem(selectedOption: selected)
        switch selected {
        case .alignment:
            changeTextalignment()
        case .font:
            UIApplication.visibleViewController.getFont()
            
        default:
            break
        }
        if selected == .alignment{
            
        }
    }
    
    // -- To change TextAlignment
    func changeTextalignment(){
        if alignCount < 3{
            alignCount += 1
        }else{alignCount = 0}
        switch alignCount {
        case 0:
            textPropertyDelegate?.didselectAlignment?(alignment: .center)
            currentAligmentImage = UI_Images.centerAlign!
        case 1:
            textPropertyDelegate?.didselectAlignment?(alignment: .left)
            currentAligmentImage = UI_Images.leftAlign!
        case 2:
            textPropertyDelegate?.didselectAlignment?(alignment: .right)
            currentAligmentImage = UI_Images.rightAlign!
        default:
            textPropertyDelegate?.didselectAlignment?(alignment: .center)
            currentAligmentImage = UI_Images.centerAlign!
        }
    }
    
}

//MARK: -------- Collectionview Layout Methods
extension GrandCollectionView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch currentWorkFor {
        case .overlay:
            let label = UILabel(frame: CGRect.zero)
        let filtername = dataArray[indexPath.row] as! MTIBlendMode
        label.text = filtername.rawValue
                label.sizeToFit()
            return CGSize(width: label.frame.width + 25, height: grandCollectnVw.frame.height / 1.2)
            
        case .text:
        
            return CGSize(width: grandCollectnVw.frame.width / 4, height: grandCollectnVw.frame.height / 1.2)
        default:
            return CGSize(width: grandCollectnVw.frame.width / 4, height: grandCollectnVw.frame.height / 1.3)
        }
    }
//    func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
//        let totalWidth = cellWidth * numberOfItems
//        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
//        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
}

