//
 //  MockMateRepository.swift
 //  MateRunnerViewModelTests
 //
 //  Created by 이유진 on 2021/11/30.
 //

 import Foundation

 import RxSwift

 final class MockMateRepository: MateRepository {
     func sendRequestMate(from sender: String, fcmToken: String) -> Observable<Void> {
         return Observable.just(())
     }

     func fetchFCMToken(of mate: String) -> Observable<String> {
         return Observable.just("2341asdgf1ddf")
     }

     func sendEmoji(from sender: String, fcmToken: String) -> Observable<Void> {
         return Observable.just(())
     }
 }
