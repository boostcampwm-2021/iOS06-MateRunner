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
import FirebaseFirestoreSwift

final class DefaultFireStoreNetworkService: FireStoreNetworkService {
    private let database: Firestore = Firestore.firestore()
    
    func writeDTO<T: Codable>(
        _ dto: T,
        collection: String,
        document: String,
        key: String
    ) -> Observable<Void> {
        let documentReference = self.database.collection(collection).document(document)
        
        return Observable.create { emitter in
            do {
                let newElement = try Firestore.Encoder().encode(dto)
                documentReference.setData([key: newElement], merge: true) { error in
                    if let error = error {
                        emitter.onError(error)
                    } else {
                        emitter.onNext(())
                    }
                    emitter.onCompleted()
                }
            } catch {
                emitter.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func readDTO<T: Codable>(
        _ dto: T,
        collection: String,
        document: String
    ) -> Observable<T> {
        let documentReference = self.database.collection(collection).document(document)
        
        return Observable.create { emitter in
            documentReference.getDocument { querySnapshot, error in
                if let error = error {
                    emitter.onError(error)
                }
                guard let data = try? querySnapshot?.data(as: T.self) else { return }
                emitter.onNext(data)
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
    
    func fetchProfile(
        collection: String,
        document: String
    ) -> Observable<UserProfile> {
        let documentReference = self.database.collection(collection).document(document)
        return Observable<UserProfile>.create { emitter in
            documentReference.getDocument { (document, error) in
                if let document = document {
                    guard let time = document.get("time") as? String,
                          let calorie = document.get("calorie") as? String,
                          let distance = document.get("distance") as? String else { return }
                    let userInfo = UserProfile(
                        nickname: document.get("name") as? String ?? "",
                        image: document.get("image") as? String ?? "",
                        time: Int(time) ?? 0,
                        distance: Double(distance) ?? 0.0,
                        calorie: Double(calorie) ?? 0.0)
                    emitter.onNext(userInfo)
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
            collectionReference
                .whereField("name", isGreaterThanOrEqualTo: text)
                .whereField("name", isLessThanOrEqualTo: (text + "\u{00B0}"))
                .whereField("name", isNotEqualTo: "yujin")
                .getDocuments { (querySnapshot, error) in
                if let error = error {
                    emitter.onError(error)
                } else {
                    guard let querySnapshot = querySnapshot else { return }
                    var ids: [String] = []
                    querySnapshot.documents.forEach {
                        ids.append($0.documentID)
                    }
                    emitter.onNext(ids)
                }
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
}
