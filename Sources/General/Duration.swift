//
//  Duration.swift
//  Keikai
//
//  Created by Aashish Tamsya on 01/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation

public enum Duration: Int {
  case short   = 1
  case middle  = 3
  case long    = 5
  case forever = 2147483647// Must dismiss manually.
}
