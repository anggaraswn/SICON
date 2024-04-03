//
//  ContentView.swift
//  SICON
//
//  Created by Anggara Satya Wimala Nelwan on 27/03/24.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var vm: AppViewModel
    @Environment(\.modelContext) var context
    
    @State private var inputtedVehicleNumber: String = ""
    @State private var isInvalid: Bool = false
    @State private var showSearchResult: Bool = false
    @State private var searchedData: [VehicleNumber] = []
    @State private var path = NavigationPath()
    @State private var verified: Bool = false
    @State private var isScannerActive = false
    @State private var timerSet: Date? = nil
    @Query() var vehicleNumbers: [VehicleNumber] = []
    
    var searchVehicleQuery: Query<VehicleNumber, [VehicleNumber]>{
        var predicate: Predicate<VehicleNumber>?
        if !inputtedVehicleNumber.isEmpty{
            let processedVehicleNumber = inputtedVehicleNumber.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//            let str = inputtedVehicleNumber.uppercased()
            predicate = .init(#Predicate{$0.number.contains(processedVehicleNumber)})
        }
        
        return Query(filter: predicate)
    }
    
    func searchVehicle(){
        let processedVehicleNumber = inputtedVehicleNumber.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        let filteredVehicleNumbers = vehicleNumbers.filter { $0.number == processedVehicleNumber }
        
//        let filteredVehicleNumbers = vehicleNumbers.filter { $0.number == inputtedVehicleNumber.uppercased() }
            
        if !filteredVehicleNumbers.isEmpty {
            print(inputtedVehicleNumber+"test")
            isInvalid = false
            searchedData = filteredVehicleNumbers
            path.append("SearchResult")
            showSearchResult = true
        }else{
            print(inputtedVehicleNumber+"test")
            isInvalid = true
            showSearchResult = false
        }
    }
    
    func setSession() {
        print(verified)
        let sessionLength: TimeInterval = 15 * 60 // 15 minutes in seconds as a Double
        let timerSetSnapshot = Date() // Take a snapshot of the current time
        self.timerSet = timerSetSnapshot // Store the current time when the timer is set
        
        DispatchQueue.main.asyncAfter(deadline: .now() + sessionLength) { [timerSetSnapshot] in
            // Calculate the time interval since timerSetSnapshot
            let timePassed = Date().timeIntervalSince(timerSetSnapshot)
            
            // Check if the time passed is greater than or equal to sessionLength
            if timePassed >= sessionLength {
                DispatchQueue.main.async {
                    self.verified = false
                    print("Session expired")
                }
            }
        }
    }


    
    var body: some View {
        NavigationStack(path: $path){
            if !verified{
                FaceVerification(verified: $verified)
            } else{
                switch vm.dataScannerAccessStatus {
                case .scannerAvailable:
                    mainView
                        .navigationDestination(for: String.self){view in
                            if view == "SearchResult"{
                                SearchResult(path: $path,_searchedVehicle: searchVehicleQuery)
                            }
                        }
                case .cameraNotAvailable:
                    Text("Your device doesn't have a camera")
                case .scannerNotAvailable:
                    Text("Your device doesn't have support for scanning barcode with this app")
                case .cameraAccessNotGranted:
                    Text("Please provide access to the camera in settings")
                case .notDetermined:
                    Text("Requesting camera access")
                }
            }
        }
        .navigationTitle("Scan")
    }
    
    
    private var mainView: some View {
        VStack {
            Text("Scan Here")
                .font(.system(size: 20, weight: .medium, design: .default))
                .foregroundColor(Color("text"))
                .padding(.top, 5)
                .padding(.bottom, 16)
            if isScannerActive{
                scanView
            }
            contentView
        }
        .onAppear{
            isScannerActive = true
            if verified{
                setSession()
            }
        }
        .onDisappear{
            isScannerActive = false
        }
        .padding(10)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background{
                Color("background").ignoresSafeArea()
            }
    }
    
    private var scanView: some View{
        ZStack{
            DataScannerView(recognizedItems: $vm.recognizedItems)
                .frame(height: 345)
            Image("corner")
                .offset(x:-158, y:-51) //LeftTop
            Image("corner")
                .offset(x:-51, y:-158)
                .rotationEffect(.degrees(270))//LeftBottom
            Image("corner")
                .offset(x:-157, y:-51)
                .rotationEffect(.degrees(180))//RightBottom
            Image("corner")
                .offset(x:-51, y:-157)
                .rotationEffect(.degrees(90))//RightTop
            
        }
    }
    
    private var contentView: some View{
            VStack{
                ZStack{
                    TextField("",text: Binding<String>(
                        get: {
                            switch vm.recognizedItems.first{
                            case .text(let text):
                                text.transcript
                            default:
                                inputtedVehicleNumber
                            }
                        },
                        set: { newValue in
                            inputtedVehicleNumber = newValue
                        }
                    )).onChange(of: !vm.recognizedItems.isEmpty) {
                        switch vm.recognizedItems.first{
                            case .text(let text):
                                inputtedVehicleNumber = text.transcript
                            default:
                            inputtedVehicleNumber = inputtedVehicleNumber
                        }
                    }
                        .background(.white)
                        .foregroundColor(Color("grey"))
                        .cornerRadius(5.0)
                        .padding(.horizontal, 10)
                        .padding(.top, 23)
                        .font(.title)
                    
                    if inputtedVehicleNumber.isEmpty{
                        Text("License Plate Number")
                            .font(.system(size: 18, weight: .regular, design: .default))
                            .foregroundStyle(Color("grey"))
                            .padding(.leading, 20)
                            .padding(.top, 26)
                            .allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    }
                }
                Spacer()
                CustomButton(text: "Search", action: self.searchVehicle)
                    .padding(.bottom, 54)
                    .alert(isPresented: $isInvalid, content: {
                        Alert(
                            title: Text("Invalid License Number"),
                            message: Text("This vehicle may be not registered as a member!")
                        )
                    })
            }
        }
}

//#Preview {
//    ContentView()
//}
