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
  
  let viewWidth = UIScreen.main.bounds.width
  lazy var imageViews: [UIImageView] = []
  
  // MARK: Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(items: [String]) {
    self.init()
    imageViews = items.map { UIImageView(image: UIImage(named: $0)) }
    setupScrollView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupScrollView() {
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
