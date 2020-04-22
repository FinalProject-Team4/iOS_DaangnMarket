//
//  DGSegmentedControl.swift
//  DaangnMarket
//
//  Created by cskim on 2020/04/11.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol DGSegmentControlDelegate: class {
  func segmentControl(_ segmentControl: DGSegmentedControl, didSelectSegmeentAt index: Int)
}

class DGSegmentedControl: UIView {
  // MARK: Interface
  
  weak var delegate: DGSegmentControlDelegate?
  
  var numberOfSegments: Int {
    return self.segments.arrangedSubviews.count
  }
  
  var selectedSegmentIndex: Int = 0 {
    didSet {
      self.segments
        .arrangedSubviews
        .compactMap { $0 as? UIButton }
        .forEach { $0.isSelected = $0.tag == selectedSegmentIndex }
    }
  }
  
  func updateSelectedIndicator(offset: CGFloat, animated: Bool) {
    if animated {
      UIView.animate(withDuration: 0.25) {
        self.selectedSegmentIndicator.snp.updateConstraints {
          $0.leading.equalToSuperview().offset(offset)
        }
        self.layoutIfNeeded()
      }
    } else {
      self.selectedSegmentIndicator.snp.updateConstraints {
        $0.leading.equalToSuperview().offset(offset)
      }
    }
    
    self.selectedSegmentIndex = self.segments
      .arrangedSubviews
      .filter { $0.frame.contains(self.selectedSegmentIndicator.center) }
      .map { $0.tag }.first ?? 0
  }
  
  // MARK: Views
  
  private var segments = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.distribution = .fillEqually
    $0.spacing = 0
  }
  private var selectedSegmentIndicator = UIView().then {
    $0.backgroundColor = .black
  }
  
  // MARK: Initialize
  
  init(items: [String]) {
    super.init(frame: .zero)
    self.setupAttributes(for: items)
    self.setupConstraints()
  }
  
  private func setupAttributes(for items: [String]) {
    items.enumerated().map { (index, item) in
      UIButton().then {
        $0.setTitle(item, for: .normal)
        $0.setTitleColor(.black, for: .selected)
        $0.setTitleColor(.gray, for: .normal)
        $0.addTarget(self, action: #selector(didTapSegment), for: .touchUpInside)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        $0.tag = index
        $0.isSelected = index == 0
      }
    }
    .forEach { self.segments.addArrangedSubview($0) }
  }
  
  private func setupConstraints() {
    self.segments
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.edges.equalToSuperview()
    }
    
    UIView()    // Underline
      .then {
        $0.backgroundColor = .gray
        self.addSubview($0)
      }
      .snp.makeConstraints {
        $0.leading.trailing.bottom.equalToSuperview()
        $0.height.equalTo(1)
      }
    
    self.selectedSegmentIndicator
      .then { self.addSubview($0) }
      .snp.makeConstraints {
        $0.leading.bottom.equalToSuperview()
        $0.width.equalTo(self.segments.arrangedSubviews.first ?? self)
        $0.height.equalTo(2)
    }
  }
  
  // MARK: Actions
  
  @objc func didTapSegment(_ sender: UIButton) {
    self.selectedSegmentIndex = sender.tag
    let offset = (self.segments.arrangedSubviews.first?.frame.width ?? 0) * CGFloat(sender.tag)
    self.updateSelectedIndicator(offset: offset, animated: true)
    self.delegate?.segmentControl(self, didSelectSegmeentAt: sender.tag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
