//
//  CMMotion+Extensions.swift
//  MotionSampler
//
//  Created by Tyler Angert on 4/11/19.
//  Copyright © 2019 Tyler Angert. All rights reserved.
//

import Foundation
import CoreMotion

extension CMAcceleration {
    func length() -> Float {
        return sqrtf(Float(pow(self.x, 2) + pow(self.y, 2) + pow(self.z, 2)))
    }
}
