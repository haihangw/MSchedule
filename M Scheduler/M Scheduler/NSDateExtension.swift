//
//  NSDateExtension.swift
//  M Scheduler
//
//  Created by Hedge Wang on 12/11/15.
//  Copyright © 2015 SubWay. All rights reserved.
//

import Foundation

// create function help compare the NSDates
extension Date
{
    func isGreaterThanDate(_ dateToCompare : Date) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    func isLessThanDate(_ dateToCompare : Date) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }

}
