//
//  PreViewVc.swift
//  AsafVideoIMG
//
//  Created by Mobile on 17/08/22.
//

import UIKit
import AVFoundation
import MetalPetal
import ProgressHUD
class PreViewVc: UIViewController, UIGestureRecognizerDelegate{
    
    private var avPlayer: MyPlayer?
   
    private var delegate:CommonButtonDelegale?
    public var isNavigationHidden:Bool? = false
    public var captureImg:UIImage?
    public var selectedUrl:URL?
    public var imgUrl:URL?
    public var selectedVideoUrl:URL?
    public var selectionMediaType:MediaType = .video
    var compoStruct = Compositions()
    var videoAsset:AVAsset?
    var VideoCompositon:MTIVideoComposition?
    let renderContext = try! MTIContext(device: MTLCreateSystemDefaultDevice()!)
    var playerItem:AVPlayerItem!
    var guseture:SnapGesture?
    var selectedSticer:UIImage?
    
    var imageLayerDataArr:[Int:ImageObject] = [:]
    var subViewsArray:[Int:UIView] = [:]
    var textArray:[Int:String] = [:]
    var isAddNewText = true
    
    var stickerMaker:StickerMaker?
    var tapGuesture:UITapGestureRecognizer?
    var longTapGuesture:UILongPressGestureRecognizer?
    var currentWorkingOn:GrandCollectnWork?
    var subviewTag = 0
    var selectedBoxTag = 0
    
    var tempOutputUrl:URL?
    
    var selectedTextOption:TextFilterOptions?
    var resizeable:ResizableTxtView?
    
  
//    var selectedView:UIView?
    
    //MARK: - Makeing Views
    
    internal var btnView:CommonButtonsView!
    
    let vStack : UIStackView = { // Add Vertical Stack
        let stack = UIStackView()
        stack.frame = UIScreen.main.bounds
        stack.axis  = .vertical
        stack.distribution  = .fill
        stack.alignment = .center
        return stack
        
    }()
    let blendVStack : UIStackView = { // Add Vertical Stack
        let stack = UIStackView()
        stack.frame = UIScreen.main.bounds
        stack.axis  = .vertical
        stack.distribution  = .fill
        stack.alignment = .center
        return stack
        
    }()
    fileprivate let imgView:UIImageView = {
        let imgVw = UIImageView()
        imgVw.contentMode = .scaleAspectFill
        return imgVw
    }()
    
    internal let BaseView: UIView = {
        let Vw = UIView()
        Vw.clipsToBounds = true
        return Vw
    }()
    
     let filtersView:HomeBottomBarView = { //Filters CollectionView
        let Vw = HomeBottomBarView()
        Vw.isHidden = true
        return Vw
    }()
    
     let grandCollectnView:GrandCollectionView = {
        let Vw = GrandCollectionView()
        return Vw
    }()
    
    let blendFiltersView:HomeBottomBarView = {
        let Vw = HomeBottomBarView()
        return Vw
    }()
    let blendModesView:GrandCollectionView = {
        let Vw = GrandCollectionView()
        return Vw
    }()
    let focusFiltesView:GrandCollectionView = {
        let Vw = GrandCollectionView()
        Vw.isHidden = true
        return Vw
    }()
    
    let blendView:UIView = {
        let vw = UIView()
//        vw.isHidden = true
        return vw
    }()
    
    var stickerCollectionView:StickersCollectionView = {
        let vw = StickersCollectionView()
        vw.isHidden = true
        return vw

    }()
    
    var deletePointView:UIImageView = {
        let vw = UIImageView()
        vw.backgroundColor = .clear
        vw.image = UIImage(systemName: "trash")
        vw.layer.borderColor = UIColor.white.cgColor
        vw.layer.borderWidth = 2
        vw.contentMode = .center
        vw.isHidden = true
        return vw
    }()
    
    let opaqueView:UIImageView = {
        let vw = UIImageView()
        vw.backgroundColor = .black
        vw.alpha = 1
        vw.image = UIImage(named: "Trans")
        vw.contentMode = .scaleAspectFill
        vw.isUserInteractionEnabled = true
//        vw.image = nil
//        vw.layer.opacity = 0.2
        vw.isHidden = true
        return vw
        
    }()
    let textView:UITextView = {
        let vw = UITextView()
        vw.textColor = .white
        vw.font = UIFont.boldSystemFont(ofSize: 25)
        vw.backgroundColor = .black
        vw.isUserInteractionEnabled = true
        return vw
        
    }()
    let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    var controlsView:ControlButtonsView = {
        
        let vw = ControlButtonsView()
        vw.isHidden = true
        vw.backgroundColor = .clear
        return vw
        
    }()
    var textOptionsView:GrandCollectionView = {
        let vw = GrandCollectionView()
        vw.isHidden = true
        return vw
    }()
    var colorPickerView:HomeBottomBarView = {
        let vw = HomeBottomBarView()
        vw.isHidden = true
        return vw
    }()
    var fontPickerView:HomeBottomBarView = {
        let vw = HomeBottomBarView()
        vw.isHidden = true
        return vw
    }()
    
//    var slider: CentralizeSliderView?
    
    let slidersVStack : UIStackView = { // Add Vertical Stack
        let stack = UIStackView()
        stack.axis  = .vertical
        stack.distribution  = .fillEqually
        stack.spacing = 10
        return stack
        
    }()
    
    
    lazy var brightSlider:CentralizeSliderView = {
       let slider = CentralizeSliderView()
       slider.isHidden = true
        slider.amplitude = 200
        slider.deavtiveColor = UIColor.lightGray.withAlphaComponent(0.5)
        slider.thumbImage = UIImage(systemName: "sun.max.circle.fill")
       return slider
   }()
    
    lazy var filterSlider:CentralizeSliderView = {
       let slider = CentralizeSliderView()
       slider.isHidden = true
        slider.thumbImage = UIImage(systemName: "sun.max.fill")
        slider.deavtiveColor = UIColor.lightGray.withAlphaComponent(0.5)
        slider.amplitude = 200
       return slider
   }()
    
    
    func updateSlider(){
        filterSlider.sliderDidChange = { [weak filterSlider] value in
            FilterImage.shared.overlayIntensity = value
            if value > 0 {
                filterSlider?.activeColor = .blue
            } else if value < 0 {
                filterSlider?.activeColor = .red
            }
            else {
                filterSlider?.activeColor = .lightGray
                
            }
            FilterImage.shared.overlayIntensity = value
                print("filter silder value is",value)
        }
        
        brightSlider.sliderDidChange = { [weak brightSlider] value in
            FilterImage.shared.brightness = value
            if value > 0 {
                brightSlider?.activeColor = .blue
            } else if value < 0 {
                brightSlider?.activeColor = .red
            } else {
                brightSlider?.activeColor = .lightGray
            }
            FilterImage.shared.brightness = value
            print("brightness silder value is",value)
        }
        
    }
    
    
//MARK: - ViewCycle
    override func viewDidLoad() { // -- ViewDidload Method
        super.viewDidLoad()
        title = "Editor"
        view.backgroundColor = .white
//        stickerCollectionView = StickersCollectionView()
        captureImg = #imageLiteral(resourceName: "nature")
        imgView.image = #imageLiteral(resourceName: "nature")
        updateSlider()
        loadVideoFromBundle()
        //        URL(fileURLWithPath: path)
        stickerMaker = StickerMaker()
        
        btnView = CommonButtonsView()//_delegate: self)
        btnView.delegate = self
        bottomButtonsWorkFor(.export)
        grandCollectnView.delegate = self
        blendModesView.delegate = self
        blendFiltersView.delegateCoposition = self
        focusFiltesView.delegate = self
        stickerCollectionView.delegate = self
        stickerCollectionView.btnDelegate = self
        controlsView.delegate = self
        textOptionsView.textOptionDelegate = self
        textOptionsView.textPropertyDelegate = self
        colorPickerView.textPropDelegate = self
        fontPickerView.textPropDelegate = self
//        stickerCollectionView.btnDelegate = self
        
        self.ViewLayouts()
        tapGuesture = UITapGestureRecognizer(target: self, action: #selector(removeEditingLayer))
        containerView.addGestureRecognizer(tapGuesture!)
        addToolBar(textView: textView, self,#selector(doneBtnAction(_ :)),#selector(cancelBtnAction(_ :)))
//        addToolBar(textView: textView, self)
        
        DispatchQueue.main.async {
            self.opaqueView.alpha = 0.0
            self.deletePointView.layer.cornerRadius = self.deletePointView.frame.height / 2
        }
//        registerTapOnTxtVw()
        
    }
    
    override func viewWillAppear(_ animated: Bool) { // View WillAppear Metod
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        blendView.isHidden = true
        if selectionMediaType == .image{
            loadImage()
        }
        else if selectionMediaType == .video{
            loadVideo()
        }
        
//        let vc = OverlayImageViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) { // View WillDisAppear Metod
        self.navigationController?.isNavigationBarHidden = true
//        MyPlayer.share.player = nil
        MyPlayer.share.player?.pause()
        selectedVideoUrl = nil
        captureImg = UIImage()
        isNavigationHidden = true
//        MyPlayer.share = nil
//        MyPlayer.share.player = nil
        super.viewWillDisappear(true)
        
    }
    // MARK: - Load video From Bundle File
    func loadVideoFromBundle(){ // Load video From Bundle File
        guard  let path = Bundle.main.path(forResource: "video", ofType: "mp4")else {
            debugPrint("video.m4v not found")
            return
        }
        let url = NSURL(fileURLWithPath: path)
        //                    let player = AVPlayer(url:url as URL)
        selectedUrl = url as URL
    }
    
    // MARK: - If loading Image
    private func loadImage(){// If loading Image
        imgUrl = selectedUrl
        if let url = imgUrl{
            imgView.loadFromUrl(url: url)
            filtersView.thumImage = imgView.image
//            loadImageFrom(url: url)
        }else{
            if let captureImg = captureImg {
                        filtersView.thumImage = captureImg
                    }
        }
//        if let captureImg = captureImg {
//            imgView.loadFromUrl(url: )//captureImg
//            filtersView.thumImage = captureImg
//        }
        imgView.isHidden = false
        MyPlayer.share.player = nil
        selectedVideoUrl = nil
    }
    
    // MARK: - If loading Video
    private func loadVideo(){
        
        selectedVideoUrl = selectedUrl
        imgView.isHidden = true
//        MyPlayer.share = MyPlayer()
        MyPlayer.share.addPlayerToView(BaseView)
        if let url = selectedVideoUrl{
            let asset = AVAsset(url: url)
            videoAsset = asset
            LocalStore.instance.currentAsset = videoAsset
            GalleryPicker.shared.getThumbnailImageFromVideoUrl(url: url) { image in
                self.filtersView.thumImage = image
//                LocalStore.instance.currentAssetThumbImage = image
                LocalStore.instance.currentAssetThumbImage = UIImage(named: "Trans2")
            }
        }else{  print("url Error selectedVideoUrl is =-=-=-==- \(String(describing: selectedVideoUrl)) ")}
        if let asset = videoAsset{
            playerItem = AVPlayerItem(asset: asset)
           
            if let comp = Compositions.DemoFilter(asset: asset, render: renderContext){
                self.VideoCompositon = comp
//                self.playerItem?.videoComposition = comp.makeAVVideoComposition()
                playerItem.videoComposition = self.VideoCompositon?.makeAVVideoComposition()
            }
            MyPlayer.share.playVideoWithAsset(playerItem)
        }
        else{
            print("asset Error videoAsset is ==-=--=-==-= \(String(describing: videoAsset)) ")
        }
    }
}
//MARK: -- View Layouts Concetraints
extension PreViewVc{
    private func ViewLayouts(){
//        self.view.addSubview(vStack)
//        self.view.addSubview(opaqueView)
//        self.view.addSubview(deletePointView)
//        self.view.addSubview(controlsView)
        self.view.addSubviews(vStack,opaqueView,deletePointView,controlsView,slidersVStack)
        
        slidersVStack.addArrangedSubview(filterSlider)
        slidersVStack.addArrangedSubview(brightSlider)
//        opaqueView.layer.addSublayer(textView.layer)
        opaqueView.addSubview(textView)
        vStack.addArrangedSubview(BaseView)
        vStack.addArrangedSubview(grandCollectnView)
        vStack.addArrangedSubview(textOptionsView)
        vStack.addArrangedSubview(colorPickerView)
        vStack.addArrangedSubview(fontPickerView)
        vStack.addArrangedSubview(filtersView)
        vStack.addArrangedSubview(blendView)
        vStack.addArrangedSubview(focusFiltesView)
        vStack.addArrangedSubview(btnView)
       
        blendView.addSubview(blendVStack)
        blendVStack.addArrangedSubview(blendModesView)
        blendVStack.addArrangedSubview(blendFiltersView)
        BaseView.addSubview(imgView)
        
        
        let guide = self.view.safeAreaLayoutGuide
        
        vStack.layout{
            $0.top.equal(to: self.view.topAnchor,offsetBy: 0)
            $0.trailing.equal(to: self.view.trailingAnchor,offsetBy: 0)
            $0.leading.equal(to: self.view.leadingAnchor,offsetBy: 0)
            $0.bottom.equal(to: guide.bottomAnchor,offsetBy: 0)//multiplier: 0.980)//0.993
        }
        btnView.layout{
//            $0.height.equal(to: 20)
            if UIDevice.current.hasNotch{
                $0.height.equal(to: self.view.heightAnchor,multiplier: 0.035)
            }
            else{
                $0.height.equal(to: self.view.heightAnchor,multiplier: 0.055)
            }
            
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: 5)
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: -5)
            $0.bottom.equal(to: vStack.bottomAnchor,multiplier: 1)//multiplier: 0.993)
        }
        filtersView.layout {
//            $0.height.equal(to: 150)
            $0.height.equal(to: self.view.heightAnchor,multiplier: 0.14)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: 10)
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: -10)
            $0.bottom.equal(to: btnView.topAnchor,offsetBy: 0)
        }
        grandCollectnView.layout {
            $0.height.equal(to: vStack.heightAnchor,multiplier: 0.1)
//            $0.height.equal(to: 150)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: 2)
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: -2)
            $0.bottom.equal(to: btnView.topAnchor,offsetBy: 0)
        }
        textOptionsView.layout{
            $0.height.equal(to: vStack.heightAnchor,multiplier: 0.1)
//            $0.height.equal(to: 150)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: 2)
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: -2)
            $0.bottom.equal(to: btnView.topAnchor,offsetBy: 0)
        }
        colorPickerView.layout{
            $0.height.equal(to: vStack.heightAnchor,multiplier: 0.1)
//            $0.height.equal(to: 150)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: 2)
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: -2)
            $0.bottom.equal(to: btnView.topAnchor,offsetBy: 0)
        }
        fontPickerView.layout{
            $0.height.equal(to: vStack.heightAnchor,multiplier: 0.1)
//            $0.height.equal(to: 150)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: 2)
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: -2)
            $0.bottom.equal(to: btnView.topAnchor,offsetBy: 0)
        }
        
        blendView.layout{
//            $0.height.equal(to: self.view.heightAnchor,multiplier: 0.18)
//          $0.height.equal(to: 150)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: 2)
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: -2)
            $0.bottom.equal(to: btnView.topAnchor,offsetBy: 0)
        }
        blendVStack.layout{
            $0.top.equal(to: blendView.topAnchor,offsetBy: 0)
            $0.trailing.equal(to: blendView.trailingAnchor,offsetBy: 0)
            $0.leading.equal(to: blendView.leadingAnchor,offsetBy: 0)
            $0.bottom.equal(to: blendView.bottomAnchor,offsetBy: 0)
        }
        
        blendModesView.layout{
            $0.top.equal(to: blendVStack.topAnchor,offsetBy: 0)
            $0.trailing.equal(to: blendVStack.trailingAnchor,offsetBy: 0)
            $0.leading.equal(to: blendVStack.leadingAnchor,offsetBy: 0)
            $0.height.equal(to: blendView.heightAnchor,multiplier: 0.2)
        }
        blendFiltersView.layout{
            $0.height.equal(to: self.view.heightAnchor,multiplier: 0.14)
//            $0.top.equal(to: blendModesView.bottomAnchor,offsetBy: 2)
            $0.trailing.equal(to: blendVStack.trailingAnchor,offsetBy: 0)
            $0.leading.equal(to: blendVStack.leadingAnchor,offsetBy: 0)
            $0.bottom.equal(to: blendVStack.bottomAnchor,offsetBy: 0)
        }
        focusFiltesView.layout{
            $0.height.equal(to: vStack.heightAnchor,multiplier: 0.09)
//            $0.height.equal(to: 150)
            $0.trailing.equal(to: vStack.trailingAnchor,offsetBy: 2)
            $0.leading.equal(to: vStack.leadingAnchor,offsetBy: -2)
            $0.bottom.equal(to: btnView.topAnchor,offsetBy: 0)
        }
        BaseView.layout{
            $0.top.equal(to: guide.topAnchor,offsetBy: 5)
            $0.leading.equal(to: guide.leadingAnchor,offsetBy: 5)
            $0.trailing.equal(to: guide.trailingAnchor,offsetBy: -5)
//            $0.bottom.equal(to: filtersView.topAnchor,offsetBy: 5)
        }
        
        imgView.layout{
            $0.top.equal(to: BaseView.topAnchor,offsetBy: 0)
            $0.leading.equal(to: BaseView.leadingAnchor,offsetBy: 0)
            $0.trailing.equal(to: BaseView.trailingAnchor,offsetBy: 0)
            $0.bottom.equal(to: BaseView.bottomAnchor,offsetBy: 0)
        }
        self.view.addSubview(stickerCollectionView)
        stickerCollectionView.layout{
            $0.top.equal(to: self.view.topAnchor,offsetBy: 0)
            $0.trailing.equal(to: self.view.trailingAnchor,offsetBy: 0)
            $0.leading.equal(to: self.view.leadingAnchor,offsetBy: 0)
            $0.bottom.equal(to: guide.bottomAnchor,multiplier: 1)
        }
        opaqueView.layout{
            $0.top.equal(to:  self.view.topAnchor,offsetBy: 0)
            $0.trailing.equal(to: self.view.trailingAnchor,offsetBy: 0)
            $0.leading.equal(to: self.view.leadingAnchor,offsetBy: 0)
            $0.bottom.equal(to:  self.view.bottomAnchor,offsetBy: 0)
        }
        textView.layout{
            $0.top.equal(to: BaseView.topAnchor,offsetBy: 0)
            $0.trailing.equal(to:BaseView.trailingAnchor,offsetBy: 0)
            $0.leading.equal(to: BaseView.leadingAnchor,offsetBy: 0)
            $0.bottom.equal(to: BaseView.bottomAnchor,multiplier: 1)
        }
        deletePointView.layout{
            $0.centerX.equal(to: self.view.centerXAnchor)
            $0.top.equal(to: BaseView.bottomAnchor,multiplier: 1)
            $0.height.equal(to: grandCollectnView.heightAnchor,multiplier: 1)
            $0.width.equal(to: deletePointView.heightAnchor,multiplier: 1)
        }
        controlsView.layout{
//            $0.centerX.equal(to: self.view.centerXAnchor)
//            $0.top.equal(to: BaseView.bottomAnchor,multiplier: 1)
            $0.bottom.equal(to:  BaseView.bottomAnchor,offsetBy: -10)
            $0.height.equal(to: 50)
//            $0.height.equal(to: self.view.heightAnchor,multiplier: 0.06)
            $0.trailing.equal(to: BaseView.trailingAnchor,offsetBy: 0)
            $0.leading.equal(to: BaseView.leadingAnchor,offsetBy: 0)
        }
        
        slidersVStack.layout{
//            $0.centerX.equal(to: self.view.centerXAnchor)
//            $0.top.equal(to: BaseView.bottomAnchor,multiplier: 1)
            $0.bottom.equal(to:  BaseView.bottomAnchor,offsetBy: -10)
            $0.height.equal(to: 50)
//            $0.height.equal(to: self.view.heightAnchor,multiplier: 0.06)
            $0.trailing.equal(to: BaseView.trailingAnchor,offsetBy: 0)
            $0.leading.equal(to: BaseView.leadingAnchor,offsetBy: 0)
        }
        
//        textView.frame = BaseView.bounds
        opaqueView.bringSubviewToFront(self.view)
        BaseView.bringSubviewToFront(self.view)
        stickerCollectionView.bringSubviewToFront(self.view)
        deletePointView.bringSubviewToFront(self.view)
        controlsView.bringSubviewToFront(self.view)
        
        
    }
}


extension PreViewVc{
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("touch begain")
            case .moved:
                print("touch move")
                
                FilterImage.shared.overlayIntensity = slider.value
                
                Compositions.sliderValue = slider.value
            case .ended:
                print("touch ended")
            default:
                break
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let lenth = Int(textView.frame.width - 100)
        if range.length == lenth{
            
            
            return false
        }else{
            return true
        }
    }
    //MARK: - Perform LongPress Action On Imageview
  
    
}
