//
//  SearchResult.swift
//  SICON
//
//  Created by Anggara Satya Wimala Nelwan on 30/03/24.
//

import SwiftUI
import SwiftData

struct SearchResult: View {
    @Binding var path: NavigationPath
    @Query var searchedVehicle: [VehicleNumber]
//    var data: [VehicleNumber]
    
    func notify(){
        let countryCode = "62"
        var contact = searchedVehicle.first?.contact ?? ""
        if contact.contains("-"){
            contact = contact.replacingOccurrences(of: "-", with: "")
        }
//        let message = "Dear, \(searchedVehicle.first?.workplace ?? "") There is a \(searchedVehicle.first?.vehicle ?? "") in the parking spot that got  \((searchedVehicle.first?.vehicle ?? "") == "motorcycle" ? "steering locked" : "hand braked") with license plate number \(searchedVehicle.first?.number ?? ""), please help us to notify \(searchedVehicle.first?.ownerName ?? "") as the owner to come down, thank you"
        let message = "Yth, \(searchedVehicle.first?.workplace ?? "") \n\nTerdapat \(searchedVehicle.first?.vehicle ?? "") di tempat parkir yang telah \(searchedVehicle.first?.vehicle ?? "" == "motorcycle" ? "dikunci setang" : "dipasang rem tangan") dengan nomor plat \(searchedVehicle.first?.number ?? ""), mohon bantuannya untuk memberitahukan \(searchedVehicle.first?.ownerName ?? "") sebagai pemilik untuk segera turun, terima kasih."
        let urlString = "https://api.whatsapp.com/send?phone=\(countryCode)\(contact)&text=\(message)"
        print(urlString)
        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let URL = NSURL(string: urlStringEncoded!)
        if UIApplication.shared.canOpenURL (URL! as URL){
            print("Opening whatsapp")
            UIApplication.shared.open (URL! as URL, options: [:]){ status in
                print("Opened a Whatsapp chat")
            }
        }else{
            print ("Can't Open ")
        }
    }
    
    var body: some View {
        VStack{
            Text("Notify Request")
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.white)
                .padding(.top, 5)
                .padding(.bottom, 135)
            VehicleNumberRectangle(vehicleNumber: searchedVehicle.first?.number ?? "")
                .padding(.bottom, 115)
            Text(searchedVehicle.first?.ownerName ?? "")
                .font(.system(size: 32, weight: .bold, design: .default))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            Text(searchedVehicle.first?.workplace ?? "")
                .font(.system(size: 24, weight: .regular, design: .default))
                .padding(.bottom, 20)
            Text("(+62) \(searchedVehicle.first?.contact ?? "")")
                .font(.system(size: 16, weight: .light, design: .default))
            Spacer()
            CustomButton(text: "Notify", action: notify)
                .padding(.bottom, 54)
        }
        .toolbar{
            ToolbarItem(placement: .topBarLeading){
                if !path.isEmpty{
//                    Button("Scan"){
//                        path.removeLast()
//                    }
                    Button(action: {
                        path.removeLast()
                    }, label: {
                        HStack{
                            Image(systemName: "chevron.left")
                            Text("Scan")
                        }
                    })
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding(10)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background{
                Color("background").ignoresSafeArea()
            }
    }
}


struct VehicleNumberRectangle: View{
    var vehicleNumber: String
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 16.0)
                .fill(.white)
                .frame(width: 299, height: 108)
            RoundedRectangle(cornerRadius: 15.0)
                .frame(width: 294, height: 104)
                .overlay(
                    RoundedRectangle(cornerRadius: 15.0)
                            .stroke(Color.black, lineWidth: 2)
                    )
            Text(vehicleNumber)
                .font(.system(size: 50, weight: .bold, design: .default))
                .foregroundColor(.black)
                .padding(.top, 5)
                .padding(.bottom, 10)
        }
    }
}
