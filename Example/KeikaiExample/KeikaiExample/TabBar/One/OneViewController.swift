//
//  OneViewController.swift
//  KeikaiExample
//
//  Created by Aashish Tamsya on 03/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit
import Keikai

final class OneViewController: UIViewController {
  
}

// MARK: - @IBActions
private extension OneViewController {
  @IBAction func showButtonSelected(_ sender: UIButton) {
    let keikai = KeikaiView(message: "Hello world! from one", duration: .long)
    keikai.show()
  }
}
