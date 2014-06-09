//
//  KFUser.swift
//  iKF
//
//  Created by Yoshiaki Matsuzawa on 2014-06-06.
//  Copyright (c) 2014 Yoshiaki Matsuzawa. All rights reserved.
//

class KFUser: KFModel {

    var firstName = "";
    var lastName = "";

    func getFullName() -> String{
        return self.firstName + " " + self.lastName;
    }
}
