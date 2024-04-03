//
//  FaceVerification.swift
//  SICON
//
//  Created by Anggara Satya Wimala Nelwan on 02/04/24.
//

import SwiftUI
import LocalAuthentication

struct FaceVerification: View {
    @Binding var verified: Bool
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path){
            VStack{
                Text("App Locked")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundColor(Color("text"))
                Text("Use Face ID to Open the App")
                    .font(.system(size: 15, weight: .medium, design: .default))
                    .foregroundColor(Color("text"))
                Spacer()
                Image(systemName: "faceid")
                    .resizable()
                    .foregroundColor(Color("text"))
                    .frame(width: 86, height: 86)
                    .padding(.bottom, 12)
                Text("Face ID")
                    .font(.system(size: 17, weight: .regular, design: .default))
                    .foregroundColor(Color("text"))
                Spacer()
                CustomButton(text: "Face ID Verification", action: verify)
                    .padding(.bottom, 11)
                Button(action: {
                    path.append("PasscodeVerification")
                }, label: {
                    Text("Enter Passcode Instead")
                        .font(.system(size: 17, weight: .regular, design: .default))
                        .foregroundColor(Color("secondaryCol"))
                })
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background{
                Color("background").ignoresSafeArea()
            }
            .onAppear(perform: verify)
            .navigationDestination(for: String.self){view in
                if view == "PasscodeVerification"{
                    PasscodeVerification(path: $path, verified: $verified)
                }
            }
        }
    }
    
    func verify(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "We need to verify"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, auhenticationError in
                if success{
                    verified = true
                }
            }
        }else{
            
        }
    }
}

//#Preview {
//    FaceVerification()
//}
