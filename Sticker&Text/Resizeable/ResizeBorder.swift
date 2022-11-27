//
//  ResizeBorder.swift
//  Resizable
//
//  Created by Adil Soomro on 7/02/2017.
//  Copyright (c) 2017 BooleanBites Ltd. All rights reserved.
//



import UIKit

let dash1: CGFloat = 0.0
let dash2: CGFloat = 3.0

let lineWidth: CGFloat = 20

let dash:[CGFloat] = [dash1, dash2]

class ResizeBorder: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    
//    override func draw(_ rect: CGRect) {
//      // 1
//      guard let context = UIGraphicsGetCurrentContext() else {
//        return
//      }
//      // 2
//        context.setLineWidth(5)
//      context.setFillColor(UIColor.clear.cgColor)
//        context.stroke(self.bounds)
//        context.setStrokeColor(UIColor.lightGray .cgColor)
//
//      // 3
//      context.fill(bounds)
//    }

    
    override func draw(_ rect: CGRect)
    {
        
    
        let context = UIGraphicsGetCurrentContext();
//        context!.saveGState();
        
//        context!.setLineWidth(lineWidth);
        
        let bnd = self.bounds
//        context?.move(to: CGPoint(x: bnd.minX + 2, y: bnd.minY))
        
        context?.setStrokeColor(UIColor.darkGray.cgColor)
        context?.setLineWidth(3)
        
//        context?.beginPath()
        let pt1 = CGPoint(x: bnd.minX, y: bnd.minY)
        let pt2 = CGPoint(x: bnd.maxX , y: bnd.minY)
        let pt3 = CGPoint(x: bnd.maxX , y: bnd.maxY )
        let pt4 = CGPoint(x: bnd.maxX, y: bnd.maxY)
        let pt5 = CGPoint(x: bnd.minX, y: bnd.maxY)
        let pt6 = CGPoint(x: bnd.minX, y: bnd.minY)
       context?.addLines(between: [pt1,pt2,pt3,pt4,pt5,pt6])
        
//        context?.setLineJoin(.bevel)
//        context?.setLineCap(.round)


//        context?.stroke(bounds)

//
//           context?.beginPath()
//           context?.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
//        context?.closePath()
//           context?.addLine(to: pt1)
//           context?.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
//           context?.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
//           context?.strokePath()
        
        
        
//        context?.setLineDash(phase: 0.0, lengths: dash)
        
//        context!.setStrokeColor(UIColor.black.cgColor);
//        context!.addRect(self.bounds);
//        context!.strokePath();
        context?.strokePath()
        context!.restoreGState();
    }

   
}
