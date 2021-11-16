//
//  FIreStoreNetworkService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/07.
//

import Foundation

import Firebase
import FirebaseFirestore
import RxSwift

final class FireStoreNetworkService: NetworkService {
    private let database: Firestore = Firestore.firestore()
    
    func updateArray<T: Codable>(
        append dto: T,
        collection: String,
        document: String,
        array: String
    ) -> Observable<Bool> {
        let documentReference = self.database.collection(collection).document(document)
        let encoder = Firestore.Encoder.init()
        
        return Observable.create { emitter in
            do {
                let newElement = try encoder.encode(dto)
                documentReference.updateData(
                    [array: FieldValue.arrayUnion([newElement])]
                ) { error in
                    if let error = error {
                        emitter.onError(error)
                        return
                    } else {
                        emitter.onNext(true)
                    }
                    emitter.onCompleted()
                }
            } catch {
                emitter.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func fetchData<T>(
        type: T.Type,
        collection: String,
        document: String,
        field: String
    ) -> Observable<T> {
        let documentReference = self.database.collection(collection).document(document)
        
        return Observable<T>.create { emitter in
            documentReference.getDocument { (document, error) in
                if let document = document {
                    guard let mate = document.get(field) as? T else { return }
                    emitter.onNext(mate)
                }
                if let error = error {
                    emitter.onError(error)
                }
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
}
