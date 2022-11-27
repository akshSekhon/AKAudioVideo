//
//  ResizableView.swift
//  Resizable
//
//  Created by Caroline on 6/09/2014.
//  Copyright (c) 2014 Caroline. All rights reserved.
//

import UIKit

class ResizableView: UIView {

  var topLeft:DragHandle!
  var topRight:DragHandle!
  var bottomLeft:DragHandle!
  var bottomRight:DragHandle!
  var rotateHandle:DragHandle!
  var borderView:ResizeBorder!
  var previousLocation = CGPoint.zero
  var rotateLine = CAShapeLayer()
  var initialFrame:CGPoint?
    var isPanActive:Bool?
  
    var pan:UIPanGestureRecognizer?
    var pinch:UIPinchGestureRecognizer?
    var rotate:UIRotationGestureRecognizer?
  override func didMoveToSuperview() {
      initialFrame = CGPointMake(self.center.x, self.center.y)
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
    
    borderView = ResizeBorder(frame:self.bounds)
    borderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(borderView)
      self.clipsToBounds = true
//    superview?.addSubview(topLeft)
//    superview?.addSubview(topRight)
    superview?.addSubview(bottomLeft)
    superview?.addSubview(bottomRight)
//    superview?.addSubview(rotateHandle)
//    self.layer.addSublayer(rotateLine)
      addLayer()
    self.updateDragHandles()
  }
    
    
    deinit {
        borderView = nil
        bottomLeft = nil
        bottomRight = nil
        
//        self.removeFromSur̥perview()
    }
    
   
    func removeLayer(){
        isPanActive = false
        pinch = nil
        pan = nil
        rotate = nil
        bottomRight = nil
        bottomLeft = nil
        topLeft.isHidden = true
        topRight.isHidden = true
        bottomLeft.isHidden = true
        bottomRight.isHidden = true
        rotateHandle.isHidden = true
        borderView.isHidden = true
    }
    func addLayer(){
        isPanActive = true
        pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableView.handlePan(_:)))
         topLeft.addGestureRecognizer(pan!)
       pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableView.handlePan(_:)))
       topRight.addGestureRecognizer(pan!)
       pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableView.handlePan(_:)))
       bottomLeft.addGestureRecognizer(pan!)
       pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableView.handlePan(_:)))
       bottomRight.addGestureRecognizer(pan!)
       pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableView.handleRotate(_:)))
       rotateHandle.addGestureRecognizer(pan!)
       pan = UIPanGestureRecognizer(target: self, action: #selector(ResizableView.handleMove(_:)))
        self.addGestureRecognizer(pan!)
        
         pinch = UIPinchGestureRecognizer(target: self, action: #selector(ResizableView.pinchProcess(_:)))
        self.addGestureRecognizer(pinch!)
         rotate = UIRotationGestureRecognizer(target: self, action: #selector(ResizableView.handleRotateNew(_:)))
        self.addGestureRecognizer(rotate!)
        
//        self.subviews.forEach { vw in
//            vw.addGestureRecognizer(pan!)
//            vw.addGestureRecognizer(pinch!)
//            vw.addGestureRecognizer(rotate!)
//        }
        
//        self.subviews.compactMap { $0.addGestureRecognizer(pan!)
//            $0.addGestureRecognizer(pinch!)
//            $0.addGestureRecognizer(rotate!)
//        }
        topLeft.isHidden = false
        topRight.isHidden = false
        bottomLeft.isHidden = false
        bottomRight.isHidden = false
        rotateHandle.isHidden = false
        borderView.isHidden = false
        self.backgroundColor = .yellow
        self.clipsToBounds = true
    }
    
    
    
  func updateDragHandles() {
    topLeft.center = self.transformedTopLeft()
    topRight.center = self.transformedTopRight()
      bottomLeft.center = self.transformedBottomLeft()
    bottomRight.center = self.transformedBottomRight()
      
    rotateHandle.center = self.transformedRotateHandle()
    borderView.bounds = self.bounds
      borderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//      initialFrame = self.center
    borderView.setNeedsDisplay()
  }

  //MARK: - Gesture Methods
  
    @objc func handleMove(_ gesture:UIPanGestureRecognizer) {
        if isPanActive!{
    let translation = gesture.translation(in: self.superview!)
    
    var center = self.center
    center.x += translation.x
    center.y += translation.y
    self.center = center

    gesture.setTranslation(CGPoint.zero, in: self.superview!)
//            initialFrame = self.center
    updateDragHandles()
        }
  }
  
  func angleBetweenPoints(_ startPoint:CGPoint, endPoint:CGPoint)  -> CGFloat {
    let a = startPoint.x - self.center.x
    let b = startPoint.y - self.center.y
    let c = endPoint.x - self.center.x
    let d = endPoint.y - self.center.y
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
    let maxScale: CGFloat = 2.0
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
//                           initialFrame = self.center
                       }
                       recognizer.scale = 1.0
                   }
                  
               self.updateDragHandles()
               }
           }
//    lastScale

        
        
        
        
    @objc func handleRotateNew(_ gesture:UIRotationGestureRecognizer) { // new added
        if isPanActive!{
    switch gesture.state {
    case .ended:
      self.rotateLine.opacity = 0.0
    default:()
    }
    let location = gesture.location(in: self.superview!)
    let angle = angleBetweenPoints(previousLocation, endPoint: location)
    self.transform = self.transform.rotated(by: gesture.rotation)//transform.rotated(by: angle)
    previousLocation = location
        gesture.rotation = 0
//            initialFrame = self.center
    self.updateDragHandles()
        }
    }
//    FIXME: -

    @objc func handleRotate(_ gesture:UIPanGestureRecognizer) {
        if isPanActive!{
    switch gesture.state {
    case .began:
      previousLocation = rotateHandle.center
        self.drawRotateLine(CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2), toPoint:CGPoint(x: self.bounds.size.width + DragHandle.diameter, y: self.bounds.size.height/2))
    case .ended:
      self.rotateLine.opacity = 0.0
    default:()
    }
    let location = gesture.location(in: self.superview!)
    let angle = angleBetweenPoints(previousLocation, endPoint: location)
    self.transform = self.transform.rotated(by: angle)
//            initialFrame = self.center
    previousLocation = location
    self.updateDragHandles()
        }
  }
  
    @objc func handlePan(_ gesture:UIPanGestureRecognizer) {
        if isPanActive!{
    let translation = gesture.translation(in: self)
    switch gesture.view! {
      
        
    case topLeft:
      if gesture.state == .began {
        self.setAnchorPoint(CGPoint(x: 1, y: 1))
      }
      self.bounds.size.width -= translation.x
      self.bounds.size.height -= translation.y
        
    case topRight:
      if gesture.state == .began {
        self.setAnchorPoint(CGPoint(x: 0, y: 1))
      }
      self.bounds.size.width += translation.x
      self.bounds.size.height -= translation.y
        
    case bottomLeft:
      if gesture.state == .began {
        self.setAnchorPoint(CGPoint(x: 1, y: 0))
      }
        let vW = self.subviews.last
        if let v = vW as? UITextView{
            let fontSize = (v.font?.ascender ?? UIFont.systemFont(ofSize: 25).ascender)
        let val = translation.x
        print(val)
        if val.sign == .plus{
            if self.bounds.size.width > fontSize + 60 {
                self.bounds.size.width -= val
            }
        }else{
            self.bounds.size.width -= val
        }
            let inHgt = self.bounds.size.height
            let rect = CGRectMake(self.bounds.minX, v.bounds.minY + 30, self.bounds.size.width, v.bounds.size.height + 30)
            self.bounds.size = rect.size
            let finaHgt = self.bounds.size.height
            self.center.y -= (finaHgt - inHgt) / 2
        }
        else{
            self.bounds.size.width -= translation.x
        }
    case bottomRight:
      if gesture.state == .began {
        self.setAnchorPoint(CGPoint.zero)
      }
        let val = translation.x
        print(val)
        let vW = self.subviews.last
        
        if let v = vW as? UITextView{
            let fontSize = (v.font?.ascender ?? UIFont.systemFont(ofSize: 25).ascender)
        if val.sign == .minus{
            if self.bounds.size.width > fontSize + 60 {
                self.bounds.size.width += val
            }
        }else{
            self.bounds.size.width += val
        }
            let inHgt = self.bounds.size.height
            let rect = CGRectMake(self.bounds.minX, v.bounds.minY + 30, self.bounds.size.width, v.bounds.size.height + 30)
            self.bounds.size = rect.size
            let finaHgt = self.bounds.size.height
            
            self.center.y -= (finaHgt - inHgt) / 2
        }else{
            self.bounds.size.width += val
        }
        
    default:()
    }
    
    gesture.setTranslation(CGPoint.zero, in: self)
    updateDragHandles()
    if gesture.state == .ended {
      self.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
    }
        }
  }
   
    
}
extension UITextView {
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
}
//extension UITextView {
//    func adjustUITextViewHeight() {
//        self.translatesAutoresizingMaskIntoConstraints = true
//        self.sizeToFit()
//        self.isScrollEnabled = false
//    }
//}
