//
//  KFModel.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-09.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFModel: NSObject{

    var guid = "";
    
    override init(){
    }
    
    func detach(observer:AnyObject){
        NSNotificationCenter.defaultCenter().removeObserver(observer, name: "CHANGED", object: self);
    }
    
    func attach(observer:AnyObject, selector:Selector){
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: "CHANGED", object: self);
    }
    
    func notify(){
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "CHANGED", object: self));
    }

    override func isEqual(object: AnyObject!) -> Bool{
        if let model = object as? KFModel{
            return guid == model.guid;
        }else{
            return false;
        }
    }
    
    override var description: String {
        return "a KFModel: \(guid)";
    }
    
    func toString() -> String {
        return description;
    }
    

}

func ==(left: KFModel, right: KFModel) -> Bool{
    return left.guid == right.guid;
}

