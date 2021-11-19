//
//  DefaultMateRepository.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/16.
//

import Foundation

import RxRelay
import RxSwift

final class DefaultMateRepository: MateRepository {
    let networkService: FireStoreNetworkService
    let realtimeNetworkService: RealtimeDatabaseNetworkService
    
    init(
        networkService: FireStoreNetworkService,
        realtimeNetworkService: RealtimeDatabaseNetworkService
    ) {
        self.networkService = networkService
        self.realtimeNetworkService = realtimeNetworkService
    }
    
    func fetchMateNickname() -> Observable<[String]> {
        return self.networkService.fetchData(
            type: [String].self,
            collection: FirebaseCollection.user,
            document: "yujin",
            field: "mate"
        )
    }
    
    func fetchMateProfileImage(from nickname: String) -> Observable<String> {
        return self.networkService.fetchData(
            type: String.self,
            collection: FirebaseCollection.user,
            document: nickname,
            field: "image"
        )
    }
    
    func fetchFilteredNickname(text: String) -> Observable<[String]> {
        return self.networkService.fetchFilteredDocument(
            collection: FirebaseCollection.user,
            with: text
        )
    }
    
    func sendRequestMate(from sender: String, fcmToken: String) {
        let dto = MessagingRequestDTO(
            title: "메이트 요청",
            body: "메이트 요청이 도착했습니다!",
            data: MateRequest(sender: sender),
            to: fcmToken)
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send"),
              let json = try? JSONEncoder().encode(dto) else { return }
        let key0 = "key=AAAAIlcoX1A:APA91bEChOkNGbdKrk6IgSEpBbxJNLTR0zNrc6an2pLyOA6601ijI"
        let key1 = "oRsuqaYWIjVojqcGgevYtDAmT_LcFYUl89a_pi6fqtd3s0FJ9t27Dlmn0rKL-ILY-jknoyKpIQmeH6lEyXpGEcT"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = json
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(key0+key1, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { _, _, err in
            guard err == nil else {
                print(err?.localizedDescription as Any)
                return
            }
        }
        task.resume()
    }
    
    func fetchFCMToken(of mate: String)-> Observable<String> {
        return self.realtimeNetworkService.fetchFCMToken(of: mate)
    }
}
