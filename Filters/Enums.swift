//
//  Enums.swift
//  AsafVideoIMG
//
//  Created by Mobile on 15/09/22.
//

import Foundation
import MetalPetal
// -- Video Effect Enom
enum VideoEffect:String,CaseIterable{
    case Orignal = "Orignal"
    case Colors = "Colors"
    case Art = "Art"
    case Mirror = "Mirror"
    case Film = "Film"
    case Glitch = "Glitch"
    
}

enum CommonBtnsWorking:String,CaseIterable{
    case export = "Export"
    case filters = "Filters"
    case stickers = "Stickers"
    case text = "Text"
    case focus = "Focus"
    case overlay = "Overlay"
    case textOptions = "textOptions"
    case colorPicker = "ColorPicker"
    case fontPicker = "FontPicker"
    case textAlingnment = "textAlingnment"
   
    
}



// --- Mirror Effect Enum 
enum VideoMirrorEffect:String, CaseIterable {
    case leftRigh = "LeftRight"
    case upDown = "UpDown"
}
// --- Art Effect Enum
enum VideoArtEffect:String,CaseIterable{
    case HeatMap = "Heat Map"
    case Hyla = "Hyla"
    case ColorInver = "ColorInvert"
}
enum TextFilterOptions:String,CaseIterable{
    case font = "Font"
    case color = "Color"
    case bgColor = "BG Color"
    case alignment = "Alignment"
}


enum GrandCollectnWork:String,CaseIterable{
case filter = "filter"
case overlay = "overlay"
case focus = "focus"
case music = "music"
case sticker = "sticker"
case text = "text"

}



enum ColorFilterEnum:String,CaseIterable{
    case Polaroid = "Polaroid"
    case Poloroid690 = "Poloroid690"
    case Sunny = "Sunny"
    case Lilac = "Lilac"
    case Vintage = "Vintage"
    case PinkLove = "PinkLove"
    case Japan = "Japan"
    case Glow = "Glow"
    case Paladin = "Paladin"
    
    
    func currentColorFilterImage() -> MTIImage?{
            let image = FilterImage.shared.makeColorsImage()
            return image
    }
    
}


enum ArtFilterEnum:String,CaseIterable{
    case HeatMap = "Heat Map"
    case Hyla = "Hyla"
    case ColorInver = "ColorInvert"
    
    func makeArtFilter() -> MTIImage?{
        switch self{
        case .HeatMap:
            guard let image = makeHeatmapEffect() else {return nil}
            return image
        case .Hyla:
            guard let image = makeHylaEffect() else {return nil}
            return image
        case .ColorInver:
            guard let image = makeColorInverEffect() else {return nil}
            return image
        }
    }
     private func makeHylaEffect() -> MTIImage?{
        GlobalStruct.ColorLookUp = UIImage(named: "Hyla")
        guard let image = FilterImage.shared.makeColorsImage() else {return nil}
        return image
    }
    
    private func makeColorInverEffect() -> MTIImage?{
       GlobalStruct.ColorLookUp = UIImage(named: "ColorInvert")
       guard let image = FilterImage.shared.makeColorsImage() else {return nil}
       return image
   }
    private func makeHeatmapEffect() -> MTIImage?{
        let ciFilter = MTICoreImageUnaryFilter()
        let thermal = CIFilter(name: "CIThermal")
        ciFilter.filter = thermal
        guard let inputImage = FilterImage.shared.orignalImage else {return nil }
        ciFilter.inputImage = inputImage
     //      guard let outPutImage = lut.outputImage else {return nil }
         guard let outPutImage = FilterGraph.makeImage(builder: { output in
                     inputImage => ciFilter => output
         }) else {return nil }
        FilterImage.shared.filterdImage = outPutImage
        
        if let mtLayerImg =  FilterImage.shared.multiLayerFilter.outputImage{
            return mtLayerImg
        }else
        {
            return outPutImage
        }
//                 return outPutImage
             }
}

enum MirrorEnum:String,CaseIterable{
    case leftRigh = "LeftRight"
    case upDown = "UpDown"
    
    func makeMirrorEffect() -> MTIImage?{
        switch self{
        case .leftRigh:
           guard  let splitImg = DemoImages.splitImageVersionLeftRight(processingImage: FilterImage.shared.orignalImage!) else
            {return nil}
            return splitImg
        case .upDown:
            guard let splitImg = DemoImages.splitImageVersionUpDown(processingImage: FilterImage.shared.orignalImage!) else
            {return nil}
            return splitImg
            
        }
    }
}

enum FilmFilterEnum:String,CaseIterable{
    case RetroFilm = "Retro Film"
    case VHS = "VHS"
    case DVCam = "DV Cam"
    
    func currentFilmFilterImage() -> MTIImage?{
//        switch self{
//        case .Polaroid,.Poloroid690,.Sunny,.Lilac,.Vintage,.PinkLove,.Japan,.Glow,.Paladin:
            let image = FilterImage.shared.makeColorsImage()
            return image
        }
    
}

    enum BlurFilterEnum:String,CaseIterable{
        case none = "none"
        case gaussian = "gaussian"
        case linear = "linear"
        case mirrored = "mirrored"
        case radial = "radial"
        
        func makeBlurFilterImage() -> MTIImage?{
//            let presentationSize = CGSize(width: 100, height: 100)
            //        blendFilter.intensity = Compositions.sliderValue / 100
            let myFilter = MTIHexagonalBokehBlurFilter()
            
            guard let inputImage = FilterImage.shared.orignalImage else {return nil }
//            let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
            
            /*   let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 50)
             let circle = UIBezierPath(ovalIn: rect)
             let image:UIImage = UIImage.imageByApplyingMaskingBezierPath(circle,rect, imgSize: inputImage.size)*/
            
            guard let uiImg = FilterImage.shared.blurMaskImg else {return FilterImage.shared.orignalImage}
            
            guard let maskImg = DemoImages.convertUiToMti(image: uiImg ) else {return nil}
            
            myFilter.inputImage = inputImage
            myFilter.radius = FilterImage.shared.overlayIntensity ?? 50//100 //Compositions.sliderValue
            myFilter.brightness = ((FilterImage.shared.brightness ?? 25) / 100)
            myFilter.inputMask = MTIMask(content: maskImg, component: .blue, mode: .oneMinusMaskValue)
            guard let outPutImage = myFilter.outputImage else {return nil}
            
            FilterImage.shared.filterdImage = outPutImage
            
//            if let mtLayerImg =  FilterImage.shared.multiLayerFilter.outputImage{
//                return mtLayerImg
//            }else
//            {
                return outPutImage
//            }
            //             return outPutImage
        }
        
    }
    
  /*  func demoBlur(){
        let renderContext = LocalStore.instance.renderContext
        let asset = AVURLAsset(url: URL(string: "")!)
        let presentationSize = CGSize(width: 1280, height: 1280)
        let cropFilter = MTICropFilter()
        let blurFilter = MTIMPSGaussianBlurFilter()
        blurFilter.radius = 50
        let multilayerCompositingFilter = MultilayerCompositingFilter()
        let videoComposition = MTIVideoComposition(asset: asset, context: renderContext, queue:
        DispatchQueue.main, filter: { request in
            cropFilter.cropRegion = .pixel(AVMakeRect(aspectRatio: presentationSize, insideRect:
                                                        request.anySourceImage!.extent))
            cropFilter.inputImage = request.anySourceImage
            let centerCroppedImage: MTIImage = cropFilter.outputImage!
            blurFilter.inputImage = centerCroppedImage
            multilayerCompositingFilter.inputBackgroundImage = blurFilter.outputImage!
            multilayerCompositingFilter.layers = [MultilayerCompositingFilter.Layer(content:
                                                                                        request.anySourceImage!).frame(AVMakeRect(aspectRatio: request.anySourceImage!.size,
        insideRect: CGRect(origin: .zero, size: centerCroppedImage.size)), layoutUnit: .pixel)]
            return multilayerCompositingFilter.outputImage!
        })
        videoComposition.renderSize = presentationSize
//        let playerItem = AVPlayerItem(url: url)
//        playerItem.videoComposition = videoComposition.makeAVVideoComposition()
//        self.videoPlayer = AVPlayer(playerItem: playerItem)
//        self.videoPlayer?.play()
    }*/
        
//    }
    


extension UIImage {

    class func imageByApplyingMaskingBezierPath(_ path: UIBezierPath, _ pathFrame: CGRect,imgSize: CGSize) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(imgSize, false, 1)
//        let size = CGSize(width: path.bounds.width, height: path.bounds.height)
                UIGraphicsBeginImageContext(imgSize)
                let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
                context.addPath(path.cgPath)
                context.clip()

        context.setLineWidth(2)
        UIColor.clear.setStroke()
        UIColor.clear.setFill()
        context.drawPath(using: .fillStroke)
       
                let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        context.restoreGState()
                UIGraphicsEndImageContext()
//        let circle = maskedImage.circle(diameter: 10, color: .white, imgSize: imgSize)
                return maskedImage
            }
    func circle(diameter: CGFloat, color: UIColor,imgSize:CGSize) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size:imgSize)
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.clear.cgColor)
            ctx.cgContext.setLineWidth(0)
//            let rect = CGRect(origin: self.c, size: CGSize(width: 500, height: 500))
            let rectangle = CGRect(x: (imgSize.width / 2) - 400, y: (imgSize.height / 2) - 250, width: 1000, height: 1000)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        return img
    }

}


//class imageCrop:UIView{
//
//    var path = UIBezierPath()
//    var shapeLayer = CAShapeLayer()
//    var cropImage = UIImage()
//let YourimageView = UIImageView()
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//       if let touch = touches.first as UITouch?{
//           let touchPoint = touch.location(in: self.YourimageView)
//           print("touch begin to : \(touchPoint)")
//           path.move(to: touchPoint)
//       }
//   }
//
//   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//       if let touch = touches.first as UITouch?{
//           let touchPoint = touch.location(in: self.YourimageView)
//           print("touch moved to : \(touchPoint)")
//           path.addLine(to: touchPoint)
//           addNewPathToImage()
//       }
//   }
//
//   override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//       if let touch = touches.first as UITouch?{
//           let touchPoint = touch.location(in: self.YourimageView)
//           print("touch ended at : \(touchPoint)")
//           path.addLine(to: touchPoint)
//           addNewPathToImage()
//           path.close()
//       }
//   }
//    func addNewPathToImage(){
//       shapeLayer.path = path.cgPath
//        shapeLayer.strokeColor = UIColor.clear.cgColor
//       shapeLayer.fillColor = UIColor.white.cgColor
//       shapeLayer.lineWidth = 1
//       YourimageView.layer.addSublayer(shapeLayer)
//   }
//      func cropImage(){
//
//       UIGraphicsBeginImageContextWithOptions(YourimageView.bounds.size, false, 1)
//       tempImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
//       let newImage = UIGraphicsGetImageFromCurrentImageContext()
//       UIGraphicsEndImageContext()
//       self.cropImage = newImage!
//       }
//
//
//}
