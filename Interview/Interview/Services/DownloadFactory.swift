//
//  DownloadFactory.swift
//  Interview
//
//  Created by Bruce McTigue on 9/6/16.
//  Copyright © 2016 Clutter. All rights reserved.
//

import Foundation

protocol DownloadFactoryProtocol {
    func create(urlString: String, delegate: DownloadDelegate) -> Download
}

final class DownloadFactory: DownloadFactoryProtocol {

    static let sharedInstance = DownloadFactory()
    private init() {}

    func create(urlString: String, delegate: DownloadDelegate) -> Download {
        return Download.init(urlString: urlString, delegate: delegate)
    }

}
