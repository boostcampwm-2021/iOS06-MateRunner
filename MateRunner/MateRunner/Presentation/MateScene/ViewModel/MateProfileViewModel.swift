//
//  MateProfileViewModel.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/19.
//

import Foundation

import RxRelay
import RxSwift

final class MateProfileViewModel: NSObject {
    private let profileUseCase: ProfileUseCase
    weak var coordinator: MateProfileCoordinator?
    var mateInfo: UserData?
    var recordInfo: [RunningResult]?
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let loadProfile = PublishRelay<Bool>()
        let loadRecord = PublishRelay<Bool>()
    }
    
    init(nickname: String,
        coordinator: MateProfileCoordinator,
        profileUseCase: ProfileUseCase
    ) {
        self.mateInfo = UserData(
            nickname: "",
            image: "",
            time: 0,
            distance: 0,
            calorie: 0,
            height: 0,
            weight: 0,
            mate: []
        )
        self.coordinator = coordinator
        self.profileUseCase = profileUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                guard let nickname = self?.mateInfo?.nickname else { return }
                self?.profileUseCase.fetchUserInfo("hunihun956")
                self?.profileUseCase.fetchRecordList(nickname: "hunihun956")
            })
            .disposed(by: disposeBag)
        
        self.profileUseCase.userInfo
            .subscribe(onNext: { [weak self] mate in
                self?.mateInfo = mate
                output.loadProfile.accept(true)
            })
            .disposed(by: disposeBag)
        
        self.profileUseCase.recordInfo
            .subscribe(onNext: { [weak self] record in
                self?.recordInfo = record
                output.loadRecord.accept(true)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func moveToDetail(record: RunningResult) {
        self.coordinator?.pushRecordDetailViewController(with: record)
    }
    
    func moveToEmoji() {
        self.coordinator?.presentEmojiModal()
    }
    
    func fetchUserNickname() -> String? {
        self.profileUseCase.fetchUserNickname()
    }
}
