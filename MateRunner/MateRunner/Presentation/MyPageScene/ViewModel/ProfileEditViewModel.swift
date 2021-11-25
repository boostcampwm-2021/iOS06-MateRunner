//
//  ProfileEditViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

import RxRelay
import RxSwift

final class ProfileEditViewModel {
    private weak var profileEditCoordinator: ProfileEditCoordinator?
    private let profileEditUseCase: ProfileEditUseCase
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let heightTextFieldDidTapEvent: Observable<Void>
        let heightPickerSelectedRow: Observable<Int>
        let weightTextFieldDidTapEvent: Observable<Void>
        let weightPickerSelectedRow: Observable<Int>
        let doneButtonDidTapEvent: Observable<Void>
    }
    
    struct Output {
        var heightFieldText = BehaviorRelay<String>(value: "")
        var heightRange = BehaviorRelay<[String]>(value: [Int](100...250).map { "\($0) cm" })
        var heightPickerRow = BehaviorRelay<Int?>(value: nil)
        var weightFieldText = BehaviorRelay<String>(value: "")
        var weightRange = BehaviorRelay<[String]>(value: [Int](20...300).map { "\($0) kg" })
        var weightPickerRow = BehaviorRelay<Int?>(value: nil)
        var nickname = BehaviorRelay<String>(value: "")
    }
    
    init(profileEditCoordinator: ProfileEditCoordinator, profileEditUseCase: ProfileEditUseCase) {
        self.profileEditCoordinator = profileEditCoordinator
        self.profileEditUseCase = profileEditUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        self.configureInput(input, disposeBag: disposeBag)
        return self.createOutput(from: input, disposeBag: disposeBag)
    }
    
    private func configureInput(_ input: Input, disposeBag: DisposeBag) {
        input.viewDidLoadEvent
            .subscribe(onNext: { [weak self] in
                self?.profileEditUseCase.loadUserInfo()
            })
            .disposed(by: disposeBag)
        
        input.heightTextFieldDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.profileEditUseCase.getCurrentHeight()
            })
            .disposed(by: disposeBag)
        
        input.heightPickerSelectedRow
            .map { $0 + 100 }
            .bind(to: self.profileEditUseCase.height)
            .disposed(by: disposeBag)
        
        input.weightTextFieldDidTapEvent
            .subscribe(onNext: { [weak self] in
                self?.profileEditUseCase.getCurrentWeight()
            })
            .disposed(by: disposeBag)
        
        input.weightPickerSelectedRow
            .map { $0 + 20 }
            .bind(to: self.profileEditUseCase.weight)
            .disposed(by: disposeBag)
    }
    
    private func createOutput(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.profileEditUseCase.height
            .compactMap { $0 }
            .subscribe(onNext: { height in
                let row = height - 100
                output.heightPickerRow.accept(row)
                output.heightFieldText.accept(output.heightRange.value[row])
            })
            .disposed(by: disposeBag)
        
        self.profileEditUseCase.weight
            .compactMap { $0 }
            .subscribe(onNext: { weight in
                let row = weight - 20
                output.weightPickerRow.accept(row)
                output.weightFieldText.accept(output.weightRange.value[row])
            })
            .disposed(by: disposeBag)
        
        self.profileEditUseCase.nickname
            .compactMap { $0 }
            .bind(to: output.nickname)
            .disposed(by: disposeBag)
        
        return output
    }
}
