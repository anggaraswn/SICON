//
//  SICONApp.swift
//  SICON
//
//  Created by Anggara Satya Wimala Nelwan on 27/03/24.
//

import SwiftUI
import SwiftData

@main
struct SICONApp: App {
    @StateObject private var vm = AppViewModel()
    let container: ModelContainer
    
//    let container: ModelContainer = {
//        let schema = Schema([VehicleNumber.self])
//        let container = try! ModelContainer(for: schema, configurations: [])
//
//        return container
//    }()
    
    init(){
        let schema = Schema([VehicleNumber.self])
        self.container = try! ModelContainer(for: schema, configurations: [])
        VehicleNumberSeeder().seedData(in: container.mainContext)
//        do{
//            try container.mainContext.delete(model: VehicleNumber.self)
//        } catch{
//
//        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
        .modelContainer(container)
    }
}
