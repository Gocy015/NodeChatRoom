//
//  ChatViewController.swift
//  LearningNodeJS
//
//  Created by Gocy on 2017/4/27.
//  Copyright © 2017年 Gocy. All rights reserved.
//

import UIKit

let reuse = "node.chatcell"

class ChatViewController: UIViewController {

    @IBOutlet weak var inputTextFieldBottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputTextField: UITextField!{
        didSet{
            inputTextField.delegate = self
        }
    }
    @IBOutlet weak var chatTableView: UITableView!{
        didSet{
            chatTableView.delegate = self
            chatTableView.dataSource = self
            chatTableView.tableFooterView = UIView()
            chatTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuse)
        }
    }
    
    fileprivate var chats = [String]() 
    public var userName : String = "Anonymous"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = "Disconnected."
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(noti:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(noti:)), name: .UIKeyboardWillHide, object: nil)
        RequestManager.default.disconnect()
        self.connectToChatServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        RequestManager.default.disconnect()
    }
    
}

extension ChatViewController: UITableViewDelegate ,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse, for: indexPath)
        cell.textLabel?.text = chats[indexPath.row]
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.inputTextField.resignFirstResponder()
    }
}

//MARK: TextField & keyboard
extension ChatViewController :UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            self.send(text)
        }
        textField.text = nil
        return true
    }
    func keyboardWillShow(noti:Notification){
        guard let frame = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        self.inputTextFieldBottomSpaceConstraint.constant = frame.size.height
    }
    func keyboardWillHide(noti:Notification){
        guard ((noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil else{
            return
        }
        self.inputTextFieldBottomSpaceConstraint.constant = 0
    }
}

//MARK: Network
extension ChatViewController{
    func connectToChatServer(){
        self.title = "Connecting .."
        
        weak var wself = self
        RequestManager.default.connectToServer(
            name:self.userName,
            open: {
            wself?.title = "Connected."
        },
            close: { (code, reason, clean) in
                wself?.title = "Connection Closed."
                
        },
            error: { (error) in
                wself?.title = "Connection Error."
                
        }) { (data) in
            if let msg = data as? String{
                DispatchQueue.main.async {
                    wself?.chats.append(msg)
                    wself?.chatTableView.reloadData()
                }
            }
        }
    }
    
    func send(_ msg:String){
        RequestManager.default.send(text: "\(self.userName) : \(msg)")
    }
}
