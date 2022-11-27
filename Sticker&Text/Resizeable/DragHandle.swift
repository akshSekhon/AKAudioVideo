//
//  DragHandle.swift
//  Resizable
//
//  Created by Caroline on 7/09/2014.
//  Copyright (c) 2014 Caroline. All rights reserved.
//



import UIKit

class DragHandle: UIView {
static let diameter:CGFloat = 40
  var fillColor = UIColor.darkGray
  var strokeColor = UIColor.lightGray
  var strokeWidth:CGFloat = 2.0
  
  required init(coder aDecoder: NSCoder) {
    fatalError("Use init(fillColor:, strokeColor:)")
  }
  
  init(fillColor:UIColor, strokeColor:UIColor, strokeWidth width:CGFloat = 2.0) {
      super.init(frame:CGRect(x: 0, y: 0, width: DragHandle.diameter, height: DragHandle.diameter))
    self.fillColor = fillColor
    self.strokeColor = strokeColor
    self.strokeWidth = width
    self.backgroundColor = UIColor.clear
  }
  
    override func draw(_ rect: CGRect)
    {
      super.draw(rect)
      let handlePath = UIBezierPath(ovalIn: rect.insetBy(dx: 12 + strokeWidth, dy: 12 + strokeWidth))
//        let handlePath = UIBezierPath(rect: rect.insetBy(dx: 2.0, dy: 50))
      fillColor.setFill()
      handlePath.fill()
      strokeColor.setStroke()
      handlePath.lineWidth = strokeWidth
      handlePath.stroke()
    }
}
