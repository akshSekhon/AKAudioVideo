//
//  ImagePickerClass.swift
//  MetalPetelDummy
//
//  Created by Mobile on 18/07/22.
//

import UIKit
import Foundation
import PhotosUI

//MARK: - Video Picker Class
class ImagePickerDelegateHolder: ObservableObject {
    var pickerDelegate: ImagePickerDelegate?
}
class ImagePickerDelegate: PHPickerViewControllerDelegate {
    private weak var presenter: UIViewController?
    private let handler: (URL,MediaType) -> Void
    var selectedMediaIs:MediaType? = nil /// Check type of media which Selected From Gallery
    init(presenter: UIViewController, imagePickedHandler: @escaping (URL,MediaType) -> Void) {
        self.presenter = presenter
        self.handler = imagePickedHandler
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.presenter?.dismiss(animated: true, completion: nil)
        if results.count == 1 {
            let result = results[0]
            
            let prov =  result.itemProvider
            
             if prov.canLoadObject(ofClass: PHLivePhoto.self) { // --- In case PickLive Photo
                self.selectedMediaIs = .liveImgPhoto
                 prov.loadFileRepresentation(forTypeIdentifier: UTType.livePhoto.identifier) { url, error in
                     if let url = url {
                         let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(url.pathExtension)
                         do {
                             try FileManager.default.copyItem(at: url, to: tempURL)
                             DispatchQueue.main.async {
                                 self.handler(tempURL, self.selectedMediaIs!)
                             }
                         } catch {
                             print(error)
                         }
                     }
                 }
//                 prov.loadObject(ofClass: PHLivePhoto.self) { livePhoto, err in
//                       if let photo = livePhoto as? PHLivePhoto {
//                           print(photo)
//                           DispatchQueue.main.async {
//                               self.handler(livePhoto as! URL,self.selectedMediaIs!)
//                           }
//                       }
//                 }
               
            } else if prov.canLoadObject(ofClass: UIImage.self) { // --- In case Pick Image Photo
                self.selectedMediaIs = .image
                prov.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier, completionHandler: { url, error in
                                if let url = url {
                                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(url.pathExtension)
                                    do {
                                        try FileManager.default.copyItem(at: url, to: tempURL)
                                        DispatchQueue.main.async {
                                            self.handler(tempURL, self.selectedMediaIs!)
                                        }
                                    } catch {
                                        print(error)
                                    }
                                }
                            })
            }
            else if prov.hasItemConformingToTypeIdentifier(UTType.movie.identifier){
                prov.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier, completionHandler: { url, error in
                    self.selectedMediaIs = .video
                              if let url = url {
                                  let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(url.pathExtension)
                                  do {
                                      try FileManager.default.copyItem(at: url, to: tempURL)
                                      DispatchQueue.main.async {
                                          self.handler(tempURL, self.selectedMediaIs!)
                                      }
                                  } catch {
                                      print(error)
                                  }
                              }
                          })
            }
        }
    }

}
enum MediaType{
    case image //// Check if we pick Image Url From Gallery
    case video //// Check if we pick video Url From Gallery
    case liveImgPhoto ////Check if we pick Live photo Url From Gallery
}
