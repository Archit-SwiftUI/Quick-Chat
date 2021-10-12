//
//  FCollectionReference.swift
//  FCollectionReference
//
//  Created by Archit Patel on 2021-10-12.
//

import UIKit
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Recent
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
