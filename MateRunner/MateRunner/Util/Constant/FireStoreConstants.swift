//
//  FireStoreConstants.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/12/02.
//

import Foundation

enum FirestoreConfiguration {
    static let firestoreBaseURL = "https://firestore.googleapis.com/v1/"
    static let baseURL = "https://firestore.googleapis.com/v1/projects/mate-runner-e232c"
    static let documentsPath = "/databases/(default)/documents"
    static let queryKey = ":runQuery"
    static let commitKey = ":commit"
    static let defaultHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
}

enum FirestoreFieldParameter {
    static let updateMask = "updateMask.fieldPaths="
    static let readMask = "mask.fieldPaths="
}

enum FirestoreCollectionPath {
    static let runningResultPath = "/RunningResult"
    static let userPath = "/User"
    static let recordsPath = "/records"
    static let emojiPath = "/emojis"
    static let notificationPath = "/Notification"
    static let uidPath = "/UID"
}

enum FirestoreField {
    static let fields = "fields"
    static let emoji = "emoji"
    static let userNickname = "userNickname"
    static let nickname = "nickname"
    static let distance = "distance"
    static let time = "time"
    static let height = "height"
    static let weight = "weight"
    static let image = "image"
    static let calorie = "calorie"
    static let mate = "mate"
}

enum FirebaseStorageConfiguration {
    static let baseURL = "https://firebasestorage.googleapis.com/v0/b"
    static let projectNamePath = "/mate-runner-e232c.appspot.com/o"
    static let profileImageName = "profile.png"
    static let downloadTokens = "downloadTokens"
    static let altMediaParameter = "alt=media"
    static let tokenParameter = "token="
    static let mediaContentType = ["Content-Type": "image/png"]
}
