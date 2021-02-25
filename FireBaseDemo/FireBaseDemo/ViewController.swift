//
//  ViewController.swift
//  FireBaseDemo
//
//  Created by Vijay on 24/02/21.
//

import UIKit
import FirebaseDatabase

var ObjUserData : [UserData] = []
var tmpUserData : [UserData] = []
var key = ""
class ViewController: UIViewController {
    
   
    var ref = Database.database().reference()
    @IBOutlet weak var txtOutletName: UITextField!
    @IBOutlet weak var txtOutletMono: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       // ObjUserData = readAllFIRData()
        
      //   getSingleDataUserData()
       // print(" Single Data:", ObjUserData)
        
        //updateSingleUserData()
       // updateSingleUserData(UserId: 4)
        
///// ### Update Closure
        getKeyOfUserData(userId: 4)   { key,isSuccess  in
             if isSuccess
             {
                print("Inside Clouser", key)
                //self.updateSingleUserData(key: key)
             }
            else
             {
                
             }
        }
        print( "OutSide Clouser")
//////// ###
   
    }

    @IBAction func btnDeleteTouchUp(_ sender: UIButton) {
        getKeyOfUserData(userId: 2) { (key, isSuccess) in
            if isSuccess
            {
                self.deleteSingleData(key: key)
            }
        }
    }
    @IBAction func btnActionSaveTouchUpInside(_ sender: UIButton) {
        saveFIRData(userid: 2, username: txtOutletName.text!, usermono: txtOutletMono.text!)
    }
    
    func saveFIRData(userid: Int, username: String, usermono: String) {
        let dicUserData = ["userid": userid , "username": username, "usermono": usermono] as [String : Any]
        self.ref.child("user").childByAutoId().setValue(dicUserData)
        //readAllFIRData()
    }
    
    func readAllFIRData() -> [UserData] {
        tmpUserData.removeAll()
        ref = Database.database().reference()
        ref.child("user").observe(.value, with: { (snapshot) in
        print("print Inside readAllFIRData \n user: \(snapshot)")

        if(snapshot.exists()) {
            let array:NSArray = snapshot.children.allObjects as NSArray

            for obj in array {
                let snapshot:DataSnapshot = obj as! DataSnapshot
                print("Here Key",  snapshot.key)
                let key = snapshot.key
                if let childSnapshot = snapshot.value as? [String : AnyObject]
                     {
                        let userId = childSnapshot["userid"] as? Int
                    print("User ID-", userId as Any)
                         let userName = childSnapshot["username"] as? String
                    print("UserName-" , userName as Any )
                        let usermono = childSnapshot["usermono"] as? String
                    
                    print("User Mo NO-", usermono as Any)
                        tmpUserData.append(UserData(userKey: key, userId: userId!, userName: userName!, userMoNo: usermono!))
                }
            }

        }
         })
       return tmpUserData
    }
    
    func getKeyOfUserData(userId: Int, completion: @escaping (_ key: String, _ isSuccess: Bool) -> Void) {
        let query = ref.child("user").queryOrdered(byChild: "userid").queryEqual(toValue: userId)
        query.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let childSnap = child as! DataSnapshot
                print("childSnap.key",childSnap.key)
                key = childSnap.key
                completion(key, true)
            }
        })
    print("KEY inside Function:",key)
    }
    
    func getSingleDataUserData() {
        let query = ref.child("user").queryOrdered(byChild: "userid").queryEqual(toValue: 4)
        query.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let childSnap = child as! DataSnapshot
                let dict = childSnap.value as! [String: Any]
                let username = dict["username"] as! String
                let usermono = dict["usermono"] as! String
                print("\n\n DATA HERE:---",childSnap.key, username, usermono)
            }
        })
        
    }
    
    func updateSingleUserData(key: String)  {
        let dic = ["userid": 1 , "username": "zzz", "usermono": "12121212"] as [String : Any]
       ref = Database.database().reference()
        ref.child("user").child(key).updateChildValues(dic)
        print("Update Record")
    }
    
    func deleteSingleData(key: String) {
        print("Delete KEY:", key)
            ref = Database.database().reference()
        self.ref.child("user").child(key).removeValue()
      //  FirebaseDatabase.Database.database().reference(withPath: "user").child(key).removeValue()
        print("Delete Success...")
    }
}


