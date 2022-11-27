//
//  GranndCollecDelegatesExtenssion.swift
//  AsafVideoIMG
//
//  Created by Mobile on 06/10/22.
//

import UIKit
import MetalPetal
//MARK: -  GrandCollection ViewDelegate Methods
extension PreViewVc:GrandCollectionDelegate{
    func didSelectItem(selectedType: GrandCollectnWork?, workFor: GrandCollectnWork) {
        switch workFor {
        case .filter:
            if let selected = selectedType{
                currentWorkingOn = selected
                grandForNormal(selected)
                bottomButtonsWorkFor(.filters)
//                btnView.btnImages(ButtonImages.multiply!, ButtonImages.checkMark!)
            }
           
        case .overlay:
            blendModesView.isHidden = false
            bottomButtonsWorkFor(.overlay)
//            btnView.btnImages(ButtonImages.multiply!, ButtonImages.checkMark!)
//            print("working from main class",indexPath.row)
        default:
            break
        }
    }
    
//    func didSelectItem(indexPath: IndexPath, workFor: GrandCollectnWork) {
//        print(indexPath.row)
//
//
//    }
 // -- While collection view use for category selection like(filters,stickers overlays Etc)
    func grandForNormal(_ selectedType:GrandCollectnWork){
       
        switch selectedType {
        case .filter:// -=-==-=-=-=----=---=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=--  For Filters
            hideAllViewExcept(filtersView)
            filtersView.currentWorfor = .filter
            filtersView.dataArr.append(contentsOf: VideoEffect.allCases)
            FilterImage.shared.currentWorkFor = .filter
            grandCollectnView.currentWorkFor = .filter
            LocalStore.instance.CommonBtnStatus = .filters
        case .overlay:// -=-==-=-=-=----=---=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=--  For overlay
            blendModesView.isHidden = true
            FilterImage.shared.currentWorkFor = .overlay
            blendFiltersView.currentWorfor = .overlay
            blendFiltersView.dataArr.append(contentsOf: Constants.overlyTypesArr)
            blendModesView.currentWorkFor = .overlay
            LocalStore.instance.CommonBtnStatus = .overlay
            blendModesView.dataArray = MTIBlendModes.all//blendModeArr
//            blendModesView.filterSlider.isHidden = false
            hideAllViewExcept(blendView,slidersVStack,filterSlider)
        case .focus:// -=-==-=-=-=----=---=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=--  For Focus
            focusFiltesView.currentWorkFor = .focus
            FilterImage.shared.currentWorkFor = .focus
            LocalStore.instance.CommonBtnStatus = .focus
//            focusFiltesView.filterSlider.isHidden = false
            hideAllViewExcept(focusFiltesView,slidersVStack,filterSlider,brightSlider)
            focusFiltesView.dataArray = BlurFilterEnum.allCases
            
        case .sticker:// -=-==-=-=-=----=---=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=--  For stickers
            stickerCollectionView.fadeIn()
            LocalStore.instance.CommonBtnStatus = .stickers
            hideAllViewExcept(controlsView,grandCollectnView)
//            opaqueView.fadeIn(with: 0.7)
//            focusFiltesView.currentWorkFor = .sticker
//            FilterImage.shared.currentWorkFor = .sticker
//            controlsView.isHidden = false
//            controlsView.bringSubviewToFront(BaseView)
        case .text: // -=-==-=-=-=----=---=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=--  For text
            isAddNewText = true
            hideAllViewExcept(textOptionsView,controlsView)
            textOptionsView.currentWorkFor = .text
//            textOptionsView.grandCollectnVw.collectionViewLayout = textOptionsView.centerLayout
            textOptionsView.dataArray = TextFilterOptions.allCases
           
            textView.text = ""
            textView.becomeFirstResponder()
            opaqueView.fadeIn( with: 0.7 )
//            controlsView.bringSubviewToFront(self.view)
            
            LocalStore.instance.CommonBtnStatus = .text
            print("Selected type is Text")
//            textViewDidChange(textView: textView)
            
//        case .music: // -=-==-=-=-=----=---=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=--  For Music
//            let mnger = AudioManager()
//            mnger.mix(videoAsst: LocalStore.instance.currentAsset!, musicUrl: nil, composition: (self.VideoCompositon?.makeAVVideoComposition())!) { result in
//                switch result{
//                case .success(let outputURL):
//                    print(outputURL)
//                    let asset = mnger.convertUrlToAsset(url: outputURL)
//                    self.videoAsset = asset
//                    LocalStore.instance.currentAsset = asset
//                    let item = AVPlayerItem(asset: asset!)
//                    MyPlayer.share.playVideoWithAsset(item)
////                    MyPlayer.share.player?.replaceCurrentItem(with: item)
//                    MyPlayer.share.player?.play()
//
//
//                case .failure(let error):
//                    print(error)
//                }
//            }
                
            
            
        default:
            LocalStore.instance.CommonBtnStatus = .export
            UIAlertController.showAlertOnly("Sorry!", "we are working on this task")
        }
    }
//    func loadItemsforOverlay(){
//        blendModesView.dataArray = MTIBlendModes.all//blendModeArr
//        hideAllViewExcept(blendView)
//    }
    // -- Hide All Views Method
   
  
}
//MARK: - Didselect TextOptions
extension PreViewVc:TextOptionsDelegate{
    func didSelectItem(selectedOption: TextFilterOptions) {
        selectedTextOption = selectedOption
        switch selectedOption {
        case .color,.bgColor:
//            LocalStore.instance.CommonBtnStatus = .colorPicker
            colorPickerView.dataArr.append(contentsOf: Constants.colorArr)
            colorPickerView.currentWorfor = .text
            hideAllViewExcept(colorPickerView)
            bottomButtonsWorkFor(.colorPicker)
//            LocalStore.instance.CommonBtnStatus = .stickers
//            btnView.btnImages(ButtonImages.multiply!, ButtonImages.checkMark!)
            print("selected OPTION IS COLOR")
        case .font:
            let fontArr = getAllFonts()
            bottomButtonsWorkFor(.fontPicker)
//            LocalStore.instance.CommonBtnStatus = .fontPicker
            fontPickerView.dataArr.append(contentsOf: fontArr)
            fontPickerView.currentWorfor = .text
            fontPickerView.textSubOption = .font
            hideAllViewExcept(fontPickerView)
//            LocalStore.instance.CommonBtnStatus = .stickers
//            btnView.btnImages(ButtonImages.multiply!, ButtonImages.checkMark!)
            print("selected OPTION IS BackGround COLOR")
        default:
            break
        }
    }
    func getAllFonts() -> [String] {
        var fontArr = [String]()
        for family in UIFont.familyNames {
                print("family:", family)
                for font in UIFont.fontNames(forFamilyName: family) {
                    fontArr.append(font)
                    print("font:", font)
                }
            }
        return fontArr
     }
  
}
