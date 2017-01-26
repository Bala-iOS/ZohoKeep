//
//  String+Extension.swift
//  ZohoKeep
//
//  Created by Bala on 1/25/17.
//  Copyright © 2017 Bala. All rights reserved.
//

import Foundation

extension String
{
    var  isBlank:Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
}
