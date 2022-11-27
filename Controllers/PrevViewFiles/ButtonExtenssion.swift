//
//  ButtonExtenssion.swift
//  AsafVideoIMG
//
//  Created by Mobile on 06/10/22.
//

import UIKit
import ProgressHUD
//MARK: -  ✅❌Extension for Bottom Buttons Delegates
extension PreViewVc:CommonButtonDelegale, StickerCollectButtonDelegale,ControlButtonsDelegale{
    
    func btnClickedFromStickers(sender: UIButton) {
        stickerCollectionView.fadeOut()
    }
    func controlButtonsAction(sender: UIButton) {
        let tag = sender.tag
        print(tag)
        switch sender.currentImage {
        case ButtonImages.add:
            if currentWorkingOn == .text{
                opaqueView.fadeIn(with: 0.7)
                textView.becomeFirstResponder()
                bottomButtonsWorkFor(.text)
                
            }else{
                stickerCollectionView.fadeIn()
                bottomButtonsWorkFor(.stickers)
            }
        case ButtonImages.delete:
            let mainView = containerView.viewWithTag(selectedBoxTag)
            if let imgView = mainView as? UIImageView{
                subViewsArray.removeValue(forKey: selectedBoxTag)
                imgView.removeView()
            }
            if let view = mainView as? UITextView{
                subViewsArray.removeValue(forKey: selectedBoxTag)
                textArray.removeValue(forKey: view.tag)
                view.removeView()
                resizeable?.removeLayer()
               
                 }
           print("selectedtextBoxTag is \(selectedBoxTag)")
        case ButtonImages.remove:
            controlsView.fadeOut()
            hideAllViewExcept(grandCollectnView)
            print("remove btn tab")
            
        case ButtonImages.undo:
            BaseView.undoManager?.undo()
            //            sender.isEnabled = textView.undoManager?.canUndo ?? false
            print("undo btn tab")
        case ButtonImages.redo:
            //            sender.isEnabled = textView.undoManager?.canRedo ?? false
            BaseView.undoManager?.redo()
            print("redo btn tab")
        default:
            break
        }
    }
    
    func commonButtonsAction(sender: UIButton) {
        print("selected index is",sender.tag)
        if sender.tag ==  0 {
            rightBtnaction()
        }
        else{
            crossBtnAction()
        }
//        btnView.btnImages(ButtonImages.multiply!, ButtonImages.share!)
    }
    func hideAllViewExcept(_ selectedViews:UIView...){
        textOptionsView.isHidden = true
        filtersView.isHidden = true
        grandCollectnView.isHidden = true
        blendView.isHidden = true
        focusFiltesView.isHidden = true
        colorPickerView.isHidden = true
        controlsView.isHidden = true
        fontPickerView.isHidden = true
        filterSlider.isHidden = true
        brightSlider.isHidden = true
        slidersVStack.isHidden = true
        selectedViews.forEach { $0.isHidden = false;$0.fadeIn()}
    }
    func btnClickForStickerCollec(sender: UIButton) {
        print ("Btn ClickForm Collection View")
    }
    //MARK: ---✅ Btn Acion
    func rightBtnaction(){
        switch LocalStore.instance.CommonBtnStatus {
        case .filters,.focus,.overlay:
            hideAllViewExcept(grandCollectnView)
            FilterImage.shared.isApplyFilter = true
            filtersView.filterSliderIsHidden = true
            bottomButtonsWorkFor(.export)
        case .stickers,.text:
            hideAllViewExcept(grandCollectnView)
            FilterImage.shared.isApplyFilter = true
            removeEditingLayer()
            loadObjectArray()
            print(imageLayerDataArr)
            bottomButtonsWorkFor(.export)
            
        case .textOptions:
            hideAllViewExcept(grandCollectnView)
            bottomButtonsWorkFor(.export)
            
        case .colorPicker,.fontPicker,.textAlingnment:
            hideAllViewExcept(textOptionsView,controlsView)
            bottomButtonsWorkFor(.textOptions)
        
//        case .fontPicker:
//            hideAllViewExcept(textOptionsView,controlsView)
            //            print(imgLayerArr[0]!)
//        case .text:
//            hideAllViewExcept(grandCollectnView)
            
        case .export:
//            let _: [()] = self.containerView.subviews.compactMap { $0.removeFromSuperview()}
            let _: [()] = self.containerView.subviews.compactMap { $0.isHidden = true}
            self.stickerMaker?.addStickersLayerOnVideo(self.imageLayerDataArr)
            self.exportVideo()
//        default:()
//            break
        }
        LocalStore.instance.CommonBtnStatus = .export
    }
    //MARK: ❌ Btn Acion
    func crossBtnAction(){
        switch LocalStore.instance.CommonBtnStatus {
        case .filters,.focus,.overlay:
            hideAllViewExcept(grandCollectnView)
            FilterImage.shared.isApplyFilter = false
            filtersView.filterSliderIsHidden = true
            bottomButtonsWorkFor(.export)
        case .stickers,.text:
            hideAllViewExcept(grandCollectnView)
            stickerMaker?.clearStickerContainter(view: containerView, viewArray: &subViewsArray, layerArr: &imageLayerDataArr)
            bottomButtonsWorkFor(.export)
        case .colorPicker:
            hideAllViewExcept(textOptionsView,controlsView)
            guard let vW = selectedTextView() else {return}
            vW.backgroundColor = .clear;vW.textColor = .black;vW.textAlignment = .center;
        case .fontPicker:
            guard let vW = selectedTextView() else {return}
            vW.font = UIFont.systemFont(ofSize: 15)
            hideAllViewExcept(textOptionsView,controlsView)
        case .export:
            hideAllViewExcept(grandCollectnView)
            FilterImage.shared.exportSession?.cancel()
            
            FilterImage.shared.multiLayerFilter.layers.removeAll()
//            let _: [()] = self.containerView.subviews.compactMap { $0.removeFromSuperview()}
            stickerMaker?.clearStickerContainter(view: containerView, viewArray: &self.subViewsArray, layerArr: &self.imageLayerDataArr)
//            MyPlayer.share.player?.play()
//            MyPlayer.share.player?.currentItem?.videoComposition = self.VideoCompositon?.makeAVVideoComposition()
            
            print("export cancel method caling")
        default:()
//            break
        }
        LocalStore.instance.CommonBtnStatus = .export
        
    }
    //MARK: 🚀🚀Export Video
    func exportVideo(){
        FilterImage.shared.export(self.videoAsset,self.VideoCompositon) { result  in
            switch result {
            case .success(let outputURL):
                self.tempOutputUrl = outputURL
                let url = outputURL as AnyObject
//                self.exportFile(outputImg: url )
                self.exportFile(outputImg: url) { present in
                    if present{
                        FilterImage.shared.multiLayerFilter.layers.removeAll()
                        let _: [()] = self.containerView.subviews.compactMap { $0.isHidden = false}
                        MyPlayer.share.player?.play()
                        MyPlayer.share.player?.currentItem?.videoComposition = self.VideoCompositon?.makeAVVideoComposition()
                       
                    }else{
                        FilterImage.shared.multiLayerFilter.layers.removeAll()
                        let _: [()] = self.containerView.subviews.compactMap { $0.isHidden = false}
                       try? FileManager.default.removeItem(at: self.tempOutputUrl!)
//                        let fileManager = FileManager()
//                        try? fileManager.removeItem(at: self.tempOutputUrl!)
                    }
//
                }
               
               
            case .failure(let error):
                print(error)
                FilterImage.shared.multiLayerFilter.layers.removeAll()
                let _: [()] = self.containerView.subviews.compactMap { $0.isHidden = false}
                ProgressHUD.showFailed("\(error)")
            }
        }
    }
    
   
 
//MARK: - Remove TapGuesture and Editing layer From All View
   @objc func removeEditingLayer(){
        if tapGuesture != nil{
            let _: [()] = containerView.subviews.compactMap{
                $0.layer.borderWidth = 0
                $0.layer.borderColor = UIColor.clear.cgColor
//                hideAllViewExcept(grandCollectnView)
                resizeable?.removeLayer()
                guseture = nil
                resizeable = nil
            }
        }
    }
    func bottomButtonsWorkFor(_ workFor:CommonBtnsWorking){
        LocalStore.instance.CommonBtnStatus = workFor
        if workFor == .export{
            btnView.btnImages(ButtonImages.multiply!, ButtonImages.share!)
        }else{
            btnView.btnImages(ButtonImages.multiply!, ButtonImages.checkMark!)
        }
        
    }
}
