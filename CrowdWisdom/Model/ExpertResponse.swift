//
//  ExpertResponse.swift
//  CrowdWisdom
//
//  Created by ITRS-676 on 11/13/18.
//  Copyright © 2018 Gaurav. All rights reserved.
//

import Foundation

struct ExpertResponse: Codable {
    let status: Bool
    let message: String?
    let data: [ExpertOption]
}

struct ExpertOption: Codable {
    let choice, totalGold, totalSilver, option: String?
    let type, calculatedSum, expertPercent: String?

    enum CodingKeys: String, CodingKey {
        case choice
        case totalGold = "total_gold"
        case totalSilver = "total_silver"
        case option, type
        case calculatedSum = "calculated_sum"
        case expertPercent = "expert_percent"
    }
}
