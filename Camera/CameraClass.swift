//
//  CameraExtenssion.swift
//  AsafVideoIMG
//
//  Created by Mobile on 17/08/22.
//

import Foundation
import UIKit
import MetalPetal
import VideoIO
import VideoToolbox
import AVKit


protocol CameraRecordData:NSObjectProtocol{
    func cameraImage(_ image: UIImage)
}

class CameraClass: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate{
  
    
    struct State {
        var isRecording: Bool = false
        var isVideoMirrored: Bool = false
    }

    public var previewImage: UIImage?
    
    private let queue: DispatchQueue = DispatchQueue(label: "org.metalpetal.capture")
    let imageRenderer = PixelBufferPoolBackedImageRenderer()
    private var recorder: MovieRecorder?
    private let renderContext = try! MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    private var _state: State = State()
    private let stateLock = MTILockCreate()
    
    //@ use Camea State is lock  running
    private(set) var state: State {
        get {
            stateLock.lock()
            defer {
                stateLock.unlock()
            }
            return _state
        }
        set {
            stateLock.lock()
            defer {
                stateLock.unlock()
            }
            _state = newValue
        }
    }
    var delegate:CameraRecordData!
    
    private var cameraPose : AVCaptureDevice.Position = .back
    
//Mark: - SetUp Camera 
    private let camera: Camera = {
        var configurator = Camera.Configurator()
        
        let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.windowScene != nil })?.windowScene?.interfaceOrientation
        configurator.videoConnectionConfigurator = { camera, connection in
            switch interfaceOrientation {
            case .landscapeLeft:
                connection.videoOrientation = .landscapeLeft
            case .landscapeRight:
                connection.videoOrientation = .landscapeRight
            case .portraitUpsideDown:
                connection.videoOrientation = .portraitUpsideDown
            default:
                connection.videoOrientation = .portrait
            }
            connection.videoOrientation = .portrait
        }
        return Camera(captureSessionPreset: .hd1280x720, defaultCameraPosition: .back, configurator: configurator)
    }()
    
    
    override init() {
        super.init()
        try? self.camera.enableVideoDataOutput(on: queue, delegate: self)
        try? self.camera.enableAudioDataOutput(on: queue, delegate: self)
        self.camera.videoDataOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
    }
    
    
    // @use: flip the camera
    func flipCamera(){
        switch cameraPose {
        case .front:
            do {
                try self.camera.switchToVideoCaptureDevice(with: .back)
                self.cameraPose = .back
            } catch {
                return
            }

        default:
            do {
                try self.camera.switchToVideoCaptureDevice(with: .front)
                self.cameraPose = .front
            } catch {
                return
            }
        }
    }
    // @use: Click Image From Camera
    public func snapImage() -> CGImage? {
           if let im = self.previewImage {
               return im.cgImage
           } else {
               return self.previewImage?.cgImage
           }
       }
    // @use: start rumning CameraCaptureing
    func startRunningCaptureSession() {
        queue.async {
            self.camera.startRunningCaptureSession()
        }
    }
    // @use: Stop CameraCaptureing
    func stopRunningCaptureSession() {
        queue.async {
            self.camera.stopRunningCaptureSession()
        }
    }
    // @use: Check is Camera State isRunning Or Not
    func isCameraRumning() -> Bool{
    let result = self.camera.captureSessionIsRunning
      return result
    }
    // @use: Start Reconding Camera
    func startRecording() throws {
        let sessionID = UUID()
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(sessionID.uuidString).mp4")
        // record audio when permission is given
        let hasAudio = self.camera.audioDataOutput != nil
        let recorder = try MovieRecorder(url: url, configuration: MovieRecorder.Configuration(hasAudio: hasAudio))
        state.isRecording = true
        queue.async {
            self.recorder = recorder
        }
    }
    // @use: Stop Reconding Camera
    func stopRecording(completion: @escaping (Result<URL, Error>) -> Void) {
        if let recorder = recorder {
            recorder.stopRecording(completion: { error in
                self.state.isRecording = false
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(recorder.url))
                    print(recorder.url)
                }
            })
            queue.async {
                self.recorder = nil
            }
        }
    }
    
    
    // @use: Capture Session and Show camra Output
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let formatDescription = sampleBuffer.formatDescription else {
            return
        }
        switch formatDescription.mediaType {
        case .audio:
            do {
                try self.recorder?.appendSampleBuffer(sampleBuffer)
            } catch {
                print(error)
            }
        case .video:
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            do {
                let image = MTIImage(cvPixelBuffer: pixelBuffer, alphaType: .alphaIsOne)
//                let filterOutputImage = self.filter(image, faces)
//                let outputImage = self.state.isVideoMirrored ? filterOutputImage.oriented(.upMirrored) : filterOutputImage
                let renderOutput = try self.imageRenderer.render(image, using: renderContext)
                try self.recorder?.appendSampleBuffer(SampleBufferUtilities.makeSampleBufferByReplacingImageBuffer(of: sampleBuffer, with: renderOutput.pixelBuffer)!)
                DispatchQueue.main.async {
                    let cgImg = renderOutput.cgImage
                    let uiImg = UIImage(cgImage: cgImg)
                    self.previewImage = uiImg
                    if let dele = self.delegate{
                        dele.cameraImage(uiImg)
                    }
//                    self.delegate.cameraImage(uiImg)
//                    NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: self.previewImage)
                }
            } catch {
                print(error)
            }
        default:
            break
        }
    }
    
}
  
