

import Foundation
import Firebase
import FirebaseFirestore

enum FCollectionReference: String {
case User
}

func fireStoreReference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}

