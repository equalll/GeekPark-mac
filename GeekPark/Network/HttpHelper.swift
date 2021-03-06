//
//  HttpHelper.swift
//  GeekPark
//
//  Created by lan on 16/8/25.
//  Copyright © 2016年 lan. All rights reserved.
//

import Cocoa
import Alamofire
import Fuzi

class HttpHelper: NSObject {
    let url = "http://www.geekpark.net"

    func getNews(_ handle: @escaping (_ models: [GPModel]) -> ()) {
        Alamofire.request(url).responseString { response in
            let html = response.result.value
            
            do {
                var models = [GPModel]()
                let doc = try HTMLDocument(string: html!, encoding: String.Encoding.utf8)
                
                for article in doc.xpath("//article[@class='article-item']") {
                    var title = String()
                    var imgUrl = String()
                    var category = String()
                    var time = String()
                    var href = String()
                    
                    if let imgEle = article.firstChild(xpath:".//a/div/img") {
                        imgUrl = imgEle["data-src"]!
                    }
                    
                    if let categoryEle =  article.firstChild(xpath: ".//div/div/a[1]") {
                        category = categoryEle.stringValue
                    }
                    
                    if let titleEle = article.firstChild(xpath:".//div/div/a[2]") {
                        title = titleEle["data-event-label"]!
                        href = self.url + titleEle["href"]!
                    }
                    
                    if let timeEle = article.firstChild(xpath: ".//div/div/div/div/span[2]/a") {
                        time = timeEle["title"]!
                    }
                    
                    let model = GPModel(
                        title: title,
                        imgUrl: imgUrl,
                        category: category,
                        time: time,
                        href: href
                    )
                    
                    models.append(model)
                }
                handle(models)
            }catch let error {
                print(error)
            }

        }
    }
}
