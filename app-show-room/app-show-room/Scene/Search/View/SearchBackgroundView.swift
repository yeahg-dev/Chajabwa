//
//  SearchBackgroundView.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/25.
//

import UIKit

final class SearchBackgroundView: UIView {
    
    private lazy var countryStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [flagLabel, countryNameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let flagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 90)
        label.textAlignment = .center
        return label
    }()
    
    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        label.textAlignment = .center
        return label
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "background")
        self.addSubview(countryStackView)
        self.addSubview(iPhoneButton)
        self.addSubview(iPadButton)
        self.addSubview(macButton)
    }
    
    @objc func iPhoneButtonDidTapped() {
        if iPadButton.isSelected {
            iPadButton.isSelected.toggle()
        }
        if macButton.isSelected {
            macButton.isSelected.toggle()
        }
        iPhoneButton.isSelected.toggle()
    }
    
    @objc func iPadButtonDidTapped() {
        if iPhoneButton.isSelected {
            iPhoneButton.isSelected.toggle()
        }
        if macButton.isSelected {
            macButton.isSelected.toggle()
        }
        iPadButton.isSelected.toggle()
    }
    
    @objc func macButtonDidTapped() {
        if iPhoneButton.isSelected {
            iPhoneButton.isSelected.toggle()
        }
        if iPadButton.isSelected {
            iPadButton.isSelected.toggle()
        }
        macButton.isSelected = true
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
        let smallCircleColor = UIColor(named: "smallCircle")!
        smallCircleColor.setFill()
        smallCirclePath.fill()
    }
    
    func bindPlatform(_ type: SoftwareType) {
        switch type {
        case .iPhone:
            iPhoneButton.isSelected = true
        case .iPad:
            iPadButton.isSelected = true
        case .mac:
            macButton.isSelected = true
        }
    }
    
    func bindCountry(flag: String, name: String) {
        flagLabel.text = flag
        countryNameLabel.text = name
    }
    
    private func configurelayout() {
        let countryY = frame.width * 0.8 * 4/5
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
