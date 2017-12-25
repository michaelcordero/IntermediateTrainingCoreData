//
//  UIDevice+Model.swift
//  IntermediateTraining
//
//  Created by Michael Cordero on 12/25/17.
//  Copyright © 2017 Codec Software. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
    public enum model_version: String {
        /* Simulators */
        case bit_32 = "i386"
        case bit_64 = "x86_64"
        /* iPhones */
        case iPhone_1 = "iPhone1,1"
        case iPhone_3G = "iPhone1,2"
        case iPhone_3GS = "iPhone2,1"
        case iPhone_4GSM = "iPhone3,1"
        case iPhone_4CDMA = "iPhone3,3"
        case iPhone_4S = "iPhone4,1"
        case iPhone_5_A1428 = "iPhone5,1"
        case iPhone_5_A1429 = "iPhone5,2"
        case iPhone_5S_GSM = "iPhone5,3"
        case iPhone_5C_Global = "iPhone5,4"
        case iPhone_5s_GSM = "iPhone6,1"
        case iPhone_5S_Global = "iPhone6,2"
        case iPhone_6Plus = "iPhone7,1"
        case iPhone_6 = "iPhone7,2"
        case iPhone_6S = "iPhone8,1"
        case iPhone_6S_Plus = "iPhone8,2"
        case iPhone_SE = "iPhone8,4"
        case iPhone_7CDMA = "iPhone9,1"
        case iPhone_7GSM = "iPhone9,3"
        case iPhone_7Plus_CDMA = "iPhone9,2"
        case iPhone_7Plus_GSM = "iPhone9,4"
        case iPhone_8CDMA = "iPhone10,1"
        case iPhone_8GSM = "iPhone10,4"
        case iPhone_8Plus_CDMA = "iPhone10,2"
        case iPhone_8Plus_GSM = "iPhone10,5"
        case iPhone_X_CDMA = "iPhone10,3"
        case iPhone_X_GSM = "iPhone10,6"
        
        /*
         Many more found here:
         [StackOverflow](https://stackoverflow.com/questions/11197509/how-to-get-device-make-and-model-on-ios/11197770#11197770)
         */
    }
    /**
     This code only works if you've imported #import <sys/utsname.h>
     into a bridging-header file or Objective-C implementation file.
    */
    var model_type: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machine_mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machine_mirror.children.reduce("") {
            identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
