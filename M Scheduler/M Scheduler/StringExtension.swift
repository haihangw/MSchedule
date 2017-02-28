//
//  StringExtension.swift
//  M Scheduler
//
//  Created by 叶亚鑫 on 15/12/10.
//  Copyright © 2015年 SubWay. All rights reserved.
//

import Foundation
import UIKit


// create functions to access string and integer
extension String {
    
    subscript(integerIndex: Int) -> Character {
        let index = characters.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
    
    subscript(integerRange: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = characters.index(startIndex, offsetBy: integerRange.upperBound)
        let range = start..<end
        return self[range]
    }
}
