//
//  KeikaiView.swift
//  Keikai
//
//  Created by Aashish Tamsya on 03/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation

open class KeiKaiView: UIView {
  // MARK: - Properties
  fileprivate static let defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 320, height: 44)
  fileprivate static let minimumHeight: CGFloat = 44
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override init(frame: CGRect) {
    super.init(frame: KeiKaiView.defaultFrame)
    configure()
  }
 
  public init() {
    super.init(frame: KeiKaiView.defaultFrame)
    configure()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
// MARK: - Private Methods
private extension KeiKaiView {
  func configure() { }
}
