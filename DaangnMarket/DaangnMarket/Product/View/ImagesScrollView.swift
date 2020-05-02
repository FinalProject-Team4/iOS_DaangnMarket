//
//  ImagesScrollView.swift
//  DaangnMarket
//
//  Created by JinGyung Kim on 2020/04/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ImagesScrollView: UIScrollView {
  // MARK: Views
  
  private let viewWidth = UIScreen.main.bounds.width
  lazy var imageViews: [UIImageView] = []
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(items: [String]) {
    self.init()
    //imageViews = items.map { UIImageView(image: UIImage(named: $0)) }
    for idx in items {
      let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.kf.setImage(with: URL(string: idx))
      }
      imageViews.append(imageView)
    }
    setupScrollView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupScrollView() {
    self.isPagingEnabled = true
    self.showsVerticalScrollIndicator = false
    self.showsHorizontalScrollIndicator = false
    self.contentSize = CGSize(width: viewWidth * CGFloat(imageViews.count), height: viewWidth)
    
    imageViews.enumerated().forEach { (index, imageView) in
      imageView.frame = CGRect(x: viewWidth * CGFloat(index), y: 0, width: viewWidth, height: viewWidth)
      imageView.contentMode = .scaleAspectFill
      self.addSubview(imageView)
    }
  }
}
