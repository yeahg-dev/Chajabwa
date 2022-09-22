//
//  SummaryCollectionViewCell.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/09/20.
//

import UIKit

final class SummaryCollectionViewCell: UICollectionViewCell {
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        userRatingView, contentAdvisoryView, providerView, genreView, languageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let userRatingView = RatingTypeSummaryView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 70)))
    private let contentAdvisoryView = StandardTypeSummaryView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 70)))
    private let providerView = StandardTypeSummaryView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 70)))
    private let genreView = StandardTypeSummaryView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 70)))
    private let languageView = StandardTypeSummaryView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 70)))
    override init(frame: CGRect) {
        super.init(frame: frame)
        confiugreConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
