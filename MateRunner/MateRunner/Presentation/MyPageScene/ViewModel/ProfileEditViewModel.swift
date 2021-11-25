//
//  ProfileEditViewModel.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/24.
//

import Foundation

final class ProfileEditViewModel {
    private weak var profileEditCoordinator: ProfileEditCoordinator?
    private let profileEditUseCase: ProfileEditUseCase
    
    init(
        profileEditCoordinator: ProfileEditCoordinator,
        profileEditUseCase: ProfileEditUseCase
    ) {
        self.profileEditCoordinator = profileEditCoordinator
        self.profileEditUseCase = profileEditUseCase
    }
}
