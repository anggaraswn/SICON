//
//  PasscodeVerification.swift
//  SICON
//
//  Created by Anggara Satya Wimala Nelwan on 03/04/24.
//

import SwiftUI

struct PasscodeVerification: View {
    @Binding var path: NavigationPath
    @Binding var verified: Bool
    @State private var passcode: String = ""
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        VStack{
            Text("Enter the Passcode")
                .font(.system(size: 20, weight: .medium, design: .default))
                .foregroundColor(Color("text"))
                .padding(.bottom, 117)
            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                .resizable()
                .foregroundColor(Color("text"))
                .scaledToFit()
                .frame(width: 124, height: 72)
                .padding(.bottom, 150)
            ZStack (alignment: .init(horizontal: .trailing, vertical: .center)){
                TextField("Enter Passcode" ,text: $passcode)
                    .background(.white)
                    .foregroundColor(Color("grey"))
                    .cornerRadius(5.0)
                    .padding(.horizontal, 10)
                    .padding(.top, 23)
                    .font(.title)
                    .keyboardType(.numberPad)
                    .focused($keyboardFocused)
                Button(action: {
                    verify()
                }, label: {
                    Image(systemName: "arrow.right.circle")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .padding(.horizontal, 23)
                        .padding(.top, 23)
                        
                })
            }
            .padding(.bottom, 83)
            Spacer()
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background{
            Color("background").ignoresSafeArea()
        }
        .onAppear{
            keyboardFocused = true
        }
    }
    
    func verify(){
        if passcode == "123456"{
            path.removeLast()
            verified = true
        }
    }
}

//#Preview {
//    PasscodeVerification(verified: <#Binding<Bool>#>)
//}
