//
//  SummaryCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/20.
//

import UIKit

final class SummaryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Design used in DetailView
    
    static let cellWidth = Design.summaryViewWidth * 5 + Design.stackViewSpacing * 4
    static let cellHeight = Design.summaryViewHeight
    
    // MARK: - UI Components
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        userRatingView, contentAdvisoryView, providerView, genreView, languageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = Design.stackViewSpacing
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let userRatingView = RatingTypeSummaryView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: Design.summaryViewWidth,
                height: Design.summaryViewHeight)))
    
    private let contentAdvisoryView = StandardTypeSummaryView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: Design.summaryViewWidth,
                height: Design.summaryViewHeight)))
    
    private let providerView = StandardTypeSummaryView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: Design.summaryViewWidth,
                height: Design.summaryViewHeight)))
    
    private let genreView = StandardTypeSummaryView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: Design.summaryViewWidth,
                height: Design.summaryViewHeight)))
    
    private let languageView = StandardTypeSummaryView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(
                width: Design.summaryViewWidth,
                height: Design.summaryViewHeight)))
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        languageView.hasSeperator = false
        confiugreConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func bind(model: AppDetailViewModel.Item) {
        if case let .summary(summary) = model {
            userRatingView.bind(
                primaryText: summary.userRatingPrimaryText,
                symbolImage: summary.userRatingSymbolImage,
                rating: summary.userRatingSecondaryValue)
            
            contentAdvisoryView.bind(
                primaryText: summary.contentAdivisoryRatingPrimaryText,
                symbolImage: summary.contentAdivisoryRatingSymbolImage,
                secondaryText: summary.contentAdivisoryRatingSecondaryText)
            
            providerView.bind(
                primaryText: summary.providerPrimaryText,
                symbolImage: summary.providerSymbolImage,
                secondaryText: summary.providerSecondaryText)
            
            genreView.bind(
                primaryText: summary.genrePrimaryText,
                symbolImage: summary.genreSymbolImage,
                secondaryText: summary.genreSecondaryText)
            
            languageView.bind(
                primaryText: summary.languagePrimaryText,
                symbolImage: summary.languageSymbolImage,
                secondaryText: summary.languageSecondaryText)
        }
    }
    
    // MARK: - Layout
    
    private func confiugreConstraints() {
        addSubview(containerStackView)
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}

// MARK: - Design

private enum Design {
    
    // size
    static let summaryViewWidth: CGFloat = 100
    static let summaryViewHeight: CGFloat = 70
    
    // spacing
    static let stackViewSpacing: CGFloat = 5
    
}
