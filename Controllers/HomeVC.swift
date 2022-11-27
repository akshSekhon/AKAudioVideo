//
//  HomeVC.swift
//  Asaf VideoIMG
//
//  Created by Mobile on 17/08/22.
//

import UIKit
import MetalPetal
import PhotosUI
//import ToastAlerts

class HomeVC: UIViewController,CameraRecordData,CommonButtonDelegale {
    func commonButtonsAction(sender: UIButton) {
        print("senderTag is",sender.tag)
        if sender.tag == 0{
            self.flashBtnAction(sender)
        }
        else{
            self.flipCameraBtnAction(sender)
        }
    }
    
    
    //-- Delegates For update Camera image
    func cameraImage(_ image: UIImage) {
        cameraImgVw.image = image
        filtersView.thumImage = image
    }
    
    private var toggleFlashLight:Bool! = false
    
//    let camera = CameraClass()
    var camera:CameraClass?
//MARK: -  Ui Views
    let vStack : UIStackView = { // Add Vertical Stack
        let stack = UIStackView()
        stack.frame = UIScreen.main.bounds
        stack.axis  = .vertical
        stack.distribution  = .fill
        stack.alignment = .center
        stack.spacing   = 0
        return stack
        
    }()
    
    var topView : CommonButtonsView! //-- Buttons View

    let cameraView : UIView = { // add camera
        
        let vW = UIView()
        vW.isHidden = false
        vW.backgroundColor = .green
        vW.clipsToBounds = true
        return vW
        
    }()
    
    let cameraImgVw: UIImageView = { // Show video in this
        let imgVw = UIImageView()
        imgVw.contentMode = .scaleAspectFill
        return imgVw
    }()
    let bottomView:UIView = { ///Bottom View
        let vW = UIView()
        vW.isHidden = false
        vW.backgroundColor = .white
        return vW
    }()

    let cameraImgCaptureBtn: UIButton = { /// Flip Camera Button
        let btn = UIButton()
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
        btn.setImage(UIImage(systemName: "camera.aperture"), for: .normal)
        return btn
    }()
    
    let openGalleryBtn:UIButton = { // Gallery Imageview
        let btn = UIButton()
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
        btn.setImage(UIImage(systemName: "photo.artframe"), for: .normal)
        return btn
    }()
    
    let openFiltersBtn: UIButton = { //  -- Open Filters buttobn
        let btn = UIButton()
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
        btn.setImage(UIImage(systemName: "chevron.down.square"), for: .normal)
        return btn
        
    }()
    
    let videoBtn: UIButton = { //-- open videobtn
        let btn = UIButton()
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .selected)
        btn.setTitle("Video", for: .normal)
        return btn
    }()
    
    let cameraBtn: UIButton = {//-- open camerea Btn
        let btn = UIButton()
        btn.setTitle("Camera", for: .normal)
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .selected)
        return btn
    }()
    
    let animatedView:UIView = { // Camera / Video Btn base View
        let vW = UIView()
        vW.isHidden = false
         return vW
    }()
    
    let Hstack:UIStackView = {// Camera / Video Btn base  stack View
        let stack = UIStackView()
        stack.axis  = .horizontal
        stack.distribution  = .fillEqually
        stack.alignment = .center
        stack.spacing   = 0
        return stack
    }()
    
    let filtersView:HomeBottomBarView = {
       let Vw = HomeBottomBarView()
        Vw.backgroundColor = .red
        return Vw
    }()
    //MARK: -  Controller Methods
    
    var snapGuest:SnapGesture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        camera = CameraClass()
        LocalStore.instance.isSelectedCameraMode = true
        LocalStore.instance.isSelctedVideoMode = false
//        topView = CommonButtonsView(_delegate: self)
        topView = CommonButtonsView()
        topView.delegate = self
        camera?.delegate = self
        addActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        camera?.startRunningCaptureSession()
//       snapGuest = SnapGesture(view: cameraImgVw)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        camera?.stopRunningCaptureSession()

    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        ViewLayouts()
    }
    
    private func addActions(){
        cameraImgCaptureBtn.addTarget(self, action: #selector(cameraImgBtnAction(_:)), for: .touchUpInside)
        openFiltersBtn.addTarget(self, action: #selector(openFiltersBtnAction(_:)), for: .touchUpInside)
        openGalleryBtn.addTarget(self, action: #selector(openGalleryimgAction(_:)), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(imgCaptureModeAction(_:)), for: .touchUpInside)
        videoBtn.addTarget(self, action: #selector(videoCaptureModeBtnAction(_:)), for: .touchUpInside)
    }
    
    private func ViewLayouts(){
        
        self.view.addSubview(vStack)
        vStack.addArrangedSubview(topView)
        vStack.addArrangedSubview(cameraView)
        vStack.addArrangedSubview(bottomView)
        vStack.addArrangedSubview(filtersView)
        cameraView.addSubview(cameraImgVw)
        bottomView.addSubview(cameraImgCaptureBtn)
        bottomView.addSubview(openGalleryBtn)
        bottomView.addSubview(openFiltersBtn)
        bottomView.addSubview(animatedView)
        animatedView.addSubview(Hstack)
        Hstack.addArrangedSubview(cameraBtn)
        Hstack.addArrangedSubview(videoBtn)

        let guide = self.view.safeAreaLayoutGuide
        topView.layout{
            $0.height.equal(to: self.view.heightAnchor,multiplier: 0.1)
            $0.top.equal(to: self.view.topAnchor)
            $0.trailing.equal(to: self.view.trailingAnchor)
            $0.leading.equal(to: self.view.leadingAnchor)
        }
        bottomView.layout{
            $0.height.equal(to: self.view.heightAnchor,multiplier: 0.15)
            $0.trailing.equal(to: self.view.trailingAnchor)
            $0.leading.equal(to: self.view.leadingAnchor)
            $0.bottom.equal(to: filtersView.topAnchor)
        }
        filtersView.layout {
            $0.height.equal(to: self.view.heightAnchor,multiplier: 0.12)
            $0.trailing.equal(to: self.view.trailingAnchor,offsetBy: 10)
            $0.leading.equal(to: self.view.leadingAnchor,offsetBy: -10)
            $0.bottom.equal(to: guide.bottomAnchor,offsetBy: 0)
        }
        cameraView.layout{
            $0.trailing.equal(to: self.view.trailingAnchor)
            $0.leading.equal(to: self.view.leadingAnchor)
            $0.top.equal(to:topView.bottomAnchor)
            $0.bottom.equal(to: bottomView.topAnchor)
        }
        cameraImgVw.layout{
            $0.trailing.equal(to: cameraView.trailingAnchor)
            $0.leading.equal(to: cameraView.leadingAnchor)
            $0.top.equal(to:cameraView.topAnchor)
            $0.bottom.equal(to: cameraView.bottomAnchor)
        }
        cameraImgCaptureBtn.layout{
            $0.width.equal(to: 60)
            $0.height.equal(to: 60)
            $0.centerY.equal(to: bottomView.centerYAnchor,multiplier: 1.2)
            $0.centerX.equal(to: bottomView.centerXAnchor)
        }
        openGalleryBtn.layout{
            $0.width.equal(to: 40)
            $0.height.equal(to: 40)
            $0.centerY.equal(to: bottomView.centerYAnchor,multiplier: 1.2)
            $0.leading.equal(to: self.view.leadingAnchor, offsetBy: 20, priority: .defaultHigh, multiplier: 1)

        }
        openFiltersBtn.layout{
            $0.width.equal(to: 40)
            $0.height.equal(to: 40)
            $0.centerY.equal(to: bottomView.centerYAnchor,multiplier: 1.2)
            $0.trailing.equal(to: self.view.trailingAnchor, offsetBy: -20, priority: .defaultHigh, multiplier: 1)

        }
        animatedView.layout{// video cameraBaseView
            $0.width.equal(to: 150)
            $0.height.equal(to: 40)
            $0.bottom.equal(to: cameraImgCaptureBtn.topAnchor, offsetBy: 0, priority: .defaultHigh, multiplier: 1)
            $0.centerX.equal(to:  cameraImgCaptureBtn.centerXAnchor, offsetBy: 0, priority: .defaultHigh, multiplier: 1.2)
        }
        Hstack.layout{
            $0.bottom.equal(to: animatedView.bottomAnchor)
            $0.top.equal(to: animatedView.topAnchor)
            $0.trailing.equal(to: animatedView.trailingAnchor)
            $0.leading.equal(to: animatedView.leadingAnchor)
        }
        cameraBtn.layout{
            $0.bottom.equal(to: animatedView.bottomAnchor)
            $0.top.equal(to: animatedView.topAnchor)
            $0.leading.equal(to: animatedView.leadingAnchor)
        }
        videoBtn.layout{
            $0.bottom.equal(to: animatedView.bottomAnchor)
            $0.top.equal(to: animatedView.topAnchor)
            $0.trailing.equal(to: animatedView.trailingAnchor)
        }
    }
    
    
//MARK: - Button Actions =-=-=-=-=-=-=-=-=
    
    @objc func flashBtnAction(_ sender: UIButton){
        toggleFlash()
        print(#function)
    }
   
    @objc func flipCameraBtnAction(_ sender: UIButton){
        toggleFlash()
        camera?.flipCamera()
        print(#function)
    }
    @objc func cameraImgBtnAction(_ sender: UIButton){
        if LocalStore.instance.isSelectedCameraMode!{
            if let img = camera?.snapImage(){
                let uiimg = UIImage(cgImage: img)
                let vc = PreViewVc()
                vc.selectionMediaType = .image
                vc.captureImg = uiimg
                self.navigationController?.pushViewController(vc, animated: true)
        }
        }
        else if LocalStore.instance.isSelctedVideoMode!{
            toggleRecording(sender)
        }
    }
    @objc func openGalleryimgAction(_ sender: UIButton){
//
        print(#function)
        
        GalleryPicker.shared.openImagePicker { url, mediaType in
                let vc = PreViewVc()
                vc.selectionMediaType = mediaType
                vc.selectedUrl = url
               self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    }
    
    @objc func openFiltersBtnAction(_ sender: UIButton){
        if filtersView.isHidden{
            filtersView.isHidden = false
            sender.setImage(UIImage(systemName: "chevron.up.square"), for: .normal)
        }
        else{
            filtersView.isHidden = true
            sender.setImage(UIImage(systemName: "chevron.down.square"), for: .normal)
        }
        print(#function)
        
    }
    @objc func imgCaptureModeAction(_ sender: UIButton){
        handelImgCameraAnimation()
        
    }
    @objc func videoCaptureModeBtnAction(_ sender: UIButton){
        handelVideoAnimation()
    }
   
}


extension HomeVC{
    
    func toggleRecording(_ sender: UIButton){
        if !(camera?.state.isRecording)!{
        do {
            try self.camera?.startRecording()
        } catch {
            print(error)
        }
        }else{
            
            camera?.stopRecording(completion:{ result in
                switch result {
                case .success(let url):
                    print(url)
                    let vc = PreViewVc()
                    vc.selectionMediaType = .video
                    vc.selectedUrl = url
                    self.navigationController?.pushViewController(vc, animated: true)
                case .failure(let error):
                    print(error)
                }
        })
        }
    }
    
    func handelImgCameraAnimation(){ // -- View moveleft While select imageMode
              
        if !LocalStore.instance.isSelectedCameraMode!{
            LocalStore.instance.isSelctedVideoMode = false
            LocalStore.instance.isSelectedCameraMode = true
//        UIView.animate(withDuration: 0.5, delay: 0.20, options: UIView.AnimationOptions(), animations: { () -> Void in
//            self.animatedView.frame = CGRect(x: self.animatedView.frame.minX + self.animatedView.frame.size.width / 2, y: self.animatedView.frame.minY,width:self.animatedView.frame.size.width ,height:self.animatedView.frame.size.height)
//              }, completion: { (finished: Bool) -> Void in
//              })
        
        print(#function)
        }
    }
    func handelVideoAnimation(){  // -- View moveRight While select VideoMode
        if !LocalStore.instance.isSelctedVideoMode! {
            LocalStore.instance.isSelctedVideoMode = true
            LocalStore.instance.isSelectedCameraMode = false
//        UIView.animate(withDuration: 0.5, delay: 0.20, options: UIView.AnimationOptions(), animations: { () -> Void in
//            self.videoBtn.frame = CGRect(x: self.view.frame.minX - self.animatedView.frame.size.width / 2, y: self.animatedView.frame.minY,width:self.animatedView.frame.size.width ,height:self.animatedView.frame.size.height)
//              }, completion: { (finished: Bool) -> Void in
//              })
        print(#function)
        }
    }
    func toggleFlash(){
        if toggleFlashLight{
            toggleFlashLight = false
        }
        else{
            toggleFlashLight = true
        }
    }
}
