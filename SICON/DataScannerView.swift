//
//  DataScannerView.swift
//  SICON
//
//  Created by Anggara Satya Wimala Nelwan on 27/03/24.
//

import Foundation
import SwiftUI
import VisionKit

struct DataScannerView: UIViewControllerRepresentable{
    
    @Binding var recognizedItems: [RecognizedItem]

    var plateRegex: String = "[a-zA-Z]{1,2} [0-9]{1,4} [a-zA-Z]{1,3}$"
//    let recognizedDataType: DataScannerViewController.RecognizedDataType
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
            let vc = DataScannerViewController(
                recognizedDataTypes: [.text()],
                qualityLevel: .fast,
                recognizesMultipleItems: false ,
                isGuidanceEnabled: true,
                isHighlightingEnabled: true
            )
            return vc
        }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
            uiViewController.delegate = context.coordinator
            try? uiViewController.startScanning()
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(recognizedItems: $recognizedItems)
        }
        
        static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
            uiViewController.stopScanning()
        }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
            
            @Binding var recognizedItems: [RecognizedItem]

            init(recognizedItems: Binding<[RecognizedItem]>) {
                self._recognizedItems = recognizedItems
            }
            
            func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
//                print("didTapOn \(item)")
            }
            
            func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                recognizedItems.append(contentsOf: addedItems)
//                print("didAddItems \(addedItems)")
            }
            
            func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
                self.recognizedItems = recognizedItems.filter { item in
                    !removedItems.contains(where: {$0.id == item.id })
                }
//                print("didRemovedItems \(removedItems)")
            }
            
            func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
//                print("became unavailable with error \(error.localizedDescription)")
            }
            
        }
    
    
}

