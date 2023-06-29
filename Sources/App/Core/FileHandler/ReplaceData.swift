//
//  File.swift
//  
//
//  Created by admin on 01.06.2023.
//

import SwiftUI

struct ReplaceData: Identifiable {
    var id = UUID()
    var idNumeric: Int
    @Binding var oldValue: String
    @Binding var newValue: String
}

