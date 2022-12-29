//
//  SearchBackgroundView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/25.
//

import UIKit

protocol SearchBackgroundViewPresentaionDelegate: AnyObject {
    
    func presentSettingView(view: SettingViewController.Type)
    
}

final class SearchBackgroundView: UIView {
    
    weak var presentationDelegate: SearchBackgroundViewPresentaionDelegate?
    
    private lazy var countryStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [flagButton, countryNameButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let flagButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 90)
        button.addTarget(
            self,
            action: #selector(presentSettingView),
            for: .touchUpInside)
        return button
    }()
    
    private let countryNameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(
            ofSize: 23,
            weight: .semibold)
        button.addTarget(
            self,
            action: #selector(presentSettingView),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var iPhoneButton: PlatformButton = {
        let button = PlatformButton(type: .iPhone)
        button.addTarget(
            self,
            action: #selector(iPhoneButtonDidTapped),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var iPadButton: PlatformButton = {
        let button = PlatformButton(type: .iPad)
        button.addTarget(
            self,
            action: #selector(iPadButtonDidTapped),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var macButton: PlatformButton = {
        let button = PlatformButton(type: .mac)
        button.addTarget(
            self,
            action: #selector(macButtonDidTapped),
            for: .touchUpInside)
        return button
    }()
    
    private var animatableArrowLayer: AnimatableArrowLayer = {
        let layer = AnimatableArrowLayer(
            center: CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height),
            radius: UIScreen.main.bounds.width * 0.55 + 10)
        return layer
    }()
    
    private var smallCirclePath: UIBezierPath?
    
    @objc func presentSettingView() {
        presentationDelegate?.presentSettingView(
            view: SettingViewController.self)
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "background")
        self.addSubview(countryStackView)
        self.addSubview(iPhoneButton)
        self.addSubview(iPadButton)
        self.addSubview(macButton)
    }
    
    @objc func iPhoneButtonDidTapped() {
        iPhoneButton.isSelected = true
        if iPadButton.isSelected {
            iPadButton.isSelected.toggle()
        }
        if macButton.isSelected {
            macButton.isSelected.toggle()
        }
        animatableArrowLayer.animate(to: ArrowAngle.iPhone.angle)
        AppSearchingConfiguration.setSoftwareType(by: .iPhone)
    }
    
    @objc func iPadButtonDidTapped() {
        iPadButton.isSelected = true
        if iPhoneButton.isSelected {
            iPhoneButton.isSelected.toggle()
        }
        if macButton.isSelected {
            macButton.isSelected.toggle()
        }
        animatableArrowLayer.animate(to: ArrowAngle.iPad.angle)
        AppSearchingConfiguration.setSoftwareType(by: .iPad)
    }
    
    @objc func macButtonDidTapped() {
        macButton.isSelected = true
        if iPhoneButton.isSelected {
            iPhoneButton.isSelected.toggle()
        }
        if iPadButton.isSelected {
            iPadButton.isSelected.toggle()
        }
        animatableArrowLayer.animate(to: ArrowAngle.mac.angle)
        AppSearchingConfiguration.setSoftwareType(by: .mac)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configurelayout()
    }
    
    override func draw(_ rect: CGRect) {
        let centerPoint = CGPoint(x: rect.midX, y: rect.height)
        let largeRadius = rect.width * 0.72
        let largeCirclePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: largeRadius,
            startAngle: .pi,
            endAngle: 2 * .pi,
            clockwise: true)
        let largeCircleColor = UIColor(named: "largeCircle")!
        largeCircleColor.setFill()
        largeCirclePath.fill()
        let smallRadius = rect.width * 0.55
        let smallCirclePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: smallRadius,
            startAngle: .pi,
            endAngle: 2 * .pi,
            clockwise: true)
        let smallCircleColor = UIColor.systemGray5
        smallCircleColor.setFill()
        smallCirclePath.fill()

        self.layer.addSublayer(animatableArrowLayer)
    }
    
    func bindPlatform(_ type: SoftwareType) {
        switch type {
        case .iPhone:
            iPhoneButton.isSelected = true
            animatableArrowLayer.setPosition(ArrowAngle.iPhone.angle)
        case .iPad:
            iPadButton.isSelected = true
            animatableArrowLayer.setPosition(ArrowAngle.iPad.angle)
        case .mac:
            macButton.isSelected = true
            animatableArrowLayer.setPosition(ArrowAngle.mac.angle)
        }
    }
    
    func bindCountry(flag: String, name: String) {
        flagButton.setTitle(flag, for: .normal)
        countryNameButton.setTitle(name, for: .normal)
    }
    
    private func configurelayout() {
        let smallCircleRadius = frame.width * 0.6
        NSLayoutConstraint.activate([
            countryStackView.centerYAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: -smallCircleRadius * 0.5),
            countryStackView.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            iPhoneButton.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            iPhoneButton.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: -UIScreen.main.bounds.width * 0.58),
            iPadButton.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: -UIScreen.main.bounds.width * 0.485),
            iPadButton.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: UIScreen.main.bounds.width * 0.06),
            macButton.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: -UIScreen.main.bounds.width * 0.48),
            macButton.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -UIScreen.main.bounds.width * 0.06)
        ])
    }
    
}

extension SearchBackgroundView {
    
    private enum ArrowAngle {
        
        case iPad
        case iPhone
        case mac
        
        var angle: CGFloat {
            switch self {
            case .iPad:
                return 1.31 * .pi
            case .iPhone:
                return 1.5 * .pi
            case .mac:
                return 1.7 * .pi
            }
        }
        
    }
    
}
