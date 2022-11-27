//
//  MusicManager.swift
//  AsafVideoIMG
//
//  Created by Mobile on 18/10/22.
//

import Foundation
import AVKit



class AudioManager:NSObject{
    
    enum MixError: Error {
       case TimeRangeFailure
       case ExportFailure
    }

    var selectedVideoLevel:Float = 0.0
    var selectedMusicLevel:Float = 1.0

   
    
    
    func mix(videoAsst: AVAsset, musicUrl: URL? ,composition:AVVideoComposition,completion: ((Result<URL, Error>) -> Void)?) {
        
        let audiPath = Bundle.main.path(forResource: "audio", ofType: "mp3")!
        let audiourl = NSURL(fileURLWithPath: audiPath) as URL
        
        let videoAsset = videoAsst
        let musicAsset = AVAsset(url:audiourl)// musicUrl

        let audioVideoComposition = AVMutableComposition()

        let audioMix = AVMutableAudioMix()
        var mixParameters = [AVMutableAudioMixInputParameters]()

        let videoCompositionTrack = audioVideoComposition
          .addMutableTrack(withMediaType: .video, preferredTrackID: .init())!

        let audioCompositionTrack = audioVideoComposition
          .addMutableTrack(withMediaType: .audio, preferredTrackID: .init())!

        let musicCompositionTrack = audioVideoComposition
          .addMutableTrack(withMediaType: .audio, preferredTrackID: .init())!

        let videoAssetTrack = videoAsset.tracks(withMediaType: .video)[0]
        let audioAssetTrack = videoAsset.tracks(withMediaType: .audio).first
        let musicAssetTrack = musicAsset.tracks(withMediaType: .audio)[0]

        let audioParameters = AVMutableAudioMixInputParameters(track: audioAssetTrack)
        audioParameters.trackID = audioCompositionTrack.trackID

        let musicParameters = AVMutableAudioMixInputParameters(track: musicAssetTrack)
        musicParameters.trackID = musicCompositionTrack.trackID

        audioParameters.setVolume(selectedVideoLevel, at: .zero)
        musicParameters.setVolume(selectedMusicLevel, at: .zero)

        mixParameters.append(audioParameters)
        mixParameters.append(musicParameters)

        audioMix.inputParameters = mixParameters

        /// prevents video from unnecessary rotations
        videoCompositionTrack.preferredTransform = videoAssetTrack.preferredTransform

        do {
          let timeRange = CMTimeRange(start: .zero, duration: videoAsset.duration)

          try videoCompositionTrack.insertTimeRange(timeRange, of: videoAssetTrack, at: .zero)

          if let audioAssetTrack = audioAssetTrack {
            try audioCompositionTrack.insertTimeRange(timeRange, of: audioAssetTrack, at: .zero)
          }

          try musicCompositionTrack.insertTimeRange(timeRange, of: musicAssetTrack, at: .zero)

        } catch {
            
            completion?(.failure(MixError.TimeRangeFailure))
        }


        let exportUrl = FileManager.default
          .urls(for: .applicationSupportDirectory, in: .userDomainMask).first?
          .appendingPathComponent("\(Date().timeIntervalSince1970)-video.mp4")

        let exportSession = AVAssetExportSession(asset: audioVideoComposition,presetName: AVAssetExportPresetHighestQuality)
        exportSession?.videoComposition = composition
        exportSession?.audioMix = audioMix
        exportSession?.outputFileType = .mp4
        exportSession?.outputURL = exportUrl
        exportSession?.exportAsynchronously(completionHandler: {
          guard let status = exportSession?.status else { return }

          switch status {
          case .completed:
            completion?(.success(exportUrl!))
         case .failed:
            completion?(.failure(MixError.ExportFailure))
          default:
            print(status)
          }
        })
      }
    
    
    func convertUrlToAsset(url:URL?) -> AVAsset?{
        if let url{
            let asset = AVAsset(url: url)
//            do{
//                try FileManager.default.removeItem(at: url)
//            }
//            catch{
//                print(LineDebugger.line("\(error)"))
//            }
            return asset
        }
        else{
            return nil
        }
    }

}
