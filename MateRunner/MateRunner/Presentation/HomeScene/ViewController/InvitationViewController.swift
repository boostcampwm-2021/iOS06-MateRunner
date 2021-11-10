//
//  InvitationViewController.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/10.
//

import UIKit

final class InvitationViewController: UIViewController {
    private lazy var descriptionModeLabel = self.createDescriptionLabel(text: "함께할 달리기")
    private lazy var descriptionDistanceLabel = self.createDescriptionLabel(text: "목표거리")
    
    private lazy var invitationView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .notoSans(size: 18, family: .bold)
        return label
    }()
    
    private lazy var lineView: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        return line
    }()
    
    private lazy var runningMode: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 20, family: .bold)
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSansBoldItalic(size: 50)
        return label
    }()
    
    private lazy var kilometerLabel: UILabel = {
        let label = UILabel()
        label.font = .notoSans(size: 18, family: .light)
        label.textColor = .gray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackview = UIStackView()
        return stackview
    }()
    
    private lazy var refuseButton = self.createInviteButton(text: "거절", color: .mrGray)
    private lazy var acceptButton = self.createInviteButton(text: "수락", color: .mrPurple)
}

// MARK: - Private Functions

private extension InvitationViewController {
    func createDescriptionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .notoSans(size: 16, family: .bold)
        label.text = text
        label.textAlignment = .center
        return label
    }
    
    func createInviteButton(text: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .notoSans(size: 18, family: .bold)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        return button
    }
}
