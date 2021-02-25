//
//  userClass.swift
//  FireBaseDemo
//
//  Created by Vijay on 25/02/21.
//

import Foundation
class UserData
{
    var userKey: String
    var userName: String
    var userID : Int
    var userMoNo: String
    init(userKey: String, userId: Int, userName: String, userMoNo: String) {
        self.userName = userName
        self.userID = userId
        self.userKey = userKey
        self.userMoNo = userMoNo
    }
}
