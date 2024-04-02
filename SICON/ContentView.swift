//
//  ContentView.swift
//  SICON
//
//  Created by Anggara Satya Wimala Nelwan on 27/03/24.
//
//test alis
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
    @Query() var vehicleNumbers: [VehicleNumber] = []
//    @Query var searchedVehicle: [VehicleNumber]
    
    var searchVehicleQuery: Query<VehicleNumber, [VehicleNumber]>{
        var predicate: Predicate<VehicleNumber>?
        if !inputtedVehicleNumber.isEmpty{
            predicate = .init(#Predicate{$0.number.contains(inputtedVehicleNumber)})
        }
        
        return Query(filter: predicate)
    }
    
    func searchVehicle(){
//        let searchResult = #Predicate<VehicleNumber>{$0.number.contains(vehicleNumber)}
//        @Query(filter: #Predicate<VehicleNumber> {$0.number.contains(self.vehicleNumber)}) var searchResult: VehicleNumber?
//        _searchedVehicle = searchResult
//        print(searchResult)
//        _searchedVehicle = Query(filter: #Predicate{$0.number.contains(self.vehicleNumber)})
        
        let filteredVehicleNumbers = vehicleNumbers.filter { $0.number.lowercased() == inputtedVehicleNumber.lowercased() }
            
        if !filteredVehicleNumbers.isEmpty {
            print(filteredVehicleNumbers.first?.ownerName ?? "")
            isInvalid = false
            searchedData = filteredVehicleNumbers
            path.append("SearchResult")
            showSearchResult = true
        }else{
            isInvalid = true
            showSearchResult = false
        }
    }
    
    var body: some View {
        NavigationStack(path: $path){
            switch vm.dataScannerAccessStatus {
            case .scannerAvailable:
                mainView
                    .navigationDestination(for: String.self){view in
                        if view == "SearchResult"{
//                            SearchResult(data: searchedData)
                            SearchResult(_searchedVehicle: searchVehicleQuery)
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
    
    
    private var mainView: some View {
        VStack {
            Text("Scan Here")
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.white)
                .padding(.top, 5)
                .padding(.bottom, 10)
            scanView
            contentView
        }
        .padding(10)
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
//                Divider()
//                    .frame(height: 2)
//                    .overlay(.primary)
//                    .padding(.vertical, 50)
                TextField("Plat Nomor",text: Binding<String>(
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
                    .foregroundColor(.gray)
                    .cornerRadius(5.0)
                    .padding(.horizontal, 10)
                    .padding(.top, 28)
                    .font(.title)
    //                .font(.system(size: 17, weight: .semibold, design: .default))
    //                .frame(height: 30)
    //                .textFieldStyle(.roundedBorder)
                
    //            ForEach(vehicleNumbers){ number in
    //                Text("\(number.ownerName)")
    //            }
                Spacer()
                CustomButton(text: "Search", image: "magnifyingglass", action: self.searchVehicle)
                    .alert(isPresented: $isInvalid, content: {
                        Alert(
                            title: Text("Invalid Vehicle Number"),
                            message: Text("The vehicle number is not registered!")
                        )
                    })
            }
        }
}

//#Preview {
//    ContentView()
//}
