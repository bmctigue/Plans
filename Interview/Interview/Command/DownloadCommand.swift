//
//  DownloadCommand.swift
//  Interview
//
//  Created by Bruce McTigue on 9/6/16.
//  Copyright © 2016 Clutter. All rights reserved.
//

import Foundation

final class DownloadCommand: CommandProtocol {

    let downloadService: DownloadServicesProtocol

    init(downloadService: DownloadServicesProtocol) {
        self.downloadService = downloadService
    }

    func execute() {
        downloadService.download()
    }

}
