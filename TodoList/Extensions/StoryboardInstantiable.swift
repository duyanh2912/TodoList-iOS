//
//  Instantiable.swift
//  EmojiDictionary
//
//  Created by Duy Anh on 6/11/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInstantiable {
    static var storyboardID: String { get }
    static var storyboardName: AppStoryboard { get }

    static func instantiate() -> Self
}

extension StoryboardInstantiable where Self: UIViewController {
    static var storyboardID: String { return "\(self)" }
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardID) as! Self
    }
}
