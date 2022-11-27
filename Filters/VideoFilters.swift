//
//  VideoFilters.swift
//  AsafVideoIMG
//
//  Created by Mobile on 22/08/22.
//

import MetalPetal
import Foundation
import VideoToolbox
import UIKit
import AVFoundation


//MARK: - Compostion Makeing Methods
struct Compositions{
    static var sliderValue:Float = 100{
        didSet{
            print("slider value updade is =-=-=-=-=- ",sliderValue/100)
        }
    }
    
    static var blendOverLayImage:MTIImage?
    private static var filterinputImage:MTIImage?
    private static var filterOutputImage:MTIImage?
    private static var filterBackgroungImage:MTIImage?
    private static var sourceImage:MTIImage?
    static var isLayerContinueAdded:Bool = true
    
    
//    static var isApplyFilter:Bool = false
    static var addOverly:Bool = true
    static var compoLayers:MTILayer?
    static var overlayImg:MTIImage?
    
    // MARK: --- Current Working Method
    static func DemoFilter(asset :AVAsset,render:MTIContext) -> MTIVideoComposition?{ //    --- MPSDefinitionFilter
        FilterImage.shared.isApplyFilter = true
        FilterImage.shared.filterdImage = nil
         let img = UIImage(named: "stick1")
//        Compositions.overlayImg = DemoImages.convertUiToMti(image: img)
        
        let composition = MTIVideoComposition(asset: asset, context: render, queue: DispatchQueue.main, filter: { request in
            guard let sourceImage = request.anySourceImage else {
                return MTIImage.transparent
            }
            FilterImage.shared.orignalImage = sourceImage
            if FilterImage.shared.isApplyFilter{
//                =--=-=-=-=-=-=-=-=
//                guard let imageFilter = FilterImage.shared.filterdImage else {
//                    return sourceImage
//                }
                
//                let output = overlayWithMTImg(imageFilter, with: Compositions.overlayImg ?? nil, scaling: 1, alpha: 1)
                if  FilterImage.shared.filterAdded{
                    FilterImage.shared.multiLayerFilter!.inputBackgroundImage = FilterImage.shared.filterdImage
                }else{
                    FilterImage.shared.multiLayerFilter!.inputBackgroundImage = FilterImage.shared.orignalImage
                }
                
                if let layerOut = FilterImage.shared.multiLayerFilter.outputImage{
                    return layerOut
                }
                else if let imageFilter = FilterImage.shared.filterdImage{
                    return imageFilter
                }
                else
                {
                    return sourceImage
                }
//                return output!
//                =-==-=-=-=-=-=-=-=-=-=-=
            }
            else{
                
                guard let imageOri = FilterImage.shared.orignalImage else {
                    return sourceImage
                }
                return imageOri
            }
        })
        return composition
    }
    
   static func assetToComposition(asset:AVAsset?) -> AVMutableComposition?{
        guard let asset = asset else {return nil}
        var selectedVideoLevel:Float = 1.0
        
       let audiPath = Bundle.main.path(forResource: "audio", ofType: "mp3")!
       let audiourl = NSURL(fileURLWithPath: audiPath) as URL
       
       let musicAsset = AVAsset(url:audiourl)// musicUrl

       let mainInstruction = AVMutableVideoCompositionInstruction()
       
        let audioVideoComposition = AVMutableComposition()

        let audioMix = AVMutableAudioMix()
        var mixParameters = [AVMutableAudioMixInputParameters]()
        
        
        let videoCompositionTrack = audioVideoComposition
          .addMutableTrack(withMediaType: .video, preferredTrackID: .init())!

        let audioCompositionTrack = audioVideoComposition
          .addMutableTrack(withMediaType: .audio, preferredTrackID: .init())!
       
       let musicCompositionTrack = audioVideoComposition
         .addMutableTrack(withMediaType: .audio, preferredTrackID: .init())!


        let videoAssetTrack = asset.tracks(withMediaType: .video)[0]
        let audioAssetTrack = asset.tracks(withMediaType: .audio).first
       let musicAssetTrack = musicAsset.tracks(withMediaType: .audio)[0]
      
       
        let audioParameters = AVMutableAudioMixInputParameters(track: audioAssetTrack)
        audioParameters.trackID = audioCompositionTrack.trackID
       
       let musicParameters = AVMutableAudioMixInputParameters(track: musicAssetTrack)
       musicParameters.trackID = musicCompositionTrack.trackID
       
       
       
        audioParameters.setVolume(selectedVideoLevel, at: .zero)
       musicParameters.setVolume(selectedVideoLevel, at: .zero)
       
        mixParameters.append(audioParameters)
       mixParameters.append(musicParameters)
       
        audioMix.inputParameters = mixParameters
      
       
       
        videoCompositionTrack.preferredTransform = videoAssetTrack.preferredTransform
        
        do {
          let timeRange = CMTimeRange(start: .zero, duration: asset.duration)

          try videoCompositionTrack.insertTimeRange(timeRange, of: videoAssetTrack, at: .zero)

          if let audioAssetTrack = audioAssetTrack {
            try audioCompositionTrack.insertTimeRange(timeRange, of: audioAssetTrack, at: .zero)
          }
            try musicCompositionTrack.insertTimeRange(timeRange, of: musicAssetTrack, at: .zero)
            
        } catch {
           
            LineDebugger.line("\(error)")
        }
        
        return audioVideoComposition
    }
}

class CompoObject{
    var asset: AVAsset?
    var type : AVMediaType?
    var startAt:CMTime?
    var endAt:CMTime?
    var position:Int?
}
