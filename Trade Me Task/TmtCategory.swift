//
//  TmtCategory.swift
//  Trade Me Task
//
//  Created by Yanbing Peng on 20/04/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

import Foundation

class TmtCategory: NSObject {
    var cateName : String?
    var cateNumber : String?
    var catePath : String?
    var cateCount : Int?
    var cateIsRestricted : Bool?
    var cateHasLegalNotice : Bool?
    var cateHasClassifieds : Bool?
    
    var cateSubCategories = [TmtCategory]()
    
    override var description: String{
        get{
            var content :String = ""
            content += ((cateName != nil) ? "Name: \(cateName!)\n" : "")
            content += ((cateNumber != nil) ? "Number: \(cateNumber!)\n" : "")
            content += ((catePath != nil) ? "Path: \(catePath!)\n" : "")
            content += ((cateCount != nil) ? "Count: \(cateCount!)\n" : "")
            content += ((cateIsRestricted != nil) ? "IsRestricted: \(cateIsRestricted!)\n" : "")
            content += ((cateHasLegalNotice != nil) ? "HasLegalNotice: \(cateHasLegalNotice!)\n" : "")
            content += ((cateHasClassifieds != nil) ? "HasClassifieds: \(cateHasClassifieds!)\n" : "")
            
            if cateSubCategories.count > 0{
                content += "SubCategories:\n["
                for subCategory in cateSubCategories{
                    content += "\(subCategory)"
                }
                content += "]\n"
            }
            
            return content
        }
    }
}