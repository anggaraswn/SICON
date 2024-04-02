//
//  CustomButton.swift
//  SICON
//
//  Created by Anggara Satya Wimala Nelwan on 31/03/24.
//

import SwiftUI

struct CustomButton: View {
    var text: String
    var image: String?
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }){
                Label(text, systemImage: image ?? "")
                    .frame(width: 299, height: 40)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(Color("text"))
        }
            .buttonStyle(.borderedProminent)
            .tint(Color("primaryCol"))
    }
}
