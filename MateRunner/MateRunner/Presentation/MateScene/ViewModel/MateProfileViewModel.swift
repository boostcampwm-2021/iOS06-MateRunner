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
    var selectEmoji: PublishSubject<Emoji> = PublishSubject()
    var mateInfo: UserData?
    var recordInfo: [RunningResult] = []
    var selectedIndex: Int?
    var hasNextPage: Bool = true
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let refreshEvent: Observable<Void>
        let scrollEvent: Observable<Void>
    }
    
    struct Output {
        let loadProfile = PublishRelay<Bool>()
        let loadRecord = PublishRelay<Bool>()
        let reloadData = PublishRelay<Bool>()
    }
    
    init(nickname: String,
         coordinator: MateProfileCoordinator,
         profileUseCase: ProfileUseCase
    ) {
        self.mateInfo = UserData(
            nickname: nickname,
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
        
        Observable.of(input.viewDidLoadEvent, input.refreshEvent).merge()
            .subscribe(onNext: { [weak self] in
                guard let nickname = self?.mateInfo?.nickname else { return }
                self?.profileUseCase.fetchUserInfo(nickname)
                self?.profileUseCase.fetchRecordList(nickname: nickname, from: 0, by: 5)
            })
            .disposed(by: disposeBag)
        
        input.scrollEvent
            .subscribe(onNext: { [weak self] in
                guard let index = self?.recordInfo.count,
                      let nickname = self?.mateInfo?.nickname,
                      let hasNextPage = self?.hasNextPage else { return }
                if hasNextPage {
                    self?.profileUseCase.fetchRecordList(nickname: nickname, from: index, by: 5)
                }
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
                self?.recordInfo.append(contentsOf: record)
                if record.count < 5 {
                    self?.hasNextPage = false
                }
                output.loadRecord.accept(true)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            self.profileUseCase.userInfo,
            self.profileUseCase.recordInfo,
            resultSelector: { _, _ in
                return(true)
            })
            .subscribe(onNext: { _ in
                output.reloadData.accept(true)
            })
            .disposed(by: disposeBag)
        
        self.profileUseCase.selectEmoji
            .subscribe(onNext: { [weak self] emoji in
                self?.selectEmoji.onNext(emoji)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func moveToDetail(record: RunningResult) {
        self.coordinator?.pushRecordDetailViewController(with: record)
    }
    
    func moveToEmoji(record: RunningResult) {
        self.coordinator?.presentEmojiModal(
            connectedTo: self.profileUseCase,
            mate: self.mateInfo?.nickname ?? "",
            runningID: record.runningID
        )
    }
    
    func fetchUserNickname() -> String? {
        return self.profileUseCase.fetchUserNickname()
    }
    
    func removeEmoji(runningID: String, mate: String) {
        guard let index = self.selectedIndex,
              let nickname = self.fetchUserNickname() else { return }
        self.recordInfo[index].removeEmoji(from: nickname)
        self.profileUseCase.deleteEmoji(from: runningID, of: mate)
    }
}
