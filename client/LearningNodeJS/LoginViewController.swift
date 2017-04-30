//
//  LoginViewController.swift
//  LearningNodeJS
//
//  Created by Gocy on 2017/4/27.
//  Copyright © 2017年 Gocy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
 
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tryLogin(_ sender: Any) {
        if let name = usernameTextField.text, name.characters.count > 0{
            RequestManager.default.login(usingName: name){
                [weak self] success in
                if (success){
                    DispatchQueue.main.async {
                        let chatVC = AppDelegate.chatViewController()
                        chatVC.userName = name
                        self?.navigationController?.pushViewController(chatVC, animated: true)
                    }
                }else{
                    print("Login Failed")
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension AppDelegate{
    static func chatViewController() -> ChatViewController{
       return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Chat") as! ChatViewController
    }
}
