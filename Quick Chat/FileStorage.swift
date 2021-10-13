//
//  FileStorage.swift
//  FileStorage
//
//  Created by Archit Patel on 2021-10-13.
//

import Foundation
import FirebaseStorage
import Firebase
import ProgressHUD
import UIKit

let storage = Storage.storage()

class FileStorage {
    
    //MARK: - Images
    
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping(_ documentLink: String?) -> Void) {
        
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(directory)
        
        let imageData = image.jpegData(compressionQuality: 0.6)
        
        var task: StorageUploadTask!
        
        task = storageRef.putData(imageData!, metadata: nil, completion: { metaData, error in
            
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("Error uploading image \(error!.localizedDescription)" )
            }
            
            storageRef.downloadURL { url, error in
                
                guard let downloadURL  = url else {
                    completion(nil)
                    return
                }
                
                completion(downloadURL.absoluteString)
            }
        })
        
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }
    
    //MARK: - DownloadImage
    
    class func downloadImage(imageUrl: String, compeltion: @escaping(_ image: UIImage?) -> Void) {
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
        
        if fileExistsAtPath(path: imageFileName) {
            
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
                
                compeltion(contentsOfFile)
                
            } else {
                print("couldn't convert local image")
                compeltion(UIImage(named: "avatar"))
            }
            
        } else {
            //download from firebase
            if imageUrl != "" {
                let documentUrl = URL(string: imageUrl)
                
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                
                downloadQueue.async {
                    
                    let data = NSData(contentsOf: documentUrl!)
                    if data != nil {
                        // Save Locally
                        FileStorage.saveFileLocally(fileData: data!, fileName: imageFileName)
                        DispatchQueue.main.async {
                            compeltion(UIImage(data: data! as Data))
                        }
                        
                    } else {
                        print("No document in database")
                        DispatchQueue.main.async {
                            compeltion(nil)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Save Locally
    
    class func saveFileLocally(fileData: NSData, fileName: String) {
        
        let docUrl = getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
        
        fileData.write(to: docUrl, atomically: true)
        
    }
    
}

//MARK: - Helpers


func fileExistsAtPath(path: String) -> Bool {
    
    let filePath = fileInDocumentsDirectory(fileName: path)
    let fileManager = FileManager.default
    
    return fileManager.fileExists(atPath: filePath)
}


func fileInDocumentsDirectory(fileName: String) -> String {
    
    return getDocumentsURL().appendingPathComponent(fileName).path
    
}

func getDocumentsURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}
