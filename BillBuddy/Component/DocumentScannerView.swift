//
//  DocumentScannerView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 23/4/2025.
//
import SwiftUI
import VisionKit

struct DocumentScannerView: UIViewControllerRepresentable {
    var onScanComplete: (Result<UIImage, Error>) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(onScanComplete: onScanComplete)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var onScanComplete: (Result<UIImage, Error>) -> Void

        init(onScanComplete: @escaping (Result<UIImage, Error>) -> Void) {
            self.onScanComplete = onScanComplete
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            if scan.pageCount > 0 {
                let image = scan.imageOfPage(at: 0)
                onScanComplete(.success(image))
            } else {
                onScanComplete(.failure(NSError(domain: "Scanner", code: -1, userInfo: [NSLocalizedDescriptionKey: "No pages scanned."])))
            }
            controller.dismiss(animated: true)
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            onScanComplete(.failure(error))
            controller.dismiss(animated: true)
        }
    }
}


