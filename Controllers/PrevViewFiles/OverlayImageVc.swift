//
//  OverlayImageVc.swift
//  AsafVideoIMG
//
//  Created by Mobile on 22/09/22.
//


import Foundation
import UIKit
import MetalPetal
import Photos
import VideoIO



///////////////////////////////////
//MARK: FILE: OverlayImageViewController
//Use:
//Overlay image(s) over some video file.
//Though, not thoroughly tested for completeness
//but its a start for anyone looking to implement this feature
///////////////////////////////////
class OverlayImageViewController: UIViewController {
    
    //MARK: Class: ImageObject
    class ImageObjectDemo {
        var id: Int? // If required
        var used: Bool? = false
        var endAt: Double?
        var image: MTIImage?
        var size: CGSize?
        var xy: CGPoint?
        var positionInComposite: Int?
    }
    
    //MARK: Class: UsedImageObject
    class UsedImageObject {
        var id: Int? // If required
        var used: Bool? = false
        var positionInComposite: Int?
    }
    
    //MARK: Dictionary: imagesArray
    var imagesArray = [Double: ImageObjectDemo]()
    
    //MARK: Dictionary: useImagesArray
    var useImagesArray = [Double: UsedImageObject]()
    
    //MARK: weak variables
    private var bundle: Bundle? = nil
    private var asset: AVAsset?
    private var videoComposition: VideoComposition<BlockBasedVideoCompositor>?//VideoComposition<BlockBasedVideoCompositor>?
    private var context: MTIContext!
    private var compositeLayerFilter: MTIMultilayerCompositingFilter!
    private var exporter: AssetExportSession?
   
    //MARK: ui-container: bundle
    let containerView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        return v
    }()
    
    //MARK: Function: generateImageFromUIView
    //Use: Generate image from uiview
    fileprivate func generateImageFromUIView(_ view: UIView) -> UIImage {
        
        let opaque = false
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, opaque, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    //MARK: Function: roundedTimestamp
    //Use: Return a given number of decimal places (nodp)
    fileprivate func roundedTimestamp(timestamp: Double, nodp: Double) -> Double {

        let multiplier = pow(10.0, nodp)
        let num = timestamp
        let rounded = round(Double(num) * multiplier) / multiplier
        return rounded
    }
    
    //MARK: Function: createNewLayer
    //Use: Create and add MTILayer to MTIMultilayerCompositingFilter
    fileprivate func createNewLayer(image: String, xy: CGPoint, sz: CGFloat, beginAt: Double, endAt: Double) {
        let v = UIImageView(frame: CGRect(x: xy.x, y: xy.x, width: sz, height: sz))
        v.image = UIImage(named: image)

        self.containerView.addSubview(v)
        
        let imageOverlay = self.generateImageFromUIView(self.containerView)
        let ciImageOverlay = CIImage(cgImage: imageOverlay.cgImage!)
        let mtiImageOverlay = MTIImage(ciImage: ciImageOverlay, isOpaque: true) //720/2  1280/2
        
        let clayer = MTILayer(content: mtiImageOverlay, layoutUnit: .pixel, position: CGPoint(x: 720/2, y: 1280/2 ), size: CGSize(width: 720, height: 1280), rotation: 0, opacity: 0, blendMode: .normal)
        
        self.compositeLayerFilter.layers.append(clayer)
        
        //Get position for layer composite
        let pos = self.compositeLayerFilter.layers.count-1
        
        let oi = ImageObjectDemo()
        oi.id = 1
        oi.used = true
        oi.endAt = endAt
        oi.image = mtiImageOverlay
        oi.size = CGSize(width: 720, height: 1280)
        oi.xy = CGPoint(x: 720/2, y: 1280/2)
        oi.positionInComposite = pos
        
        self.imagesArray[beginAt] = oi
        
        self.containerView.subviews.forEach { $0.removeFromSuperview() }
    }

    //MARK: Function: createNewLayer
    //Use: Turn-on opacity for previously added MTILayer
    //Though, we have to create a new MTILayer given that
    //the opacity variable in the MTILayer class is readonly
    fileprivate func showLayerFilter(f: ImageObjectDemo) {
          let cl = MTILayer(content: f.image!, layoutUnit: .pixel, position: f.xy!, size: f.size!, rotation: 0, opacity: 1, blendMode: .normal)
          self.compositeLayerFilter.layers[f.positionInComposite!] = cl
        let count = self.compositeLayerFilter.layers.count
        LineDebugger.line("count: \(count) - ok")

    }
    
    //MARK: Function: hideLayerFilter
    //Use: Turn-off opacity for previously added MTILayer
    //Again, we have to create a new MTILayer given that
    //the opacity variable in the MTILayer class is readonly
    fileprivate func hideLayerFilter(positionInComposite: Int) {

        let cl = MTILayer(content: MTIImage.transparent, layoutUnit: .pixel, position: CGPoint(x:0, y:0), size: CGSize(width:0, height:0), rotation: 0, opacity: 0, blendMode: .normal)
        self.compositeLayerFilter.layers[positionInComposite] = cl
        let count = self.compositeLayerFilter.layers.count
        LineDebugger.line("count: \(count) - ok")

    }
    
    //MARK: Function: processAVAsset
    //Use: Converts individual video frames to metal textures,
    //and apply given filter(s)
    fileprivate func processAVAsset(asset: AVAsset) {
        
        self.context = try! MTIContext(device: MTLCreateSystemDefaultDevice()!)
        
        let handler = MTIAsyncVideoCompositionRequestHandler(context: context, tracks: asset.tracks(withMediaType: .video)) { [weak self] request in
            guard let `self` = self else {
                return request.anySourceImage!
            }
        
            self.compositeLayerFilter.inputBackgroundImage = request.anySourceImage
            let sec = CMTimeGetSeconds(request.compositionTime)
            let beginAt = self.roundedTimestamp(timestamp: Double(sec), nodp: 1.0)
            let endAt = beginAt
            
            if self.imagesArray.count > 0 {
                //Overlay Image
                let oi = self.imagesArray[beginAt]
                if oi != nil {
                    if oi!.used! {
                        LineDebugger.line("beginAt: \(beginAt) - count: \(self.imagesArray.count)")
                        let ue = UsedImageObject(); ue.id = oi!.id!; ue.used = true;
                        ue.positionInComposite = oi!.positionInComposite!
                        let endAt = oi!.endAt!
                        self.useImagesArray[endAt] = ue
                        
                        self.showLayerFilter(f: oi!)
                        self.imagesArray[beginAt]!.used = false
                    }
                }
            }
            
            if self.useImagesArray.count > 0 {
                //Used overlay Image
                let uoi = self.useImagesArray[endAt]

                 if uoi != nil {
                    if uoi!.used! {
                        LineDebugger.line("endAt: \(endAt) - count: \(self.useImagesArray.count)")
                        self.hideLayerFilter(positionInComposite: uoi!.positionInComposite!)
                        self.useImagesArray[endAt]!.used = false
                    }
                 }
            }

            return self.compositeLayerFilter.outputImage!
        }
        let composition = VideoComposition(propertiesOf: asset, compositionRequestHandler: handler.handle(request:))
        
        self.asset = asset
        self.videoComposition = composition
//        self.processVideoComposite()
    }
    
    //MARK: Function: processVideoComposite
    //Use: Processed video composite
    fileprivate func processVideoComposite() {
        guard let asset = self.asset, let videoComposition = self.videoComposition else {
            return
        }

        let fileManager = FileManager()
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.mp4")
        try? fileManager.removeItem(at: outputURL)
        
        var configuration = AssetExportSession.Configuration(fileType: AssetExportSession.fileType(for: outputURL)!, videoSettings: .h264(videoSize: videoComposition.renderSize), audioSettings: .aac(channels: 2, sampleRate: 44100, bitRate: 128 * 1000))
        configuration.videoComposition = videoComposition.makeAVVideoComposition()
        let exporter = try! AssetExportSession(asset: asset, outputURL: outputURL, configuration: configuration)
        exporter.export(progress: { p in
            //Progress checker
            //Uncomment this to get pecentile progress
            //print("progress: \(p.localizedDescription!)")
        }, completion: { error in
            self.saveToDeviceLibrary(url: outputURL)
        })
        self.exporter = exporter
    }
    
    //MARK: Function: processVideoComposite
    //Use: Save processed video file to device library
    fileprivate func saveToDeviceLibrary(url: URL) {
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }, completionHandler: { success, error in
            if success {
                LineDebugger.line("processed video saved")
                self.exporter = nil
            }
            else {
                LineDebugger.line("erroring saving...!")
            }
        })
    }
    
    //MARK: Function: processVideoComposite
    //Use: Append to MTILayer to compositeLayerFilter
    fileprivate func addCompositeLayers() {
        //1
        let beginAt1: Double = 1.5
        let duration1: Double = 0.20
        
        
        let beginAt2: Double = 0.10
        let duration2: Double = 0.20
        
        //Replace image string with your desired image
        self.createNewLayer(image: "stick3", xy: CGPoint(x: 100, y: 180), sz: 190, beginAt: beginAt1, endAt: beginAt2+duration2)
        
        //2
       
        //Replace image string with your desired image
        self.createNewLayer(image: "stick1", xy: CGPoint(x: 40, y: 420), sz: 150, beginAt: 0.10, endAt: beginAt2+duration2)
    }
    
    //MARK: PRESENTATION: viewDidLoad
    //Use: Present ui
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded!")
        view.backgroundColor = .white

        self.compositeLayerFilter = MTIMultilayerCompositingFilter()

        self.addCompositeLayers()
//
        self.bundle = Bundle(for: type(of: self))
        let url = self.bundle?.url(forResource: "video", withExtension: "mp4")
//        Bundle.main.path(forResource: "video", ofType: "mp4")
        let asset = AVURLAsset(url: url!)
        self.processAVAsset(asset: asset)
        MyPlayer.share.addPlayerToView(self.view)
        let item = AVPlayerItem(asset: self.asset!)
        MyPlayer.share.playVideoWithAsset(item)
        MyPlayer.share.player?.currentItem?.videoComposition = videoComposition?.makeAVVideoComposition()
        MyPlayer.share.player?.play()
        
        
    }
}
