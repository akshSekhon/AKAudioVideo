//
//  PhotoStore.swift
//  Butt-swapper
//
//  Created by RMN on 19/02/18.
//  Copyright © 2017 RMN. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class PhotoStore: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Store variables
    static let shared = PhotoStore()
    
    internal var closure: (UIImage?)->Void = {_ in }
    internal var urlClouser:(URL?)->Void = {_ in}
    internal let picker = UIImagePickerController()
    var lastPickedImage: UIImage!

    //MARK: Init method

    internal override init() {
        super.init()
        picker.delegate = self
        
        picker.mediaTypes = [kUTTypeImage as String,kUTTypeMovie as String]
    }

    //MARK: functions to call for camera and photo gallery image

    func requestCameraImage(_ completion: @escaping (_ : UIImage?) -> Void) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            completion(nil)
            UIAlertController.showAlert("Errors", message: "Camera not available", buttons: ["OK"] ,type:0 ,  completion: {(control, index) in
            })
            return
        }
        closure = completion
        picker.sourceType = .camera
        openPicker()
    }

    func requestGalleryImage(_ completion: @escaping (_ : UIImage?) -> Void) {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            completion(nil)
            UIAlertController.showAlert("Errors", message: "Camera not available", buttons: ["OK"] ,type:0 ,  completion: {(control, index) in
            })
            return
        }
        closure = completion
        picker.sourceType = .photoLibrary
        openPicker()
    }

    
    func requestGalleryVideo(_ completion: @escaping (_ : URL?) -> Void) {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            completion(nil)
            UIAlertController.showAlert("Errors", message: "Camera not available", buttons: ["OK"] ,type:0 ,  completion: {(control, index) in
            })
            return
        }
        urlClouser = completion
        picker.sourceType = .photoLibrary
        openPicker()
    }
    private func openPicker() {
        UIApplication.visibleViewController.present(picker, animated: true, completion: nil)
    }

    //MARK: Image picker delegates

    internal func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       if let chosenImage = info[.originalImage] as? UIImage{
           
        picker.dismiss(animated: true) {
                        self.lastPickedImage = chosenImage
 
                        self.closure(chosenImage)
                    }
       }
        if let chosenVideo = info[.mediaURL] as? URL{
            
            picker.dismiss(animated: true) {
//                self.selectedMedia = .videourl
//                            self.lastPickedImage = chosenImage
                            self.urlClouser(chosenVideo)
                        }
        }
    }


    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.closure(nil)
        }
    }

}


