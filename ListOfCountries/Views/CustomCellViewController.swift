//
//  CustomCellViewController.swift
//  ListOfCountries
//
//  Created by Zak Mills on 6/16/25.
//

import UIKit

class CustomCellViewController: UITableViewCell {
    
    let mainTextLabel = UILabel()
    let secondaryTextLabel = UILabel()
    let trailingTextLabel = UILabel()
    let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        configureCellStyle()
        configureContainerView()
        configureMainTextLabel()
        configureSecondaryTextLabel()
        configureTrailingTextLabel()
        applyConstraints()
    }
    
    private func configureCellStyle() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    private func configureContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
    }
    
    private func configureMainTextLabel() {
        mainTextLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        mainTextLabel.adjustsFontForContentSizeCategory = true
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(mainTextLabel)
    }
    
    private func configureSecondaryTextLabel() {
        secondaryTextLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        secondaryTextLabel.adjustsFontForContentSizeCategory = true
        secondaryTextLabel.textColor = .gray
        secondaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(secondaryTextLabel)
    }
    
    private func configureTrailingTextLabel() {
        trailingTextLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        trailingTextLabel.adjustsFontForContentSizeCategory = true
        trailingTextLabel.textAlignment = .right
        trailingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(trailingTextLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            mainTextLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            mainTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingTextLabel.leadingAnchor, constant: -12),
            
            
            secondaryTextLabel.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 8),
            secondaryTextLabel.leadingAnchor.constraint(equalTo: mainTextLabel.leadingAnchor),
            secondaryTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingTextLabel.leadingAnchor, constant: -12),
            secondaryTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),
            
            
            trailingTextLabel.topAnchor.constraint(equalTo: mainTextLabel.topAnchor),
            trailingTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            trailingTextLabel.widthAnchor.constraint(lessThanOrEqualTo: containerView.widthAnchor, multiplier: 0.4)
        ])
    }
    
    func configure(mainText: String, secondaryText: String, trailingText: String) {
        mainTextLabel.text = mainText
        secondaryTextLabel.text = secondaryText
        trailingTextLabel.text = trailingText
    }
}
