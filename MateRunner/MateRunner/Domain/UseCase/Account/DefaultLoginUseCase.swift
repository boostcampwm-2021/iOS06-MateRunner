//
//  DefaultLoginUseCase.swift
//  MateRunner
//
//  Created by 이정원 on 2021/11/22.
//

import Foundation

import RxSwift

final class DefaultLoginUseCase: LoginUseCase {
    private let repository: UserRepository
    var isRegistered = PublishSubject<Bool>()
    var isSaved = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func checkRegistration(uid: String) {
        self.repository.checkRegistration(uid: uid)
            .bind(to: self.isRegistered)
            .disposed(by: self.disposeBag)
    }
    
    func saveLoginInfo(uid: String) {
        self.repository.fetchUserNicknameFromServer(uid: uid)
            .subscribe(onNext: { [weak self] nickname in
                self?.repository.saveLoginInfo(nickname: nickname)
                self?.isSaved.onNext(true)
            })
            .disposed(by: self.disposeBag)
    }
}
