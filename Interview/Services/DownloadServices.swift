//
//  DownloadServices.swift
//  Interview
//
//  Created by NoDeveloper on 8/27/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import Foundation

protocol DownloadServicesDelegate {
    func downLoadFinished(jsonArray: NSArray)
}

final class DownloadServices: NSObject {

    let delegate: DownloadServicesDelegate?

    init(delegate: DownloadServicesDelegate) {
        self.delegate = delegate
    }

    func request(urlString: String, method: String) -> NSURLRequest {
        let url = NSURL(string:urlString)
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = method
        return request
    }

    func downloadWithUrl(urlString: String, method: String) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request(urlString, method: method)) {
            data, response, error in
            guard let data = data else { print(error?.localizedDescription); return }
            do {
                if let jsonArray = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                    self.delegate?.downLoadFinished(jsonArray)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

}
