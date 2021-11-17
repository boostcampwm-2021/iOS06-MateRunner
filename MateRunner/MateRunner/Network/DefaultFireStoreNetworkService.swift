//
//  DefaultFireStoreNetworkService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/07.
//

import Foundation

import Firebase
import FirebaseFirestore
import RxSwift

final class DefaultFireStoreNetworkService: FireStoreNetworkService {
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
    
    func documentDoesExist(collection: String, document: String) -> Observable<Bool> {
        let documentReference = self.database.collection(collection).document(document)
        
        return Observable.create { emitter in
            documentReference.getDocument { (document, error) in
                if let error = error {
                    emitter.onError(error)
                } else if let document = document, document.exists {
                    emitter.onNext(false)
                } else {
                    emitter.onNext(true)
                }
            }
            return Disposables.create()
        }
    }
    
    func writeData(collection: String, document: String, data: [String: Any]) -> Observable<Bool> {
        let documentReference = self.database.collection(collection).document(document)
        
        return Observable.create { emitter in
            documentReference.setData(data, merge: true) { error in
                if let error = error {
                    emitter.onError(error)
                } else {
                    emitter.onNext(true)
                }
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
                    guard let data = document.get(field) as? T else { return }
                    emitter.onNext(data)
                }
                if let error = error {
                    emitter.onError(error)
                }
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func fetchFilteredDocument(collection: String, with text: String) -> Observable<[String]> {
        let collectionReference = self.database.collection(collection)
        
        return Observable.create { emitter in
            collectionReference.getDocuments { (querySnapshot, error) in
                if let error = error {
                    emitter.onError(error)
                } else {
                    guard let querySnapshot = querySnapshot else { return }
                    var ids: [String] = []
                    querySnapshot.documents.forEach {
                        if $0.documentID.hasPrefix(text) {
                            ids.append($0.documentID)
                        }
                    }
                    emitter.onNext(ids)
                }
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
}
