//
//  BlinksCommentsSDK.swift
//  blinks
//
//  Created by Leandro Tami on 3/30/16.
//  Copyright © 2016 Lateral View. All rights reserved.
//

import Foundation
import Alamofire

class BlinksCommentsSDK
{
    
    func find(thread: Thread? = nil,
              parent: Comment? = nil,
              username: String? = nil,
              handler:(comments: [Comment]?) -> Void)
    {
        let URLString = "\(BlinksSDK.baseURL())/comments"
        var arguments = [String: String]()
        
        if let threadId = thread?.id
        {
            arguments["thread"] = threadId
        }
        
        if let uUserName = username
        {
            arguments["username"] = uUserName
        }
        
        arguments["parent"] = parent?.id ?? "none"
        
        let request = Alamofire.request(.GET,
                                        URLString,
                                        parameters: arguments,
                                        encoding: .URL,
                                        headers: nil)
        request.responseJSON { (response) -> Void in
            
            if let result = response.result.value as! [[String: AnyObject]]?
                where response.response?.statusCode == 200
            {
                var comments = [Comment]()
                for item in result {
                    if let comment = Comment.deserialize(item) {
                        comments.append(comment)
                    }
                }
                handler(comments: comments)
            } else {
                handler(comments: nil)
            }
        }
        
    }

}