//
//  MediaToolKit.swift
//  MedicineCalculator
//
//  Created by tommy on 2018/1/29.
//  Copyright © 2018年 ipzoe. All rights reserved.
//

import UIKit
import AssetsLibrary
import AVFoundation

public class MediaToolKit: NSObject {
    
    private static let RECORD_VOICE_FOLDER = "RecordVoices"
    
    private static let RECORD_VIDEO_FOLDER = "RecordVideos"
    
    private static let MERGE_VIDEO_FOLDER  = "MergeVideos"
    
    private static let CAPTURE_PHOTO_FOLDER = "TakePhotos"
    
    private static let DB_FOLDER = "DataBase"
    
//MARK: - 创建图片缓存目录
    
    public static func createMediaFolderIfNeed() {
        let tempVoiceFolder = self.getTempVoiceSavePath()
        let tempPicFolder = self.getTempPhotoSavePath()
        let tempVideoFolder = self.getTempVideoSavePath()
        let tempMergeVideoFolder = self.getTempMergeVideoSavePath()
        
        let fileManager = FileManager.default
        
        do {
            var isVoiceDir = ObjCBool(false)
            let isVoiceDirExist = fileManager.fileExists(atPath: tempVoiceFolder, isDirectory: &isVoiceDir)
            if !(isVoiceDirExist && isVoiceDir.boolValue) {
                try fileManager.createDirectory(atPath: tempVoiceFolder, withIntermediateDirectories: true, attributes: nil)
                print("VoiceDir = \(tempVoiceFolder)")
            }
            
            var isPicDir = ObjCBool(false)
            let isPicDirExist = fileManager.fileExists(atPath: tempPicFolder, isDirectory: &isPicDir)
            if !(isPicDirExist && isPicDir.boolValue) {
                try fileManager.createDirectory(atPath: tempPicFolder, withIntermediateDirectories: true, attributes: nil)
                print("PicDir = \(tempPicFolder)")
            }
            
            var isVideoDir = ObjCBool(false)
            let isVideoDirExist = fileManager.fileExists(atPath: tempVideoFolder, isDirectory: &isVideoDir)
            if !(isVideoDirExist && isVideoDir.boolValue) {
                try fileManager.createDirectory(atPath: tempVideoFolder, withIntermediateDirectories: true, attributes: nil)
                print("VideoDir = \(tempVideoFolder)")
            }
            
            var isMergeVideoDir = ObjCBool(false)
            let isMergeVideoDirExist = fileManager.fileExists(atPath: tempMergeVideoFolder, isDirectory: &isMergeVideoDir)
            if !(isMergeVideoDirExist && isMergeVideoDir.boolValue) {
                try fileManager.createDirectory(atPath: tempMergeVideoFolder, withIntermediateDirectories: true, attributes: nil)
                print("MergeVideoDir = \(tempMergeVideoFolder)")
            }
        } catch {
            print("文件夹创建失败---->\(error)")
        }
    }
    
    public static func getCurrentUserFolder(userId: String) -> String {
        return GlobalProperties.DocumentPath.appending("/user_folder_\(userId)/")
    }
    
    public static func getTempVoiceSavePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let path = paths.first {
            return path.appending("/\(self.RECORD_VOICE_FOLDER)/")
        } else {
            return ""
        }
    }
    
    public static func getTempPhotoSavePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let path = paths.first {
            return path.appending("/\(self.CAPTURE_PHOTO_FOLDER)/")
        } else {
            return ""
        }
    }
    
    public static func getTempMergeVideoSavePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let path = paths.first {
            return path.appending("/\(self.MERGE_VIDEO_FOLDER)/")
        } else {
            return ""
        }
    }
    
    public static func getMergeVideoSaveFilePath () -> String {
        let path = self.getTempMergeVideoSavePath()
        let recordPath = path.appending(self.getNowTimeString()).appending("-\(EvaUtil.uuid())-MergeVideo.mp4")
        return recordPath
    }
    
    public static func getTempVideoSavePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let path = paths.first {
            return path.appending("/\(self.RECORD_VIDEO_FOLDER)/")
        } else {
            return ""
        }
    }
    
    public static func removeAllObjectsAt(directory: String) {
        let fileManager = FileManager.default
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: directory)
            for content in contents {
                try fileManager.removeItem(at: URL.init(fileURLWithPath: directory.appending(content)))
            }
        } catch {}
    }
    
    public static func removeAllRecordVoices() {
        let voiceDirectory = self.getTempVoiceSavePath()
        self.removeAllObjectsAt(directory: voiceDirectory)
    }
    
    public static func removeAllCapturePhotos() {
        let picDirectory = self.getTempPhotoSavePath()
        self.removeAllObjectsAt(directory: picDirectory)
    }
    
    public static func removeAllRecordVideos() {
        let videoDirectory = self.getTempVideoSavePath()
        self.removeAllObjectsAt(directory: videoDirectory)
    }
    
    public static func removeAllSnippetVideos() {
        let videoDirectory = self.getTempMergeVideoSavePath()
        let fileManager = FileManager.default
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: videoDirectory)
            for content in contents {
                print("移除文件:\(videoDirectory.appending(content))")
                try fileManager.removeItem(at: URL.init(fileURLWithPath: videoDirectory.appending(content)))
            }
        } catch {
            print(error)
        }
    }
    
//MARK: - 当前用户操作媒体文件夹
    
    public static func createFolderForCurrentUserIfNeed(userId: String) {
        let userFolderPath = self.getCurrentUserFolder(userId: userId)
        
        let fileManager = FileManager.default
        var isDir = ObjCBool(true)
        
        do {
            if !fileManager.fileExists(atPath: userFolderPath, isDirectory: &isDir) {
                try fileManager.createDirectory(atPath: userFolderPath, withIntermediateDirectories: true, attributes: nil)
                print("创建文件夹成功--->\(userFolderPath)")
            }
            
            let userMediaFolderArray = [self.getCurrentUserDBFileSavePath(userId: userId), self.getCurrentUserPicSavePath(userId: userId), self.getCurrentUserVideoSavePath(userId: userId), self.getCurrentUserVoiceSavePath(userId: userId), self.getCurrentUserGifPicSavePath(userId: userId), self.getCurrentUserBlacklistSavePath(userId: userId)]
            isDir = ObjCBool(true)
            
            for mediaFolder in userMediaFolderArray {
                if !fileManager.fileExists(atPath: mediaFolder, isDirectory: &isDir) {
                    try fileManager.createDirectory(atPath: mediaFolder, withIntermediateDirectories: true, attributes: nil)
                    print("创建文件夹成功--->\(mediaFolder)")
                }
            }
            
            let blacklistPath = self.getCurrentUserBlacklistSavePath(userId: userId).appending("blacklist.plist")
            if !fileManager.fileExists(atPath: blacklistPath) {
                let array = NSMutableArray.init()
                array.write(toFile: blacklistPath, atomically: true)
            }
        } catch {
            print("用户文件夹创建失败---->\(error)")
        }
    }
    
    public static func getUserFilesBasePath(userId: String) -> String {
        let userFolderPath = self.getCurrentUserFolder(userId: userId)
        let basePath = userFolderPath.appending("UserFiles/")
        return basePath
    }
    
    public static func getCurrentUserDBFileSavePath(userId: String) -> String {
        let resultPath = self.getUserFilesBasePath(userId: userId).appending("DataBase/")
        return resultPath
    }
    
    public static func getCurrentUserVoiceSavePath(userId: String) -> String {
        let resultPath = self.getUserFilesBasePath(userId: userId).appending("Voice/")
        return resultPath
    }
    
    public static func getCurrentUserVideoSavePath(userId: String) -> String {
        let resultPath = self.getUserFilesBasePath(userId: userId).appending("Video/")
        return resultPath
    }
    
    public static func getCurrentUserPicSavePath(userId: String) -> String {
        let resultPath = self.getUserFilesBasePath(userId: userId).appending("Picture/")
        return resultPath
    }

    public static func getCurrentUserGifPicSavePath(userId: String) -> String {
        let resultPath = self.getUserFilesBasePath(userId: userId).appending("Gif/")
        return resultPath
    }
    
    public static func getCurrentUserBlacklistSavePath(userId: String) -> String {
        let resultPath = self.getUserFilesBasePath(userId: userId).appending("Blacklist/")
        return resultPath
    }
    
    public static func getNowTimeString() -> String {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let nowString = formatter.string(from: Date.init())
        return nowString
    }
    
//MARK: - 音频相关
    
    public static func playSystemVibrateSound() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    public static func getAudioDurationWithAudioPath(recordPath: String) -> Double {
        let audioAsset = AVURLAsset.init(url: URL.init(fileURLWithPath: recordPath), options: nil)
        let audioDuration = audioAsset.duration
        
        var audioDurationSeconds = CMTimeGetSeconds(audioDuration)
        if audioDurationSeconds == 0 {
            do {
                let player = try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: recordPath))
                audioDurationSeconds = player.duration
            } catch {
                return 0.0
            }
        }
        return Double(audioDurationSeconds)
    }
}
