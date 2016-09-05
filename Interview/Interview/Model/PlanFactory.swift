//
//  PlanFactory.swift
//  Interview
//
//  Created by Bruce McTigue on 9/5/16.
//  Copyright © 2016 Clutter. All rights reserved.
//

import Foundation

protocol PlanFactoryProtocol {
    func create(planHash: NSDictionary) -> Plan?
}

final class PlanFactory: PlanFactoryProtocol {

    static let sharedInstance = PlanFactory()
    private init() {}

    func create(planHash: NSDictionary) -> Plan? {
        return try? Plan(map: Mapper(JSON:planHash))
    }

}
