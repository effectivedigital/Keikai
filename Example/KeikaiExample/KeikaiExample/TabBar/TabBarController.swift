//
//  TabBarController.swift
//  KeikaiExample
//
//  Created by Aashish Tamsya on 03/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
  static func tabBarViewController() -> TabBarController {
    return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
  }
}
