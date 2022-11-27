//
//  TextExtenssion.swift
//  AsafVideoIMG
//
//  Created by Mobile on 06/10/22.
//

import UIKit
import EasyPeasy

//MARK: - Add textView
extension PreViewVc: UITextViewDelegate{
    @objc
    func doneBtnAction(_ txtVw:UITextView){
        textView.resignFirstResponder()
        opaqueView.fadeOut()
        if isAddNewText{
            if textView.hasText{
                subviewTag += 1
                selectedBoxTag = subviewTag
                textArray.updateValue(textView.text, forKey: subviewTag)
                addtextView(withTag: subviewTag)
            }else{
                hideAllViewExcept(grandCollectnView)
                bottomButtonsWorkFor(.export)
                
            }
        }else{
            textArray.updateValue(textView.text, forKey: selectedBoxTag)
            addtextView(withTag: selectedBoxTag)
        }
        textView.text = ""
    }

    @objc
    func cancelBtnAction(_ txtVw:UITextView){
        textView.resignFirstResponder()
        opaqueView.fadeOut()
    }
    
    

        
    
    func addtextView(withTag:Int){
        if self.BaseView.subviews.contains(containerView){
           print("Container View AlreadyAdded")
        }else
        {
            self.BaseView.addSubview(containerView)
            containerView.frame = BaseView.bounds
        }
        if self.BaseView.subviews.contains(containerView){
             let nVw = containerView.viewWithTag(withTag)
            if let vw = nVw as? UITextView{
                if containerView.subviews.contains(vw){
                    vw.text = textArray[vw.tag]
                    vw.sizeToFit()
                    vw.layoutIfNeeded()
                }
            }
            else
            {
                if let text = textArray[withTag]{
                    addtextBox(withText: text, onView: containerView, wihTag: withTag)
                }else{
                    addtextBox(withText: "no text found in data", onView: containerView, wihTag: withTag)
                }
            }
        }
    }
    
   func addtextBox(withText:String,onView:UIView,wihTag:Int){
        
        let textVw = UITextView()
        textVw.backgroundColor = .clear
        textVw.tag = wihTag
        textVw.text = withText
        textVw.font = textView.font;textVw.textAlignment = .center
//       textVw.centerVerticalText()
        textVw.isEditable = false; textVw.isScrollEnabled = false; textVw.isSelectable = false;
        textVw.clipsToBounds = true;textVw.layer.masksToBounds = true;textVw.isUserInteractionEnabled = false
//        textVw.sizeToFit()
       textVw.frame.size = CGSizeMake(BaseView.bounds.width / 3, BaseView.bounds.height / 3)
       textVw.center = BaseView.center
//       textVw.alignTextVerticallyInContainer()
        subViewsArray.updateValue(textVw, forKey: textVw.tag)
        addtapGuesture(vw: textVw)
        if resizeable == nil{
            resizeable = ResizableTxtView(view: UIView())
        }
        if guseture == nil{
            guseture = SnapGesture(view: UIView())
        }
        if isAddNewText{
            resizeable = ResizableTxtView(view: textVw)
            onView.addSubview(textVw)
            textVw.bringSubviewToFront(onView)
        }
        selectedBoxTag = wihTag
        resizeable?.removeLayer()
        stickerMaker?.addEditingLayer(of: containerView, with: textVw.tag, moveingGuesture: &guseture!, resizeView: &resizeable)
      
    }
    
  
}
//MARK:  🟥🟧🟩🟪 Change Color of selected TextView
extension PreViewVc: TextPropertiesDelegate {
    func didSelectColor(selectedColor: UIColor) {
        guard let view = selectedTextView() else{return}
        bottomButtonsWorkFor(.colorPicker)
//        btnView.btnImages(ButtonImages.multiply!, ButtonImages.checkMark!)
                    switch selectedTextOption {
                    case .color:
                        view.textColor = selectedColor
                        textOptionsView.selectedColor = view.textColor
                    case .bgColor:
                        view.backgroundColor = selectedColor
                        textOptionsView.selectedBgColor = view.backgroundColor
                    default:
                        break
                    }
    }
    func didselectAlignment(alignment: NSTextAlignment) {
        guard let view = selectedTextView() else{return}
        bottomButtonsWorkFor(.textAlingnment)
        if selectedTextOption == .alignment{
            view.textAlignment = alignment
           
        }
    }
    func didselectFont(selectedFont: UIFont) {
        guard let view = selectedTextView() else{return}
        bottomButtonsWorkFor(.fontPicker)
        if selectedTextOption == .font{
            view.font = selectedFont
            view.sizeToFit()
            resizeable?.updateDragHandles(View: view)
        }
    }
        
    func selectedTextView() -> UITextView?{
        var textVw:UITextView?
        if self.BaseView.subviews.contains(containerView){
            let nVw = containerView.viewWithTag(selectedBoxTag)
            guard let vw = nVw as? UITextView else {return nil}
                if containerView.subviews.contains(vw){
                    textVw = vw
                }else{return nil}
            return textVw
            }
        else{return nil}
        }
   
}



extension UITextView {
    func alignTextVerticallyInContainer() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = ((bounds.size.height - size.height * zoomScale) / 2)
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset + 1
    }
}
