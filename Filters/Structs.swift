//
//  File.swift
//  AsafVideoIMG
//
//  Created by Mobile on 22/08/22.
//

import Foundation
import MetalPetal
import UIKit

struct DemoImages {
    
    private static let namedCGImageCache = NSCache<NSString, CGImage>()
    
    static func cgImage(named name: String) -> CGImage! {
        if let image = namedCGImageCache.object(forKey: name as NSString) {
            return image
        }
        let url = Bundle.main.url(forResource: name, withExtension: nil)!
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil), let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) {
            namedCGImageCache.setObject(image, forKey: name as NSString)
            return image
        }
        return nil
    }
    static let transParent = MTIImage(contentsOf: Bundle.main.url(forResource: "Trans", withExtension: "png")!, isOpaque: true)!
    
    
    static func makeSymbolImage(named name: String, aspectFitIn size: CGSize, padding: CGFloat = 0) -> MTIImage {
        #if os(iOS)
        guard let cgImage = UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize:  min(size.width, size.height), weight: .medium))?.cgImage else {
            fatalError()
        }
        #elseif os(macOS)
        guard let cgImage = NSImage(systemSymbolName: name, accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: min(size.width, size.height), weight: .medium))?.cgImage(forProposedRect: nil, context: nil, hints: [:]) else {
            fatalError()
        }
        #else
        #error("Unsupported Platform")
        #endif
        
        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            fatalError()
        }
        context.draw(cgImage, in: MTIMakeRect(aspectRatio: CGSize(width: cgImage.width, height: cgImage.height), insideRect: CGRect(origin: .zero, size: size).insetBy(dx: padding, dy: padding)))
        guard let image = context.makeImage() else {
            fatalError()
        }
        return MTIImage(cgImage: image, isOpaque: false)
    }
    
    static func makeSymbolAlphaMaskImage(named name: String, aspectFitIn size: CGSize, padding: CGFloat = 0) -> MTIImage {
        #if os(iOS)
        guard let cgImage = UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize:  min(size.width, size.height), weight: .medium))?.cgImage else {
            fatalError()
        }
        #elseif os(macOS)
        guard let cgImage = NSImage(systemSymbolName: name, accessibilityDescription: nil)?.withSymbolConfiguration(NSImage.SymbolConfiguration(pointSize: min(size.width, size.height), weight: .medium))?.cgImage(forProposedRect: nil, context: nil, hints: [:]) else {
            fatalError()
        }
        #else
        #error("Unsupported Platform")
        #endif
        
        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            fatalError()
        }
        context.draw(cgImage, in: MTIMakeRect(aspectRatio: CGSize(width: cgImage.width, height: cgImage.height), insideRect: CGRect(origin: .zero, size: size).insetBy(dx: padding, dy: padding)))
        guard let maskImage = context.makeImage() else {
            fatalError()
        }
        context.setFillColor(CGColor(gray: 0, alpha: 1))
        context.fill(CGRect(origin: .zero, size: size))
        context.clip(to: CGRect(origin: .zero, size: size), mask: maskImage)
        context.setFillColor(CGColor(gray: 1, alpha: 1))
        context.fill(CGRect(origin: .zero, size: size))

        guard let image = context.makeImage() else {
            fatalError()
        }
        return MTIImage(cgImage: image, isOpaque: true)
    }
    
    static func makeTransparent(mask: UIImage) -> UIImage {
        let ciMask = CIImage(cgImage: mask.cgImage!)
        let mtiImage = MTIImage(ciImage: ciMask, isOpaque: true)

        let contextOptions = MTIContextOptions()
        let context = try! MTIContext(device: MTLCreateSystemDefaultDevice()!, options: contextOptions)

        let opacityFilter = MTIChromaKeyBlendFilter()
        opacityFilter.inputImage = mtiImage
        opacityFilter.inputBackgroundImage = MTIImage(color: MTIColor.clear, sRGB: true, size: mask.size)
        opacityFilter.color = MTIColor.black

        let outputImage = try! context.makeCGImage(from: opacityFilter.outputImage!)
        return UIImage(cgImage: outputImage)
    }
    static func converterMTtoUI(img:MTIImage,render:MTIContext) -> MTIImage?{
        let cgImg = try! render.makeCGImage(from: img)
        guard let uiImage = UIImage(cgImage: cgImg).removeBackground(returnResult: .background) else{ return nil}
        let mtimage = MTIImage(image: uiImage)
        return mtimage
    }
   static func adjustAssetSize(size:CGSize?) -> CGSize?{
        guard let siz = size else {return nil}
        if siz.width > 2160 || siz.height > 2160 {
           return CGSize(width: 2160, height: 2160)
        }
        else{
            return siz
        }
        }
    
    static func convertUiToMti(image:UIImage?,isOpaque:Bool = true) -> MTIImage?{
        guard let uiImg = image else {return nil}
        guard let ciImg = CIImage(image: uiImg)else {return nil}
          let mtLookUp = MTIImage(ciImage: ciImg, isOpaque: isOpaque)
               return mtLookUp
            
        }
  
            
    static func splitImageVersionLeftRight(processingImage image: MTIImage) -> MTIImage? {
        let context = LocalStore.instance.renderContext
          let cg = try! context.makeCGImage(from: image)
        let ciImageCopy = CIImage(cgImage: cg)
                // Image size
                let imageSize = ciImageCopy.extent.size
                // Right half
                let rightHalfRect = CGRect(
                    origin: CGPoint(
                        x: imageSize.width - (imageSize.width/2).rounded(),
                        y: 0
                    ),
                    size: CGSize(
                        width: imageSize.width - (imageSize.width/2).rounded(),
                        height: imageSize.height
                    )
                )
                // Split image into two parts
                let ciRightHalf = ciImageCopy.cropped(to: rightHalfRect)
                // Make transform to move right part to left
                let transform = CGAffineTransform(translationX: -rightHalfRect.size.width, y: -rightHalfRect.origin.y)
                // Create left part and apply transform then flip it
        let ciLeftHalf = ciRightHalf.transformed(by: transform).oriented(.upMirrored)
                // Merge two images into one
        let finlmerge = ciLeftHalf.composited(over: ciRightHalf)
                return MTIImage(ciImage: finlmerge)
           }
        
    static func splitImageVersionUpDown(processingImage image: MTIImage) -> MTIImage? {
        let context = LocalStore.instance.renderContext
        let cg = try! context.makeCGImage(from: image)
      let ciImageCopy = CIImage(cgImage: cg)
//         let ciImageCopy = try! render.makeCIImage(from: image)
               // Image size
               let imageSize = ciImageCopy.extent.size
               // Right half
               let upHalfRect = CGRect(
                   origin: CGPoint(
                       x: 0,
                       y: imageSize.height - (imageSize.height/2).rounded()
                   ),
                   size: CGSize(
                       width: imageSize.width,
                       height: imageSize.height - (imageSize.height/2).rounded()
                   )
               )
               // Split image into two parts
               let ciUpHalf = ciImageCopy.cropped(to: upHalfRect)
               // Make transform to move right part to left
               let transform = CGAffineTransform(translationX: -upHalfRect.origin.x, y: -upHalfRect.size.height)
               // Create left part and apply transform then flip it
        let ciDownHalf = ciUpHalf.transformed(by: transform).oriented(.downMirrored)
        
               // Merge two images into one
         let finlmerge = ciUpHalf.composited(over: ciDownHalf)
                 return MTIImage(ciImage: finlmerge)
          }
    
    
}

struct RGUVGradientImage {
    private static let kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: .passthroughVertex, fragmentFunctionDescriptor: MTIFunctionDescriptor(name: "rgUVGradient", in: .main))
    static func makeImage(size: CGSize) -> MTIImage {
        kernel.makeImage(dimensions: MTITextureDimensions(cgSize: size))
    }
}

struct RGUVB1GradientImage {
    private static let kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: .passthroughVertex, fragmentFunctionDescriptor: MTIFunctionDescriptor(name: "rgUVB1Gradient", in: Bundle.main))
    static func makeImage(size: CGSize) -> MTIImage {
        kernel.makeImage(dimensions: MTITextureDimensions(cgSize: size))
    }
    static func makeCGImage(size: CGSize) -> CGImage {
        let context = try! MTIContext(device: MTLCreateSystemDefaultDevice()!)
        return try! context.makeCGImage(from: self.makeImage(size: size))
    }
}

struct RadialGradientImage {
    private static let kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: .passthroughVertex, fragmentFunctionDescriptor: MTIFunctionDescriptor(name: "radialGradient", in: Bundle.main))
    static func makeImage(size: CGSize) -> MTIImage {
        kernel.makeImage(dimensions: MTITextureDimensions(cgSize: size))
    }
}

struct ImageUtilities {
    static func loadUserPickedImage(from url: URL, requiresUnpremultipliedAlpha: Bool) -> MTIImage? {
        if var image = MTIImage(contentsOf: url, isOpaque: false) {
            if image.size.width > 2160 || image.size.height > 2160 {
                image = image.resized(to: CGSize(width: 2160, height: 2160), resizingMode: .aspect) ?? image
            }
            if requiresUnpremultipliedAlpha {
                image = image.unpremultiplyingAlpha()
            }
            image = image.withCachePolicy(.persistent)
            return image
        }
        return nil
    }
 
}

struct VideoMethods{
    static func overlayWithMTImg(_ img1Mt:MTIImage, with img2Mt:MTIImage, scaling: Double, alpha: Double) -> MTIImage? {
    let img1 = img1Mt
    let img2 = img2Mt
    
    //         var lyrs = [MTILayer]()
    // Watermark Layer
    let aspectWatermark = Double(img2Mt.size.height) / Double(img2Mt.size.width)
    let watermarkWidth = Int(Double(img1Mt.size.width) * scaling)
    let watermarkHeight = Int(scaling * Double(img1Mt.size.width) * Double(aspectWatermark))
    
    let layer = MTILayer(content: img2, layoutUnit: .pixel, position: CGPoint(x: img1Mt.size.width / 2, y: img1Mt.size.height / 2), size: CGSize(width: watermarkWidth, height: watermarkHeight), rotation: 0, opacity: Float(alpha), blendMode: .normal)
    if Compositions.isLayerContinueAdded{
        Compositions.compoLayers = layer
    }
    let filter = MTIMultilayerCompositingFilter()
    filter.inputBackgroundImage = img1
    if let layer = Compositions.compoLayers{
        filter.layers = [layer]
    }
    else {filter.layers = []}
    guard let image = filter.outputImage else { return nil }
    return image
}
    
}


//MARK: - Not in use only For Practice
