//
//  GlobalFunctions.swift
//  GlobalFunctions
//
//  Created by Archit Patel on 2021-10-13.
//

import Foundation


func fileNameFrom(fileUrl: String) -> String {
    
    return ((fileUrl.components(separatedBy: "_").last)!.components(separatedBy: "?").first!).components(separatedBy: ".").first!
    
    
}
