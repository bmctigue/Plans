//
//  Download.swift
//  Interview
//
//  Created by NoDeveloper on 8/27/16.
//  Copyright © 2016 NoCompany. All rights reserved.
//

import Foundation

protocol DownloadDelegate {
    func downLoadFinished(jsonArray: NSArray)
}

protocol DownloadProtocol {
    func download()
}

final class Download: NSObject, DownloadProtocol {

    let urlString: String
    let delegate: DownloadDelegate?

    init(urlString: String, delegate: DownloadDelegate) {
        self.urlString = urlString
        self.delegate = delegate
    }

    private func request(urlString: String, method: String) -> NSURLRequest {
        let url = NSURL(string:urlString)
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = method
        return request
    }

    func download() {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request(urlString, method: "GET")) {
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
