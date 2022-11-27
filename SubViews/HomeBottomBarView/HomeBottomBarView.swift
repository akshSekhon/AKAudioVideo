//
//  MainBottomBar.swift
//  SampleProject
//
//  Created by Mobile on 17/08/22.
//

import UIKit
import MetalPetal



class HomeBottomBarView: NiblessView{
    
  
    private var selectedIndex = -1
    public var cellId = "FiltersCollectionViewCell"
    var delegateCoposition:GrandCollectionDelegate!
    var textPropDelegate:TextPropertiesDelegate?
    var textSubOption:TextFilterOptions?
   
    private var cellExpended = true
    var filterSliderIsHidden:Bool = true{
        didSet{
            if filterSliderIsHidden{
                filterSlider.isHidden = true
            }else{filterSlider.isHidden = false}
        }
    }
   
    public var thumImage:UIImage?{
        didSet{
            parentFiltersCollectionView.reloadData()
        }
    }
    private var selectedEffect:VideoEffect! = .Orignal{
        didSet{
            FilterImage.shared.filterType = selectedEffect
        }
    }
    var currentWorfor:GrandCollectnWork?{
        didSet{
            parentFiltersCollectionView.reloadData()
        }
    }
    var selectedOverlay:String?
    
    var colorFilterArr:[ColorFilterEnum] = [ColorFilterEnum]()
    var filmFilterArr:[FilmFilterEnum] = [FilmFilterEnum]()
    var videoMirrorArr:[MirrorEnum] = [MirrorEnum]()
    var artEffectArr:[ArtFilterEnum] = [ArtFilterEnum]()
    var dataArr = [Any]()
    
//MARK: ------- Declare Views
    private let contentView: UIView = {
        let view = UIView()
        view.isHidden = false
        view.backgroundColor = .white
//        view.layer.cornerRadius = 12
        return view
    }()
    let vStack : UIStackView = { // Add Vertical Stack
        let stack = UIStackView()
        stack.frame = UIScreen.main.bounds
        stack.axis  = .vertical
        stack.distribution  = .fill
        stack.alignment = .center
        stack.spacing   = 20
        return stack
        
    }()
    private let parentFiltersCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectnView = UICollectionView(frame: CGRect.zero,collectionViewLayout: layout)
        collectnView.backgroundColor = .white
        layout.scrollDirection = .horizontal
        return collectnView
    }()
    private let filterSlider:UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        slider.isHidden = true
        return slider
    }()
    //MARK: ------- View initialiser
    public init() {
        super.init(frame: .zero)
        self.setupView()
        self.layout()
        self.loadAllArrays()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        parentFiltersCollectionView.delegate = self
        parentFiltersCollectionView.dataSource = self
        parentFiltersCollectionView.register(ParentFiltersCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        filterSlider.addTarget(self, action: #selector( onSliderValChanged(slider:event:)), for: .allTouchEvents)
        
    }
    //MARK: ------- UiViewLayous Concetraints
    private func layout() {
        addSubview(contentView)
        contentView.addSubview(vStack)
        vStack.addArrangedSubview(filterSlider)
        vStack.addArrangedSubview(parentFiltersCollectionView)
        
        
        contentView.layout {
            $0.leading.equal(to: self.leadingAnchor, offsetBy: 0)
            $0.trailing.equal(to: self.trailingAnchor, offsetBy: 0)
            $0.top.equal(to: self.topAnchor, offsetBy: 0)
            $0.bottom.equal(to: self.bottomAnchor, offsetBy: 0)
        }
        
        vStack.layout{
            $0.leading.equal(to: contentView.leadingAnchor,offsetBy: 10)
            $0.trailing.equal(to: contentView.trailingAnchor,offsetBy: -10)
            $0.top.equal(to:contentView.topAnchor, offsetBy: 0)
            $0.bottom.equal(to: contentView.bottomAnchor, offsetBy: 0)
        }
        
        filterSlider.layout {
            $0.leading.equal(to: vStack.leadingAnchor)
            $0.trailing.equal(to: vStack.trailingAnchor)
            $0.top.equal(to: vStack.topAnchor, offsetBy: 5)
            $0.height.equal(to: 20)
        }
        
        parentFiltersCollectionView.layout{
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: 0)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: 0)
            $0.top.equal(to: filterSlider.bottomAnchor, offsetBy: 0)
            $0.bottom.equal(to: vStack.bottomAnchor, offsetBy: 0)
        }
    }
    //MARK: ------- Fill Data intoArrays
    private func loadAllArrays(){
        videoMirrorArr.append(contentsOf: MirrorEnum.allCases)
        artEffectArr.append(contentsOf: ArtFilterEnum.allCases)
        colorFilterArr.append(contentsOf: ColorFilterEnum.allCases)
        filmFilterArr.append(contentsOf: FilmFilterEnum.allCases)
    }
}
//MARK: ------- view Class methods
    extension HomeBottomBarView{
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) { // Slider Controller Action
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
}
//MARK: ---- Collection view DataSources

extension  HomeBottomBarView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
//        switch currentWorfor{
//        case .filter:
//            return effectArr.count
//        case .overlay:
//            return Constants.overlyTypesArr.count
//        default:
//            return 0
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = parentFiltersCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ParentFiltersCollectionViewCell
        cell.imageView.layer.borderWidth = 0
        cell.tag = indexPath.row
        switch currentWorfor{
        case .filter:
            
            let data = dataArr[indexPath.row] as! VideoEffect
            let text = data.rawValue
//            let text = effectArr[indexPath.row].rawValue
            cell.nameLbl.text = text
            if indexPath.row == 0{
                cell.imageView.image = thumImage ?? UIImage(named: "filterImage")
            }else{
                cell.imageView.image = UIImage(named: text)
            }
            cell.childCollectnThumImage = thumImage ?? UIImage(named: "filterImage")
            cell.childFiltersCollectionView.tag = indexPath.row
            switch selectedEffect{
            case .Colors:
                cell.baseFilterEffect = .Colors
                cell.loadFilterArr(colorFilterArr)
            case .Art:
                cell.baseFilterEffect = .Art
                cell.loadFilterArr(artEffectArr)
            case .Mirror:
                cell.baseFilterEffect = .Mirror
                cell.loadFilterArr(videoMirrorArr)
            case.Film:
                cell.baseFilterEffect = .Film
                cell.loadFilterArr(filmFilterArr)
           
            default:
                cell.loadFilterArr([Any]())
            }
            
        case .overlay:
            let data = dataArr[indexPath.row] as! String
            let text = data
            cell.nameLbl.text = text//Constants.overlyTypesArr[indexPath.row]
            cell.imageView.image = UIImage(named: text)//Constants.overlyTypesArr[indexPath.row])
        case .text:
            if textSubOption == .font{
//                didSelectForFont(indexPath: indexPath)
                let text = dataArr[indexPath.row] as! String
                cell.imageView.isHidden = true;cell.nameLbl.isHidden = true
                cell.fontLabel.isHidden = false
                cell.fontLabel.text = text
                let font = UIFont(name: text, size: 20)
                cell.fontLabel.font = font
                
                
            }else{
//                didselectForColor(indexPath: indexPath)
                cell.imageView.image = nil
                cell.nameLbl.isHidden = true
                let color = dataArr[indexPath.row] as! UIColor
                cell.imageView.backgroundColor = color
                if cell.imageView.backgroundColor == .clear{
                    cell.imageView.image = UI_Images.transBoxes
                }
                let uiColor = dataArr.reversed()[indexPath.row] as! UIColor
                //            let uicolor = newArr[indexPath.row] as! UIColor
                cell.imageView.layer.borderColor = uiColor.cgColor
                cell.imageView.layer.borderWidth = 2
            }
        default:
            break
        }
        if indexPath.row == selectedIndex{
            cell.imageView.layer.borderColor = UIColor.red.cgColor
            cell.imageView.layer.borderWidth = 2
        }
        
        return cell
    }
}
   
//MARK: ---- Collection view cell Delegate DidselectItem

extension HomeBottomBarView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        switch currentWorfor {
        case .filter:
            didselectForNormal(indexPath: indexPath)
        case .overlay:
            didselectForOverLay(indexPath: indexPath)
        case .text:
            if textSubOption == .font{
                didSelectForFont(indexPath: indexPath)
            }else{
                didselectForColor(indexPath: indexPath)
            }
        default:
            break
        }
    }
    // DidSelect For Normal
    func didselectForNormal(indexPath:IndexPath){
        let cell = parentFiltersCollectionView.cellForItem(at: indexPath) as! ParentFiltersCollectionViewCell
        let effect = dataArr[indexPath.row] as! VideoEffect
        self.selectedEffect = effect
        
        filterSlider.value = 50
        cell.baseFilterEffect = effect
            switch selectedEffect {
            case .Colors:
                cell.baseFilterEffect = .Colors
                cell.loadFilterArr(colorFilterArr)
            case .Mirror:
                cell.baseFilterEffect = .Mirror
                cell.loadFilterArr(videoMirrorArr)
            case .Art:
                cell.baseFilterEffect = .Art
                cell.loadFilterArr(artEffectArr)
            case .Film:
                cell.baseFilterEffect = .Film
                cell.loadFilterArr(filmFilterArr)
            default:
                cell.loadFilterArr([Any]())
            }
        
        toggleExpend()
        print ("selected index is",indexPath.row)
        UIView.animate(withDuration: 0.3) {
            self.parentFiltersCollectionView.performBatchUpdates({}) { _ in
                self.parentFiltersCollectionView.layoutIfNeeded()
                self.parentFiltersCollectionView.reloadData()
            }
        }
    }
    // DidSelect For Overlay
    func didselectForOverLay(indexPath:IndexPath){
        delegateCoposition.didSelectItem(selectedType: nil, workFor: currentWorfor!)
        let selectOverLay = dataArr[indexPath.row] as! String
//        let selectOverLay = Constants.overlyTypesArr[indexPath.row]
        selectedOverlay = selectOverLay
        if let ovrUiImage = UIImage(named: selectOverLay){
         let overMt = MTIImage(image: ovrUiImage)
            FilterImage.shared.isApplyFilter = true
            FilterImage.shared.blendOverImage = overMt
        }else{print(#function,"Overlay UIimage not found")}
        self.parentFiltersCollectionView.reloadData()
    }
    // DidSelect For Colors
    func didselectForColor(indexPath:IndexPath){
        let selected = dataArr[indexPath.row] as! UIColor
        print("selected Color is ",selected)
        
        textPropDelegate?.didSelectColor?(selectedColor: selected)
    }
    
    func didSelectForFont(indexPath:IndexPath){
        if let cell = parentFiltersCollectionView.cellForItem(at: indexPath) as? ParentFiltersCollectionViewCell {
            cell.fontLabel.layer.borderColor = Constants.colorArr.randomElement()?.cgColor
            cell.fontLabel.layer.borderWidth = 2
        }
        let text = dataArr[indexPath.row] as! String
        let font = UIFont(name: text, size: 25)
        
        textPropDelegate?.didselectFont?(selectedFont: font ?? UIFont.boldSystemFont(ofSize: 25))
    }
}
//MARK: ---- Collection view cell DelegateFlowLayout
extension HomeBottomBarView: UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ParentFiltersCollectionViewCell{
            cell.imageView.layer.borderColor = UIColor.green.cgColor
            cell.imageView.layer.borderWidth = 2
        }
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ParentFiltersCollectionViewCell {
            cell.imageView.layer.borderColor = nil
            cell.imageView.layer.borderWidth = 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ParentFiltersCollectionViewCell {
            cell.fontLabel.layer.borderColor = nil
            cell.fontLabel.layer.borderWidth = 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == selectedIndex && currentWorfor == .filter{
            return togglecellSize()
        }
        else{
            let width = ParentFiltersCollectionViewCell.collapsedSize.width
            return CGSize(width: width, height: parentFiltersCollectionView.frame.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func toggleExpend(){
        if cellExpended {cellExpended = false}
        else{cellExpended = true}
    }
    //-- Return cell Size for Expanding cell get from Parent cell class
    func togglecellSize() -> CGSize{
        let hgt = parentFiltersCollectionView.frame.height
        if cellExpended {
            let wid = ParentFiltersCollectionViewCell.collapsedSize.width
            return CGSize(width: wid, height:hgt )//ParentFiltersCollectionViewCell.collapsedSize
        }
        else{
            let wid = ParentFiltersCollectionViewCell.expapsedSize.width
            return CGSize(width: wid, height:hgt )
        }
    }
}




