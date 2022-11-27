//
//  ResizableView.swift
//  Resizable
//
//  Created by Caroline on 6/09/2014.
//  Copyright (c) 2014 Caroline. All rights reserved.
//

import UIKit
import EasyPeasy
class ResizableTxtView: NSObject {

  var topLeft:DragHandle!
  var topRight:DragHandle!
  var bottomLeft:DragHandle!
  var bottomRight:DragHandle!
  var rotateHandle:DragHandle!
  var borderView:ResizeBorder!
  var previousLocation = CGPoint.zero
  var rotateLine = CAShapeLayer()
  var initialFrame:CGPoint?
    var initalPoint = CGPoint.zero
    var isPanActive:Bool?
  
    var pan:UIPanGestureRecognizer?
    var pinch:UIPinchGestureRecognizer?
    var rotate:UIRotationGestureRecognizer?
    
    private weak var weakTransformView: UIView?
    
    
    init(view:UIView) {
        super.init()
        addSubviews(subVw:view)
        weakTransformView = view
    }
    deinit {
        borderView.removeFromSuperview()
        topLeft.removeFromSuperview()
        topRight.removeFromSuperview()
        bottomLeft.removeFromSuperview()
        bottomRight.removeFromSuperview()
        rotateHandle.removeFromSuperview()
        borderView.removeFromSuperview()
        borderView = nil
        
    }
    
    
    func addSubviews(subVw:UIView) {
//      initialFrame = self.frame
    let resizeFillColor = UIColor.cyan
    let resizeStrokeColor = UIColor.black
    let rotateFillColor = UIColor.orange
    let rotateStrokeColor = UIColor.black
    topLeft = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    topRight = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    bottomLeft = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    bottomRight = DragHandle(fillColor:resizeFillColor, strokeColor: resizeStrokeColor)
    rotateHandle = DragHandle(fillColor:rotateFillColor, strokeColor:rotateStrokeColor)
    
    rotateLine.opacity = 0.0
    rotateLine.lineDashPattern = [3,2]
    
        borderView = ResizeBorder(frame: subVw.bounds)
    borderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if subVw.contains(borderView){}
        else{
            subVw.addSubview(borderView)
        subVw.superview?.addSubview(bottomLeft)
         subVw.superview?.addSubview(bottomRight)
            
        }
       
        
//    superview?.addSubview(topLeft)
//    superview?.addSubview(topRight)
        
//    superview?.addSubview(rotateHandle)
//    self.layer.addSublayer(rotateLine)
        addLayer(toview: subVw)
        self.updateDragHandles(View: subVw)
  }
    func removeLayer(){
        isPanActive = false
        pinch = nil
        pan = nil
        rotate = nil
        
        topLeft.isHidden = true
        topRight.isHidden = true
        bottomLeft.isHidden = true
        bottomRight.isHidden = true
        rotateHandle.isHidden = true
        borderView.isHidden = true
    }
    
 
    
    
    
    func addLayer(toview view:UIView){
        isPanActive = true
        pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableTxtView.handlePan(_:)))
         topLeft.addGestureRecognizer(pan!)
       pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableTxtView.handlePan(_:)))
       topRight.addGestureRecognizer(pan!)
       pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableTxtView.handlePan(_:)))
       bottomLeft.addGestureRecognizer(pan!)
       pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableTxtView.handlePan(_:)))
       bottomRight.addGestureRecognizer(pan!)
       pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableTxtView.handleRotate(_:)))
       rotateHandle.addGestureRecognizer(pan!)
       pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableTxtView.handleMove(_:)))
        view.addGestureRecognizer(pan!)
         pinch = UIPinchGestureRecognizer(target: self, action: #selector(ResizableTxtView.pinchProcess(_:)))
        view.addGestureRecognizer(pinch!)
         rotate = UIRotationGestureRecognizer(target: self, action: #selector(ResizableTxtView.handleRotateNew(_:)))
        view.addGestureRecognizer(rotate!)
        
        topLeft.isHidden = false
        topRight.isHidden = false
        bottomLeft.isHidden = false
        bottomRight.isHidden = false
        rotateHandle.isHidden = false
        borderView.isHidden = false
        
    }
        
    func updateDragHandles(View:UIView) {
    topLeft.center = View.transformedTopLeft()
    topRight.center = View.transformedTopRight()
      bottomLeft.center = View.transformedBottomLeft()
    bottomRight.center = View.transformedBottomRight()
    rotateHandle.center = View.transformedRotateHandle()
    borderView.bounds = View.bounds
      borderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    borderView.setNeedsDisplay()
  }

  //MARK: - Gesture Methods
  
    @objc func handleMove(_ gesture:UIPanGestureRecognizer) {
        if isPanActive!{
            guard let view = self.weakTransformView else { return }
            let translation = gesture.translation(in: view.superview)
    
    var center = view.center
    center.x += translation.x
    center.y += translation.y
            view.center = center

    gesture.setTranslation(CGPoint.zero, in: view.superview!)
            updateDragHandles(View: view)
            initalPoint = view.center
        }
  }
  
  func angleBetweenPoints(_ startPoint:CGPoint, endPoint:CGPoint)  -> CGFloat? {
      guard let view = self.weakTransformView else { return nil }
    let a = startPoint.x - view.center.x
    let b = startPoint.y - view.center.y
    let c = endPoint.x - view.center.x
    let d = endPoint.y - view.center.y
    let atanA = atan2(a, b)
    let atanB = atan2(c, d)
      
    return atanA - atanB
    
  }

  func drawRotateLine(_ fromPoint:CGPoint, toPoint:CGPoint) {
    let linePath = UIBezierPath()
    linePath.move(to: fromPoint)
    linePath.addLine(to: toPoint)
    rotateLine.path = linePath.cgPath
    rotateLine.fillColor = nil
    rotateLine.strokeColor = UIColor.orange.cgColor
    rotateLine.lineWidth = 2.0
    rotateLine.opacity = 1.0
  }
        
    var imageViewScale: CGFloat = 1.0
    let maxScale: CGFloat = 5.0
    let minScale: CGFloat = 0.8
    
//        private var lastScale:CGFloat = 1.0
//           private var lastPinchPoint:CGPoint = CGPoint(x: 0, y: 0)
           @objc func pinchProcess(_ recognizer:UIPinchGestureRecognizer) {
               if isPanActive!{
                   guard let view = recognizer.view else { return }
                   if recognizer.state == .began || recognizer.state == .changed {
                       let pinchScale: CGFloat = recognizer.scale

                       if imageViewScale * pinchScale < maxScale && imageViewScale * pinchScale > minScale {
                           imageViewScale *= pinchScale
                           view.transform = (view.transform.scaledBy(x: pinchScale, y: pinchScale))
                           if let vw = recognizer.view as? UITextView{
        //                       vw.updateTextFont()
//                               vw.layer.affineTransform = CGAffineTransformMakeScale(1.0/pinchScale, 1.0/pinchScale);
//                               vw.layer.aff
                               vw.updateScale(forZoomScale: imageViewScale)
//                               updateScale(forZoomScale: imageViewScale, view: vw)
//                               vw.contentScaleFactor = imageViewScale
                           }
                       }
                       recognizer.scale = 1.0
                   }
                   let location = recognizer.location(in: view.superview!)
                   previousLocation = location
                   initalPoint = view.center
                  
                   self.updateDragHandles(View: view)
               }
           }
    
    
    @objc func handleRotateNew(_ gesture:UIRotationGestureRecognizer) { // new added
        guard let view = self.weakTransformView else { return }
        if isPanActive!{
    switch gesture.state {
    case .ended:
      self.rotateLine.opacity = 0.0
    default:()
    }
    let location = gesture.location(in: view.superview!)
//    let angle = angleBetweenPoints(previousLocation, endPoint: location)
            view.transform = view.transform.rotated(by: gesture.rotation)//transform.rotated(by: angle)
    previousLocation = location
        gesture.rotation = 0
            initalPoint = view.center
            self.updateDragHandles(View: view)
        }
    }
    
    @objc func handleRotate(_ gesture:UIPanGestureRecognizer) {
        guard let view = self.weakTransformView else { return }
        if isPanActive!{
    switch gesture.state {
    case .began:
      previousLocation = rotateHandle.center
        self.drawRotateLine(CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2), toPoint:CGPoint(x: view.bounds.size.width + DragHandle.diameter, y: view.bounds.size.height/2))
    case .ended:
      self.rotateLine.opacity = 0.0
    default:()
    }
    let location = gesture.location(in: view.superview!)
            guard let angle = angleBetweenPoints(previousLocation, endPoint: location) else {return}
            view.transform = view.transform.rotated(by: angle)
    previousLocation = location
            self.updateDragHandles(View: view)
        }
  }
  
    @objc func handlePan(_ gesture:UIPanGestureRecognizer) {
        guard let view = self.weakTransformView else { return }
        if isPanActive!{
            
           
    let translation = gesture.translation(in: view)
    switch gesture.view! {
      
        
    case topLeft:
      if gesture.state == .began {
          view.setAnchorPoint(CGPoint(x: 1, y: 1))
      }
        view.bounds.size.width -= translation.x
        view.bounds.size.height -= translation.y
        
//        self.updateTextFont()
        
    case topRight:
      if gesture.state == .began {
          view.setAnchorPoint(CGPoint(x: 0, y: 1))
      }
        view.bounds.size.width += translation.x
        view.bounds.size.height -= translation.y
//        self.updateTextFont()
        
    case bottomLeft:
      if gesture.state == .began {
          view.setAnchorPoint(CGPoint(x: 1, y: 0))
      }
        let vW = weakTransformView
        if let textView = vW as? UITextView{
            let fontSize = (textView.font?.ascender ?? UIFont.systemFont(ofSize: 25).ascender)
          
        let val = translation.x
        print(val)
        if val.sign == .plus{
            if view.bounds.size.width > fontSize + 5 {
                view.bounds.size.width -= val
            }
        }else{
            view.bounds.size.width -= val
        }
            let inHgt = view.bounds.size.height
            let newSize = textView.sizeThatFits(CGSize(width: textView.bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
            textView.bounds.size.height = newSize.height
            let finaHgt = view.bounds.size.height
            view.center.y -= (finaHgt - inHgt) / 2
        }
        else{
            view.bounds.size.width -= translation.x
        }
    case bottomRight:
      if gesture.state == .began {
          view.setAnchorPoint(CGPoint.zero)
      }
        let val = translation.x
        print(val)
        let vW = weakTransformView
        
        if let textView = vW as? UITextView{
            let fontSize = (textView.font?.ascender ?? UIFont.systemFont(ofSize: 25).ascender)
           
        if val.sign == .minus{
            if view.bounds.size.width > fontSize {
                view.bounds.size.width += val
            }
        }else{
            view.bounds.size.width += val
        }
            let inHgt = view.bounds.size.height
            let newSize = textView.sizeThatFits(CGSize(width: textView.bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
            textView.bounds.size.height = newSize.height
            let finaHgt = view.bounds.size.height
            view.center.y -= (finaHgt - inHgt) / 2
            
        }else{
            view.bounds.size.width += val
        }
    default:()
    }
    
    gesture.setTranslation(CGPoint.zero, in: view)
            updateDragHandles(View: view)
    if gesture.state == .ended {
        view.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
    }
        }
  }
    
}
/*extension UITextView {
func updateTextFont() {
    if (self.text.isEmpty || self.bounds.size.equalTo(CGSize.zero)) {
        return;
    }

    let textViewSize = self.frame.size;
    let fixedWidth = textViewSize.width;
    let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))


    var expectFont = self.font
    if (expectSize.height > textViewSize.height) {

        while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
            expectFont = self.font!.withSize(self.font!.pointSize - 0.7)
            self.font = expectFont
        }
    }
    else {
        while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
            expectFont = self.font
            self.font = self.font!.withSize(self.font!.pointSize + 0.7)
        }
        self.font = expectFont
    }
}
}*/
extension UITextView {
    func adjustUITextViewHeight() {
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentMode = .scaleToFill
//        self.sizeToFit()
//        self.translatesAutoresizingMaskIntoConstraints = true
//
//        self.isScrollEnabled = false
    }
}
extension UIView{
    func updateScale(forZoomScale zoomScale: CGFloat) {
        let screenAndZoomScale = zoomScale * UIScreen.main.scale
        // Walk the layer and view hierarchies separately. We need to reach all tiled layers.
        applyScale(zoomScale * UIScreen.main.scale, to: self)
        applyScale(zoomScale * UIScreen.main.scale, to: self.layer)
    }

    private func applyScale(_ scale: CGFloat, to view: UIView?) {
        view?.contentScaleFactor = scale
        for subview in view?.subviews ?? [] {
            applyScale(scale, to: subview)
        }
    }

    private func applyScale(_ scale: CGFloat, to layer: CALayer?) {
        layer?.contentsScale = scale
        for sublayer in layer?.sublayers ?? [] {
            applyScale(scale, to: sublayer)
        }
        
        
    }
}
