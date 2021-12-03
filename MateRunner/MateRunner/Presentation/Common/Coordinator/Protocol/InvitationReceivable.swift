//
//  InvitationReceivable.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/28.
//

import Foundation

protocol InvitationReceivable: AnyObject {
    func invitationDidReceive(_ notification: Notification)
    func invitationDidAccept(with settingData: RunningSetting)
    func invitationDidReject()
}
