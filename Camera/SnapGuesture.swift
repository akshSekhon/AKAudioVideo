//
//  SnapGuesture.swift
//  TapGuesturePractice
//
//  Created by Mobile on 04/08/22.
//

import Foundation
import UIKit



/// Class for panGesture,panGesture and rotationGesture the view
class SnapGesture: NSObject, UIGestureRecognizerDelegate {
    
    // MARK: - init and deinit
    
    
    convenience init(view: UIView) {
        self.init(transformView: view, gestureView: view)
//        HLabel.frame = CGRect(origin: baseView.center, size: CGSize(width: 2, height: baseView.frame.height))
//        vLabel.frame = CGRect(origin: baseView.center, size: CGSize(width:  baseView.frame.width, height: 2))
//        baseView.addSubviews(vLabel,HLabel)
    }
    init(transformView: UIView, gestureView: UIView) {
        super.init()
        
        self.addGestures(v: gestureView)
        
        self.weakTransformView = transformView
    }
    deinit {
        self.cleanGesture()
    }
    
    // MARK: - private method
    private weak var weakGestureView: UIView?
    private weak var weakTransformView: UIView?
    
    private var panGesture: UIPanGestureRecognizer?
    private var pinchGesture: UIPinchGestureRecognizer?
    private var rotationGesture: UIRotationGestureRecognizer?
    private var longPressGesture: UILongPressGestureRecognizer?
    var rotation:Float = 0
    
    var vLabel:UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .cyan
        lbl.isHidden = true
        return lbl
    }()
    var HLabel:UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .cyan
        lbl.isHidden = true
        return lbl
    }()
    
    
    
    private func addGestures(v: UIView) {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panProcess(_:)))
        v.isUserInteractionEnabled = true
        
        panGesture?.delegate = self     // for simultaneous recog
        v.addGestureRecognizer(panGesture!)
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchProcess(_:)))
        //view.isUserInteractionEnabled = true
        pinchGesture?.delegate = self   // for simultaneous recog
        v.addGestureRecognizer(pinchGesture!)
        
        rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotationProcess(_:)))
        rotationGesture?.delegate = self
        v.addGestureRecognizer(rotationGesture!)
        
        self.weakGestureView = v
    }
    
    private func cleanGesture() {
        if let view = self.weakGestureView {
            //for recognizer in view.gestureRecognizers ?? [] {
            //    view.removeGestureRecognizer(recognizer)
            //}
            if panGesture != nil {
                view.removeGestureRecognizer(panGesture!)
                panGesture = nil
            }
            if pinchGesture != nil {
                view.removeGestureRecognizer(pinchGesture!)
                pinchGesture = nil
            }
            if rotationGesture != nil {
                view.removeGestureRecognizer(rotationGesture!)
                rotationGesture = nil
            }
        }
        self.weakGestureView = nil
        self.weakTransformView = nil
    }
    
    // MARK: - API
    
    private func setView(view:UIView?) {
        self.setTransformView(view, gestgureView: view)
    }
    
    private func setTransformView(_ transformView: UIView?, gestgureView:UIView?) {
        self.cleanGesture()
        
        if let v = gestgureView  {
            self.addGestures(v: v)
        }
        self.weakTransformView = transformView
    }
    
    open func resetViewPosition() {
        UIView.animate(withDuration: 0.4) {
            self.weakTransformView?.transform = CGAffineTransform.identity
        }
    }
    
    open var isGestureEnabled = true
    
    // MARK: - gesture handle
    
    // location will jump when finger number change
    private var initPanFingerNumber:Int = 1
    private var isPanFingerNumberChangedInThisSession = false
     var lastPanPoint:CGPoint = CGPoint(x: 0, y: 0)
    @objc func panProcess(_ recognizer:UIPanGestureRecognizer) {
        if isGestureEnabled {
            //guard let view = recognizer.view else { return }
            guard let view = self.weakTransformView else { return }
            // init
            if recognizer.state == .began {
                lastPanPoint = recognizer.location(in: view)
                initPanFingerNumber = recognizer.numberOfTouches
                isPanFingerNumberChangedInThisSession = false
                print("view.frame is",view.frame)
                print("view layer frame is",view.layer.frame)
//                delegate?.updateRecogniser(recognizer: recognizer)
            }
            
            if recognizer.state == .changed {
              
                
                
            }
            
            // judge valid
            if recognizer.numberOfTouches != initPanFingerNumber {
                isPanFingerNumberChangedInThisSession = true
                print("view.frame is",view.frame)
                print("view layer frame is",view.layer.frame)
                
            }
            if isPanFingerNumberChangedInThisSession {
                return
            }
            if recognizer.state == .ended {
                vLabel.isHidden = true
                HLabel.isHidden = true
            }
            // perform change
            let point = recognizer.location(in: view)
            view.transform = view.transform.translatedBy(x: point.x - lastPanPoint.x, y: point.y - lastPanPoint.y)
//            view.frame.origin = recognizer.location(in: view)
            lastPanPoint = recognizer.location(in: view)
        }
    }
    
    
    
    private var lastScale:CGFloat = 1.0
    private var lastPinchPoint:CGPoint = CGPoint(x: 0, y: 0)
    @objc func pinchProcess(_ recognizer:UIPinchGestureRecognizer) {
        if isGestureEnabled {
            guard let view = self.weakTransformView else { return }
            
            // init
            if recognizer.state == .began {
                lastScale = 1.0;
                lastPinchPoint = recognizer.location(in: view)
                print("\(view) frame is",view.frame)
            }
            
            // judge valid
            if recognizer.numberOfTouches < 2 {
                lastPinchPoint = recognizer.location(in: view)
                print("\(view)frame is",view.frame)
                return
            }
            
            // Scale
            let scale = 1.0 - (lastScale - recognizer.scale);
            view.transform = view.transform.scaledBy(x: scale, y: scale)
            lastScale = recognizer.scale;
            print("\(view)transform is",view.transform)
            view.updateScale(forZoomScale: lastScale)
            // Translate
            let point = recognizer.location(in: view)
            view.transform = view.transform.translatedBy(x: point.x - lastPinchPoint.x, y: point.y - lastPinchPoint.y)
            //            lastPinchPoint = recognizer.location(in: view)
            
        }
    }
    
    
    @objc func rotationProcess(_ recognizer: UIRotationGestureRecognizer) {
        if isGestureEnabled {
            guard let view = self.weakTransformView else { return }
            
            view.transform = view.transform.rotated(by: recognizer.rotation)
            self.rotation = Float(recognizer.rotation)
            recognizer.rotation = 0
            print("\(view) transform is ",view.transform3D )
        }
    }
    
    
    
    //MARK:- UIGestureRecognizerDelegate Methods
    func gestureRecognizer(_: UIGestureRecognizer,shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        
        return true
    }

  
    
    
}
