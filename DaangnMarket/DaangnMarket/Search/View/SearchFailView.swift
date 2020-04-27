//
//  SearchFailView.swift
//  DaangnMarket
//
//  Created by 박지승 on 2020/04/20.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class SearchFailView: UIView {
  // MARK: Interface
  func updateFailKeyword(_ text: String) {
    failViewOfDeal.updateFailKeyword(text)
  }
  
  // MARK: Views
  private let failViewOfDeal: NoResultView
  private let failViewOfPerson = NoResultOfPersonView()
  
  // MARK: Interface
  init(town: String, type: SearchType) {
    failViewOfDeal = NoResultView(town: town, keyword: "", type: type)
    super.init(frame: .zero)
    setupFailView(type: type)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupFailView(type: SearchType) {
    if type == .person {
      self.addSubview(failViewOfPerson)
      failViewOfPerson.snp.makeConstraints {
        $0.edges.size.equalToSuperview()
      }
    } else {
      self.addSubview(failViewOfDeal)
      failViewOfDeal.snp.makeConstraints {
        $0.edges.size.equalToSuperview()
      }
    }
  }
}
