//
//  UIApplication.swift
//  CryptoApp
//
//  Created by NamaN  on 09/09/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
