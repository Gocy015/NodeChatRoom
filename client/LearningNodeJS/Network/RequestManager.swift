//
//  RequestManager.swift
//  LearningNodeJS
//
//  Created by Gocy on 2017/4/26.
//  Copyright © 2017年 Gocy. All rights reserved.
//

import Foundation
import SwiftWebSocket
import Alamofire

class RequestManager{
    
    //MARK: Singleton
    static private let mgr = RequestManager() //class stored property not support
    open class var `default` : RequestManager{
        get{
            return mgr
        }
    }
    
    //MARK: Properties
    fileprivate let ip = "256.256.256.256" //change this to your site address or your own ip address
    fileprivate let loginPort = "8080" //change this to your own http server listening port
    fileprivate let chatPort = "8081" // change this to your own websocket server listening port
    fileprivate var ws : WebSocket!
    //MARK: Life Cycle
    private init(){
        
    }
    
    
    func login(usingName name:String,completion:@escaping (Bool)->()){
        let target = "http://\(ip):\(loginPort)"
        Alamofire.request(target,
                          method: .get,
                          parameters: ["name":name],
                          encoding: URLEncoding.default,
                          headers: nil).response{
                            response in
                            completion(response.response?.statusCode == 200)
        }
    }
}

extension RequestManager{ //WebSocket
    func connectToServer(
        name:String,
        open:@escaping ()->() = {},
        close:@escaping (Int,String,Bool)->() = {_,_,_ in},
        error:@escaping (Error)->() = {_ in},
        message:@escaping (Any)->() = {_ in}
        ){
        if ws == nil {
            ws = WebSocket()
        }
        ws.close()
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "IllegalName"
        ws.open("ws://\(self.ip):\(self.chatPort)/?username=\(encodedName)")
        
        ws.event.open = open
        ws.event.error = error
        ws.event.close = close
        ws.event.message = message
    }
    
    func disconnect(){
        ws?.close()
    }
    
    func send(text msg:String){
        ws?.send(text: msg)
    }
    
}
