//
//  GalleryPicker.swift
//  AsafVideoIMG
//
//  Created by Mobile on 19/08/22.
//

import UIKit
import PhotosUI
import AVFoundation

class GalleryPicker: NSObject{
    static let shared = GalleryPicker()
    
    private var imagePickerDelegateHolder = ImagePickerDelegateHolder()
    

    func openImagePicker(otputurl:@escaping (URL,MediaType)-> ()){
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
//        configuration.filter = .videos
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: configuration)
        let dele = ImagePickerDelegate(presenter: UIApplication.visibleViewController) { url,mediaType  in
            print(url)
            otputurl(url,mediaType)
        }
        picker.delegate = dele
        self.imagePickerDelegateHolder.pickerDelegate = dele
        UIApplication.visibleViewController.present(picker, animated: true, completion: nil)
    }
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
}
