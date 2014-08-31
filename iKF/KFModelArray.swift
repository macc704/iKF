//
//  KFModelArray.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-08-31.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFModelArray<T:KFModel> {
   
    var array:[T] = [];
    var dic:[String:T] = [:];
    
    func add(element:T){
        array.append(element);
        dic[element.guid] = element;
    }
    
    func remove(element:T){
        let index = indexOf(element);
        if(index == -1){
            return;// not found
        }
        array.removeAtIndex(index);
        dic.removeValueForKey(element.guid);
    }
    
    func indexOf(element:T) -> Int{
        let size = array.count;
        for (var i=0; i<size; i++){
            let item = array[i];
            if(item.guid == element.guid){
                return i;
            }
        }
        return -1;
    }
    
}
