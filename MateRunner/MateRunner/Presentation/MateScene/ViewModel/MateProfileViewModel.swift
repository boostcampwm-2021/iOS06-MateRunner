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
    private let fetchRecordCount = 5
    weak var coordinator: MateProfileCoordinator?
    var selectEmoji: PublishSubject<Emoji> = PublishSubject()
    var mateInfo: UserData?
    var recordInfo: [RunningResult] = []
    var selectedIndex: Int?
    var hasNextPage: Bool = true
    var refreshStatus = false
    
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
         coordinator: MateProfileCoordinator?,
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
        
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                guard let nickname = self?.mateInfo?.nickname,
                      let fetchCount = self?.fetchRecordCount else { return }
                self?.profileUseCase.fetchUserInfo(nickname)
                self?.profileUseCase.fetchRecordList(nickname: nickname, from: 0, by: fetchCount)
            })
            .disposed(by: disposeBag)
        
        input.refreshEvent
            .subscribe(onNext: { [weak self] in
                guard let nickname = self?.mateInfo?.nickname,
                      let totalCount = self?.recordInfo.count else { return }
                self?.profileUseCase.fetchUserInfo(nickname)
                self?.profileUseCase.fetchRecordList(nickname: nickname, from: 0, by: totalCount)
                self?.refreshStatus = true
            })
            .disposed(by: disposeBag)
        
        input.scrollEvent
            .subscribe(onNext: { [weak self] in
                guard let index = self?.recordInfo.count,
                      let nickname = self?.mateInfo?.nickname,
                      let fetchCount = self?.fetchRecordCount,
                      let hasNextPage = self?.hasNextPage else { return }
                if hasNextPage {
                    self?.profileUseCase.fetchRecordList(nickname: nickname, from: index, by: fetchCount)
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
            .subscribe(onNext: { [weak self] recordList in
                guard let fetchCount = self?.fetchRecordCount,
                      let self = self else { return }
                switch recordList.count {
                case 0...fetchCount-1: // 페이지네이션 마지막 페이지일때
                    self.refreshStatus
                    ? self.recordInfo = recordList
                    : self.recordInfo.append(contentsOf: recordList)
                    self.hasNextPage = false
                case fetchCount+1..<Int.max: // 5개 이상 fetch 했을 때 refresh
                    self.recordInfo = recordList
                default: // 5개를 fetch -> 5개인 상태에서 refresh / 페이지네이션 더해질때
                    (self.recordInfo.count == fetchCount && self.refreshStatus)
                    ? self.recordInfo = recordList
                    : self.recordInfo.append(contentsOf: recordList)
                    self.refreshStatus = false
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
