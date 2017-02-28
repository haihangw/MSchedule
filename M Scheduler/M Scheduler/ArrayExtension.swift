//
//  ArrayExtension.swift
//  M Scheduler
//
//  Created by Hedge Wang on 12/12/15.
//  Copyright © 2015 SubWay. All rights reserved.
//

import Foundation

extension Array {
    
    // create the function to generate random course
    func randomItem() -> Element? {
        if self.count == 0 {
            return nil
        } else {
            let index = Int(arc4random_uniform(UInt32(self.count)))
            return self[index]
        }
    }
}
