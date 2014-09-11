//
//  KFStack.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-09-10.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

import UIKit

class KFStack<T>: NSObject {
    
    private var objects:Array<T> = [];
    private var cursor = 0;
    
    func push(obj:T){
        objects.append(obj);
        cursor++;
    }
    
    func pop() -> T{
        cursor--;
        return objects.removeAtIndex(cursor);
    }
    
    func peek() -> T{
        return objects[cursor-1];
    }
    
    func isEmpty() -> Bool{
        return cursor <= 0;
    }
    
    func clear(){
        objects.removeAll(keepCapacity: false);
        cursor = 0;
    }
   
}
