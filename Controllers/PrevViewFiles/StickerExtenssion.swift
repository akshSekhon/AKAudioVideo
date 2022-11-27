//
//  StickerExtenssion.swift
//  AsafVideoIMG
//
//  Created by Mobile on 06/10/22.
//

import UIKit
//MARK: - Didselect Sticker🙀🐰🧒
extension PreViewVc:StickerCollectionDelegate{
    func didSelectItem(indexPath: IndexPath, image: UIImage) {
        print(indexPath.row)
        FilterImage.shared.isApplyFilter = true
        stickerCollectionView.fadeOut()
        removeEditingLayer()
        addImageView(img: image)
        controlsView.fadeIn()
        controlsView.bringSubviewToFront(self.view)
    }
    
    func addImageView(img:UIImage){
       
        if self.BaseView.subviews.contains(containerView){
           print("Container View AlreadyAdded")
        }else
        {
            self.BaseView.addSubview(containerView)
            containerView.frame = BaseView.bounds
        }
//        stickerImgView.fadeIn()
        if self.BaseView.subviews.contains(containerView){
           print("Container View AlreadyAdded")
            subviewTag += 1
            selectedBoxTag = subviewTag
            
            addImageSubView(withImg: img, onView: containerView, wihTag: subviewTag)
        }
    }
    
    func addImageSubView(withImg:UIImage,onView:UIView,wihTag:Int){
        
        
        let imageView = UIImageView(frame: CGRect(origin: onView.center, size: CGSize(width: 100, height: 100)))
            imageView.tag = wihTag
            subViewsArray.updateValue(imageView, forKey: imageView.tag)
            imageView.image = withImg
        resizeable = ResizableTxtView(view: imageView)
//        guseture = SnapGesture(view: imageView)
            addtapGuesture(vw: imageView)
        onView.addSubview(imageView)
        imageView.bringSubviewToFront(onView)
    }
    
    //MARK: -  Save data in imgLayerArray from imgViewArr
    func loadObjectArray(){
        subViewsArray.forEach { data in
            stickerMaker?.addSickersOnContainer(innerView: data.value, outerView: BaseView, imgLyrArr: &imageLayerDataArr)
        }
    }
    
    //MARK: -  Add tapGuesture And LogTAp Guusture on Views
    func addtapGuesture(vw:UIView){
        tapGuesture = UITapGestureRecognizer(target: self, action: #selector(imgSingleTapGuerstureHandler(_:)))
        longTapGuesture = UILongPressGestureRecognizer(target: self, action: #selector(imglongPressGuerstureHandler(_:)))
        tapGuesture?.numberOfTapsRequired = 1
        tapGuesture?.delegate = self
        longTapGuesture?.delegate = self
        
        longTapGuesture?.numberOfTapsRequired = 0
        longTapGuesture?.minimumPressDuration = 0.5
        vw.addGestureRecognizer(tapGuesture!)
        vw.addGestureRecognizer(longTapGuesture!)
        guard let guestView = tapGuesture?.view else{return}
        guestView.tag = vw.tag
        guestView.isUserInteractionEnabled = true
        
    }
    
    //MARK: - Perform Single Tap Action On Imageview
    @objc func imgSingleTapGuerstureHandler(_ tap:UITapGestureRecognizer){
        //        let tag = tap.view!.tag
        
        if let imgView = tap.view as? UIImageView{
            bottomButtonsWorkFor(.stickers)
            selectedBoxTag = imgView.tag
            if guseture == nil || resizeable == nil {
                guseture = SnapGesture(view: UIView())
                resizeable = ResizableTxtView(view: UIView())
            }
            stickerMaker?.addEditingLayer(of: containerView, with: imgView.tag, moveingGuesture: &guseture!, resizeView: &resizeable)
        }
        else{
            if let textVw = tap.view as? UITextView{
                selectedBoxTag = textVw.tag
                bottomButtonsWorkFor(.text)
                if guseture == nil || resizeable == nil {
                    guseture = SnapGesture(view: UIView())
                    resizeable = ResizableTxtView(view: UIView())
                }
                stickerMaker?.addEditingLayer(of: containerView, with: textVw.tag, moveingGuesture: &guseture!, resizeView: &resizeable)
                hideAllViewExcept(textOptionsView,controlsView)
                
           }
        }
    }
    //MARK: - Perform LongPress Action On Imageview
    @objc func imglongPressGuerstureHandler(_ tap:UITapGestureRecognizer){
//        if let vw = containerView.viewWithTag(tap.view!.tag){
//            vw.removeView()
//            subViewsArray.removeValue(forKey: vw.tag)
//        }
            if let imgView = tap.view as? UIImageView{
                        if let vw = containerView.viewWithTag(imgView.tag){
                            vw.removeView()
                            subViewsArray.removeValue(forKey: vw.tag)
                        }
            }
            
        
        if let textVw = tap.view as? UITextView{
            bottomButtonsWorkFor(.text)
            if guseture == nil || resizeable == nil {
                guseture = SnapGesture(view: UIView())
                resizeable = ResizableTxtView(view: UIView())
            }

            stickerMaker?.addEditingLayer(of: containerView, with: textVw.tag, moveingGuesture: &guseture!, resizeView: &resizeable)
//            opaqueView.fadeIn( with: 0.7)
            opaqueView.isHidden = false
            opaqueView.alpha = 0.7
            isAddNewText = false
            selectedBoxTag = textVw.tag
            if let text = textArray[textVw.tag]{
                textView.text = text
                textView.becomeFirstResponder()
            }else{
                textView.text = "nor record fund in arraay "
                textView.becomeFirstResponder()
            }
        }
    }
    
}
