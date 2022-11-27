//
//  FiltersCollectionViewCell.swift
//  AsafVideoIMG
//
//  Created by Mobile on 18/08/22.
//

import UIKit
import MetalPetal

class ParentFiltersCollectionViewCell: UICollectionViewCell {
    
    var selectedIndex = -1
    var childFilterArr = [Any]()
    
    private var cellId = "FiltersCollectionViewCell"
//MARK: - For Control Cell Height Width
    static var collapsHeight:CGFloat = 100
    static var expandHeight:CGFloat = 100
    
    static var width:CGFloat = 100
    static var expapsedSize = CGSize(width: width, height: expandHeight)
    static var collapsedSize = CGSize(width: 100, height: collapsHeight)
    // -=--=-=-=-=-==-=-=--
    
    public var childCollectnThumImage:UIImage? // Nested Collecttion cell Image
    var baseFilterEffect:VideoEffect?
    var selctedFilter:Any!{
        didSet {
                if let fltr = selctedFilter{
                    
                    switch baseFilterEffect {
                    case .Colors:
                        let mode = fltr as! ColorFilterEnum
                        if let img = UIImage(named: mode.rawValue){
                         GlobalStruct.ColorLookUp = img
                              }
                        FilterImage.shared.selectedColorFilter = mode
                    case .Mirror:
                        let mode = fltr as! MirrorEnum
                        FilterImage.shared.selectedMirrorFilter = mode
                    case .Art:
                        let mode = fltr as! ArtFilterEnum
                        print(mode.rawValue)
                        FilterImage.shared.selectedArtFilter = mode
                    case .Film:
                        let mode = fltr as! FilmFilterEnum
                        if let img = UIImage(named: mode.rawValue){
                         GlobalStruct.ColorLookUp = img
                              }
                        FilterImage.shared.selectedFilmFilter = mode
                 default:
                        break
                    }
            }
        }
    }
    
//MARK: ---- Diclare all UiViews
    //-- Cell CollectionView
    let childFiltersCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectnView = UICollectionView(frame: CGRect.zero,
                                            collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectnView.isScrollEnabled = false
        return collectnView
    }()
    //-- Cell Imageviw
    let imageView:UIImageView = {
        let imgVw = UIImageView()
        imgVw.contentMode = .scaleAspectFill
        imgVw.clipsToBounds = true
        return imgVw
    }()
    
    let fontLabel:UILabel = {
        let lbl = UILabel()
        lbl.isHidden = true
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.backgroundColor = .lightGray
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    
    //-- Cell Label
    let nameLbl:UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.backgroundColor = .lightGray
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        
        return lbl
    }()
    
//MARK: ----  Cell Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        childFiltersCollectionView.delegate = self
        childFiltersCollectionView.dataSource = self
        childFiltersCollectionView.register(ChildFiltersCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        ParentFiltersCollectionViewCell.width = childFiltersCollectionView.collectionViewLayout.collectionViewContentSize.width + 100
        ParentFiltersCollectionViewCell.collapsHeight = self.frame.height
        ParentFiltersCollectionViewCell.expandHeight = self.frame.height
        self.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    //MARK: - Add Subviews
    func addViews(){
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.backgroundColor = .white
//        addSubview(imageView)
//        addSubview(childFiltersCollectionView)
        addSubviews(imageView,childFiltersCollectionView)
        addSubviews(fontLabel)
        imageView.addSubview(nameLbl)
        imageView.image = UIImage(named: "filterImage")
        
        imageView.layout{
            $0.leading.equal(to: self.leadingAnchor,offsetBy: 2)
            $0.width.equal(to: 95)
            $0.height.equal(to: self.heightAnchor,multiplier: 0.8)
            $0.centerY.equal(to: self.centerYAnchor)
        }
        fontLabel.layout{
            $0.leading.equal(to: self.leadingAnchor,offsetBy: 2)
            $0.width.equal(to: 95)
            $0.height.equal(to: self.heightAnchor,multiplier: 0.8)
            $0.centerY.equal(to: self.centerYAnchor)
        }
      
        nameLbl.layout{
            $0.centerX.equal(to: self.centerXAnchor,multiplier: 1)
            $0.centerY.equal(to: self.centerYAnchor,multiplier: 1.4)
            $0.width.lessThanOrEqual(to: imageView.widthAnchor)
        }
        childFiltersCollectionView.layout{
            $0.leading.equal(to: imageView.trailingAnchor,offsetBy: 2)
            $0.trailing.equal(to: self.trailingAnchor,offsetBy: 0)
            $0.top.equal(to: imageView.topAnchor, offsetBy: 5)
            $0.bottom.equal(to: self.bottomAnchor, offsetBy: 2)
            
        }
        
    }
    
//MARK: - Update ChildFilterArray From ParentCollectionView Class and change cell size
    func loadFilterArr(_ arr:[Any]){
        childFilterArr = [Any]()
        childFilterArr = arr
        self.childFiltersCollectionView.reloadData()
        let contentWidth = childFiltersCollectionView.collectionViewLayout.collectionViewContentSize.width + 100
        ParentFiltersCollectionViewCell.expapsedSize = CGSize(width: contentWidth, height: self.frame.height)//--  change cell size
        self.childFiltersCollectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

 //MARK: ------ CollectionView DataSource Methods
extension ParentFiltersCollectionViewCell:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        childFilterArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = childFiltersCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChildFiltersCollectionViewCell
        switch baseFilterEffect {
        case .Colors:
            let effectName = childFilterArr[indexPath.row] as! ColorFilterEnum
            cell.nameLbl.text = effectName.rawValue
        case .Mirror:
            let effectName = childFilterArr[indexPath.row] as! MirrorEnum
            cell.nameLbl.text = effectName.rawValue
        case .Art:
            let effectName = childFilterArr[indexPath.row] as! ArtFilterEnum
            cell.nameLbl.text = effectName.rawValue
        case .Film:
            let effectName = childFilterArr[indexPath.row] as! FilmFilterEnum//String
            cell.nameLbl.text = effectName.rawValue
        default:
            cell.nameLbl.text = childFilterArr[indexPath.row] as? String
        }
        cell.imageView.image = childCollectnThumImage ?? UIImage(named: "filterImage")
        if indexPath.row == selectedIndex{
            cell.imageView.layer.borderColor = UIColor.blue.cgColor
            cell.imageView.layer.borderWidth = 2
        }
        else{
            cell.imageView.layer.borderWidth = 0
        }
        return cell
    }
   
}
//MARK: ------ CollectionView Delegate Methods
extension ParentFiltersCollectionViewCell:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        selctedFilter = childFilterArr[indexPath.row]
        selectedIndex = indexPath.row
        childFiltersCollectionView.reloadData()
    }
}
//MARK: ------ CollectionView Layout Methods
extension ParentFiltersCollectionViewCell:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: childFiltersCollectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ParentFiltersCollectionViewCell {
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
    
    
}
