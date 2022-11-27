//
//  StuctStatics.swift
//  AsafVideoIMG
//
//  Created by Mobile on 15/09/22.
//

import Foundation
import UIKit
import MetalPetal
struct GlobalStruct{
    static var videoMirrorType:VideoMirrorEffect?
    static var videoArtType:VideoArtEffect?
    static var ColorLookUp:UIImage?
    static var overlayImage:MTIImage?
    static var coreImgeFilter:String?
    
}
struct Constants{
    static  var overlyTypesArr = ["Stars","Snow","RainDrops","SimplePaper","OldPhoto","Notebook","Neon5","Neon4","Neon3","Neon2","Neon1","LinePaper","Film1","Dust","Coloring","Space1","Frame"]
    
    static var colorLookupArr = ["Polaroid","Poloroid690","Sunny","Lilac","Vintage","PinkLove","Japan","Glow","Paladin"]
    
    var arr = ["Polaroid","Poloroid690","Sunny","Lilac","Vintage","PinkLove","Japan","Glow","Paladin"]//
    static var filmLookUpArr = ["Retro Film","VHS","DV Cam"]
    
    static var caFiltersArr:[Any] = [
        "CIBloom",
        "CIColorMonochrome",
        "CIVignette",
        "CISepiaTone",
        "CIVignetteEffect","CIThermal"
    ]
    static let colorArr:[UIColor] = [.clear,.white,.black,.blue,.red,.opaqueSeparator,.systemBlue,.cyan,.darkGray,.green,.lightGray,.magenta,.yellow,.purple,.systemGray2,.systemGray3,.systemGray4,.systemGray5,.systemGray6,.secondaryLabel]
}

struct UI_Images{
    static let transBoxes = UIImage(named: "BG Color")
    static let leftAlign = UIImage(named: "Alignment1")
    static let centerAlign = UIImage(named: "Alignment")
    static let rightAlign = UIImage(named: "Alignment2")
    static let font = UIImage(named: "Font")
}

struct ButtonImages{
    static let add = UIImage(systemName: "plus.circle.fill")
    static let delete = UIImage(systemName: "trash.fill")
    static let remove = UIImage(systemName: "tray.and.arrow.up.fill")
    static let undo = UIImage(systemName: "arrow.uturn.backward")
    static let redo = UIImage(systemName: "arrow.uturn.forward")
    static let multiply = UIImage(systemName: "multiply")
    static let share = UIImage(systemName: "square.and.arrow.up")
    static let checkMark = UIImage(systemName: "checkmark")
    static let backArrow = UIImage(systemName: "arrow.backward")
}

extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = self.pngData()! as NSData
        let data2: NSData = image.pngData()! as NSData
        return data1.isEqual(data2)
    }
}


