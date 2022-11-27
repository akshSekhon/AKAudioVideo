//
//  StickerClass.swift
//  AsafVideoIMG
//
//  Created by Mobile on 26/09/22.
//

import UIKit
import MetalPetal
class StickerMaker:NSObject{
    var borderLayer:ResizeBorder?
    func aspectRatio(innerRect: CGRect,outerRect: CGRect, perpendicularRect: CGRect) -> CGRect{
        let inerH = innerRect.height
        let inerW = innerRect.width
        let inerX = innerRect.minX
        let inerY = innerRect.minY
        let outH = outerRect.height
        let outW = outerRect.width
        let outX = outerRect.width//maxX
        let outY =  outerRect.height//maxY
 
        let xR = outX / inerX
        let yR = outY / inerY
        let widR = outW / inerW
        let hgtR = outH / inerH
        
        print("hgtR,widR,xR,yR is =-=-",xR,yR,widR,hgtR)
        return aspectedFrame(or: perpendicularRect, scale: [xR,yR,widR,hgtR])
        
    }
    
    func aspectedFrame(or imgFrame:CGRect,scale:[Double]) -> CGRect{
        let stickX = imgFrame.width / scale[0]
        let stickY = imgFrame.height / scale[1]
        let stickWidh = imgFrame.width / scale[2]
        let sticHgt = imgFrame.height / scale[3]
        return CGRect(x: stickX, y: stickY, width: stickWidh, height: sticHgt)
    }
    func generateImageFromUIView(_ view: UIView) -> UIImage {
       let opaque = false
       UIGraphicsBeginImageContextWithOptions(view.bounds.size, opaque, 0.0)
       view.layer.render(in: UIGraphicsGetCurrentContext()!)
       let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
       UIGraphicsEndImageContext()
       return img
   }
    //MARK: - Remove all views From ContainerView And empty imageViewArr & imgLayerArr
    func clearStickerContainter(view:UIView,viewArray: inout Dictionary <Int, UIView>,layerArr: inout Dictionary <Int, ImageObject>){
        let _: [()] = view.subviews.compactMap { $0.removeFromSuperview()
            viewArray.removeValue(forKey: $0.tag)
            layerArr.removeValue(forKey: $0.tag)
        }
        view.removeFromSuperview()
    }
    //MARK: - Select View add layer ann SnapGuesture
    func addEditingLayer(of containerView:UIView,with viewtag:Int,moveingGuesture: inout SnapGesture,resizeView: inout ResizableTxtView?){
        guard let view = containerView.viewWithTag(viewtag) else{return}
        if let txtView = containerView.viewWithTag(viewtag) as? UITextView{
            resizeView = nil
            resizeView = ResizableTxtView(view: txtView)
           
        }else{
            resizeView = nil
            resizeView = ResizableTxtView(view: view)
            resizeView?.bottomLeft.isHidden = true
            resizeView?.bottomRight.isHidden = true
//            moveingGuesture = SnapGesture(view: view)
        }
        for view in containerView.subviews{
            if view.tag == viewtag {
                
            }else{
//                view.layer.borderColor = UIColor.clear.cgColor
//                view.layer.borderWidth = 0
            }
        }
    }
    
   /* func addEditingLayerForText(_ controller:UIViewController,actionLeft:Selector,actionRight:Selector ,of containerView:UIView,with viewtag:Int,moveingGuesture: inout SnapGesture){
        let view = containerView.viewWithTag(viewtag)
        
        guard let vw = view as? NiblessView else{return}//UITextView else{return}
        moveingGuesture = SnapGesture(view: vw)
        for view in containerView.subviews{
            if view.tag == vw.tag{
                vw.layer.borderColor = UIColor.darkGray.cgColor
                vw.layer.borderWidth = 1.3
                addWidthAdjusterButtons(controller, actionLeft: actionLeft, actionRight: actionRight, toView: vw, isEnable: true)
            }else{
                addWidthAdjusterButtons(controller, actionLeft: actionLeft, actionRight: actionRight, toView: vw, isEnable: false)
                vw.layer.borderColor = UIColor.clear.cgColor
                vw.layer.borderWidth = 0
            }
            
        }

    }*/
 
   
    
    func addStickersLayerOnVideo(_ imageObjectArray:Dictionary<Int,ImageObject>) {
        imageObjectArray.forEach { object in
            let val = object.value
            guard let img = val.image else{return}
            let position = val.xy
            let size = val.size
            let opacity = val.opacity
            let rotate = val.rotation
            
            let clayer1 = MTILayer(content: img, layoutUnit: .pixel, position: position ?? .zero , size: size ?? CGSize(width: 1000, height: 1500) , rotation: Float(rotate ?? 0) , opacity: opacity ?? 1, blendMode: .normal)
            FilterImage.shared.multiLayerFilter.layers.append(clayer1)
//            completion()
        }

}
    // FIXME: - Sticker Rotation
    func addSickersOnContainer(innerView:UIView?,outerView:UIView,imgLyrArr: inout Dictionary<Int,ImageObject>){
        guard let vw = innerView else{
            print("image view\(String(describing: innerView?.tag)) not found")
            return
        }
        
        let imageOverlay = self.generateImageFromUIView(vw)//else {return}
        
        var currentImage:MTIImage?
        if let img2 = FilterImage.shared.filterdImage {
            currentImage = img2
        }else{
            guard let img = FilterImage.shared.orignalImage else {return}
            currentImage = img
        }
        
        let ciImageOverlay = CIImage(cgImage: imageOverlay.cgImage!)
//        let uiImg = UIImage(ciImage: ciImageOverlay)
        let StickerViewFrame = vw.frame
        let videoRect = CGRectMake(0, 0, (currentImage?.size.width)!, (currentImage?.size.height)!)
//        CGRectMake(0,0,CGRectGetWidth(currentImage?.size.width)!,CGRectGetHeight(currentImage?.size.height)!)
//        CGRect(x: 0, y: 0, width: (currentImage?.size.width)!, height: (currentImage?.size.height)!)
        let stckerRect = CGRectMake(StickerViewFrame.midX,StickerViewFrame.midY,CGRectGetWidth(StickerViewFrame),CGRectGetHeight(StickerViewFrame))
        let outerViewRect = CGRectMake(outerView.bounds.midX,outerView.bounds.midY,CGRectGetWidth(outerView.bounds),CGRectGetHeight(outerView.bounds))
        let stickerImgFrame = self.aspectRatio(innerRect: stckerRect, outerRect: outerViewRect, perpendicularRect: videoRect)
        
//        let stickerImgFrame = self.aspectRatio(innerRect: StickerViewFrame, outerRect: outerView.bounds, perpendicularRect: videoRect)
        
        
        
        guard let angle = angleBetweenPoints(stckerRect.origin, endPoint: outerViewRect.origin, vw: outerView) else {return}
        
        let rotation = vw.transform.c
        
        let img = MTIImage(ciImage: ciImageOverlay, isOpaque: true)
        
        let imgObj = ImageObject()
        imgObj.image = img
        imgObj.size = stickerImgFrame.size
        imgObj.id = vw.tag
        imgObj.xy = stickerImgFrame.origin//CGPoint(x: vw.frame.minX, y: vw.frame.minY)
        imgObj.rotation = 0//angle / 2
        imgObj.positionInComposite =  FilterImage.shared.multiLayerFilter.layers.count - 1
        imgLyrArr.updateValue(imgObj, forKey: vw.tag)
//        imgLayerArr.append(imgObj)
    }
    
    func angleBetweenPoints(_ startPoint:CGPoint, endPoint:CGPoint,vw:UIView?)  -> CGFloat? {
        guard let view = vw else { return nil }
      let a = startPoint.x - view.center.x
      let b = startPoint.y - view.center.y
      let c = endPoint.x - view.center.x
      let d = endPoint.y - view.center.y
      let atanA = atan2(a, b)
      let atanB = atan2(c, d)
        
      return atanA - atanB
      
    }
    
    
}
class ImageObject {
    var id: Int? // If required
    var used: Bool? = false
    var image: MTIImage?
    var size: CGSize?
    var xy: CGPoint?
    var opacity: Float?
    var rotation:CGFloat?
    var positionInComposite: Int?
    
    init(id: Int? = nil, used: Bool? = nil, image: MTIImage? = nil, size: CGSize? = nil, xy: CGPoint? = nil, opacity: Float? = nil, rotation: CGFloat? = nil, positionInComposite: Int? = nil) {
        self.id = id
        self.used = used
        self.image = image
        self.size = size
        self.xy = xy
        self.opacity = opacity
        self.rotation = rotation
        self.positionInComposite = positionInComposite
    }
    
    
}

extension UIImage { // To drw sticker image on transparent image
    class func makeStickerImg(overRect: CGRect,overimg:UIImage,innerRect:CGRect) -> UIImage {
        UIGraphicsBeginImageContext(overRect.size)
            let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(UIColor.clear.cgColor)
            context!.fill(overRect)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        let overImg = UIImage.saveOverImage(img!, with: overRect, overimg, with: innerRect)
            return overImg
        }
    class func saveOverImage(_ botmImg:UIImage ,with botomRect: CGRect,_ topImage:UIImage,with topRect: CGRect) -> UIImage{
        let bottomImage = botmImg
        let topImage = topImage
        
        UIGraphicsBeginImageContextWithOptions(botomRect.size, false, 0.0)

        bottomImage.draw(in: CGRect(origin: botomRect.origin, size: botomRect.size))
        topImage.draw(in: topRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    
}
extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
extension UIView {
    
    var rotation: Float {
        let radians:Float = atan2f(Float(transform.b), Float(transform.a))
        return radians * Float(180 / Double.pi)
    }
}
