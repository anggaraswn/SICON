//
//  AppViewModel.swift
//  SICON
//
//  Created by Anggara Satya Wimala Nelwan on 27/03/24.
//

import Foundation

import SwiftUI
import VisionKit
import AVKit

enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
}

@MainActor
final class AppViewModel: ObservableObject {
    
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    @Published var recognizedItems: [RecognizedItem] = []
    @Published var textContentType : DataScannerViewController.TextContentType?
    
    
    
    private var isScannerAvailable: Bool {
            DataScannerViewController.isAvailable && DataScannerViewController.isSupported
        }
    
    func requestDataScannerAccessStatus() async {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                dataScannerAccessStatus = .cameraNotAvailable
                return
            }
            
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                
            case .authorized:
                dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
                
            case .restricted, .denied:
                dataScannerAccessStatus = .cameraAccessNotGranted
                
            case .notDetermined:
                let granted = await AVCaptureDevice.requestAccess(for: .video)
                if granted {
                    dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
                } else {
                    dataScannerAccessStatus = .cameraAccessNotGranted
                }
            
            default: break
                
            }
        }
    
}
