//
//  FilterImage.swift
//  AsafVideoIMG
//
//  Created by Mobile on 22/09/22.
//

import Foundation
import UIKit
import MetalPetal
import VideoIO
import ProgressHUD
class FilterImage: NSObject{
    
 static let shared = FilterImage()
    var multiLayerFilter:MTIMultilayerCompositingFilter!
    var isApplyFilter = false
    var filterAdded = false
    var filterType : VideoEffect?
    var currentWorkFor:GrandCollectnWork?
    var selectedColorFilter:ColorFilterEnum?
    var selectedArtFilter:ArtFilterEnum?
    var selectedMirrorFilter:MirrorEnum?
    var selectedFilmFilter:FilmFilterEnum?
    var selectedBlurFilter:BlurFilterEnum?
    var blendMode:MTIBlendMode? = .linearBurn
    var blendOverImage:MTIImage?
    var blurMaskImg:UIImage?
    var overlayIntensity:Float?
    var brightness:Float?
    var exportProgress:Progress?
     var exportSession: AssetExportSession?
    
    
    var filterdImage: MTIImage?{
        didSet{
//            multiLayerFilter?.inputBackgroundImage = filterdImage
//            self.updateMultiBgImg()
        }
    }
     var orignalImage:MTIImage?{
        didSet{
            updateFilter()
//            self.updateMultiBgImg()
        }
    }
    
    
    override init() {
        super.init()
        multiLayerFilter = MTIMultilayerCompositingFilter()
        self.updateMultiBgImg()
    }
    
    func updateMultiBgImg(){
        if let filterImg = filterdImage{
            multiLayerFilter.inputBackgroundImage = filterImg
        }else{
            guard let oriImg = orignalImage else{return}
            multiLayerFilter.inputBackgroundImage = oriImg
        }
    }
    
    func updateFilter(){
        switch currentWorkFor {
        case .filter:
              caseFilter()
            FilterImage.shared.isApplyFilter = true
        case .overlay:
            self.filterdImage = self.makeOverlayFilterImage()
            FilterImage.shared.isApplyFilter = true
            filterAdded = true
        case .focus:
            self.filterdImage = self.selectedBlurFilter?.makeBlurFilterImage()
            FilterImage.shared.isApplyFilter = true
            filterAdded = true
            print("selected type is focus")
        case .music:
            print("selected type is music")
        case .sticker:
            print("selected type is sticker")
        case .text:
            print("selected type is text")
        default:
            break
//        case .none:
//            print("selected type is none")
        }
    }
    
    
   private func caseFilter(){
        switch filterType {
        case .Orignal:
            self.filterdImage = self.orignalImage
            filterAdded = false
        case .Colors:
            self.filterdImage = self.selectedColorFilter?.currentColorFilterImage()
            filterAdded = true
//            multiLayerFilter.inputBackgroundImage = filterdImage
        case .Art:
            self.filterdImage = self.selectedArtFilter?.makeArtFilter()
            filterAdded = true
        case .Film:
            self.filterdImage = self.selectedFilmFilter?.currentFilmFilterImage()
            filterAdded = true
        case .Mirror:
            self.filterdImage = self.selectedMirrorFilter?.makeMirrorEffect()
            filterAdded = true
        default:
            break
        }
//       multiLayerFilter.inputBackgroundImage = filterdImage
    }
    
     
//MARK: -- Color Image Filter
  func makeColorsImage() -> MTIImage?{
        let lut = MTIColorLookupFilter()
      guard let uiImg = GlobalStruct.ColorLookUp else { return nil}
      guard let MtImg = DemoImages.convertUiToMti(image: uiImg) else { return nil}
          lut.inputColorLookupTable = MtImg//MTIImage(ciImage: ciImg)
      
      guard let inputImage = self.orignalImage else {return nil }
      lut.inputImage = inputImage
//      guard let outPutImage = lut.outputImage else {return nil }
     
     
    guard let outPutImage = FilterGraph.makeImage(builder: { output in
                inputImage => lut.inputPorts.inputImage
                lut => output
    }) else {return nil }
       self.filterdImage = outPutImage
      
//      if let mtLayerImg = multiLayerFilter.outputImage{
//          return mtLayerImg
//      }else
//      {
          return outPutImage
//      }
      
            
        }
    //MARK: -- Overlay Image Filter
    func makeOverlayFilterImage() -> MTIImage?{
        guard let bledMode = FilterImage.shared.blendMode else {return nil}
        let blendFilter = MTIBlendFilter(blendMode: bledMode)
        blendFilter.intensity = ((overlayIntensity ?? 50)/100) //Compositions.sliderValue / 100
        blendFilter.inputBackgroundImage = self.orignalImage
        
        guard let inputImage = self.orignalImage else {return nil }
        blendFilter.inputImage =  self.blendOverImage
//        self.blendOverImage//RGUVGradientImage.makeImage(size: CGSize(width: 1280, height: 720))
        
        guard let outPutImage = FilterGraph.makeImage(builder: { output in
            inputImage => blendFilter.inputPorts.inputBackgroundImage
            blendFilter => output
        }) else {return nil }
        self.filterdImage = outPutImage
        //     return outPutImage
//        if let mtLayerImg = multiLayerFilter.outputImage{
//            return mtLayerImg
//        }else
//        {
            return outPutImage
//        }
        
         }
    
    
    func export(_ videoAsset:AVAsset?,_ videoComposition:MTIVideoComposition?,_ completion: @escaping (Result<URL, Error>) -> Void) {
        guard let asset = videoAsset, let videoComposition = videoComposition else {
            return
        }
        exportProgress = nil
        exportSession?.cancel()
        exportSession = nil
        var configuration = AssetExportSession.Configuration(fileType: .mp4, videoSettings: .h264(videoSize: videoComposition.renderSize), audioSettings: .aac(channels: 2, sampleRate: 44100, bitRate: 128 * 1000))
        configuration.videoComposition = videoComposition.makeAVVideoComposition()
        
        let fileManager = FileManager()
        let outputURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(".mp4")
//        URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.mp4")
//        try? fileManager.removeItem(at: outputURL)
//        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4")
//        try? fileManager.removeItem(at: outputURL)
        
        do {
            let exportSession = try AssetExportSession(asset: asset, outputURL: outputURL, configuration: configuration)
            exportSession.export(progress: { [weak self] progress in
                
                self?.exportProgress = progress
                let value = self!.exportProgress!.fractionCompleted
                ProgressHUD.showProgress(value)
                print("progress value is ",value)
                print(progress)
                
                
            }, completion: { [weak self] error in
                self?.exportProgress = nil
                self?.exportSession = nil
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(outputURL))
                }
            })
            self.exportSession = exportSession
        } catch {
            completion(.failure(error))
        }
    }
    
}



class StickerClass: NSObject{
    static let shared = StickerClass()
    var imgCgPoint:CGPoint?
    var imgSize:CGSize?
    var imageAlpa:Double?
    var rotation:Float?
}
