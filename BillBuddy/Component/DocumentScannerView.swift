//
//  DocumentScannerView.swift
//  BillBuddy
//
//  Created by Callista Cleine on 23/4/2025.
//
import SwiftUI
import VisionKit

struct DocumentScannerView: UIViewControllerRepresentable {
  enum ScanError: Error { case notSupported }

  var onScanComplete: (Result<UIImage, Error>) -> Void

  func makeCoordinator() -> Coordinator {
    Coordinator(onScanComplete: onScanComplete)
  }

  func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
    // 1) guard support
    guard VNDocumentCameraViewController.isSupported else {
      DispatchQueue.main.async {
        onScanComplete(.failure(ScanError.notSupported))
      }
      return VNDocumentCameraViewController() // dummy, never shown
    }

    // 2) normal setup
    let scanner = VNDocumentCameraViewController()
    scanner.delegate = context.coordinator
    return scanner
  }

  func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
    // nothing
  }

  class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
    let onScanComplete: (Result<UIImage, Error>) -> Void

    init(onScanComplete: @escaping (Result<UIImage, Error>) -> Void) {
      self.onScanComplete = onScanComplete
    }

    func documentCameraViewController(
      _ controller: VNDocumentCameraViewController,
      didFinishWith scan: VNDocumentCameraScan
    ) {
      if scan.pageCount > 0 {
        onScanComplete(.success(scan.imageOfPage(at: 0)))
      } else {
        onScanComplete(.failure(ScanError.notSupported))
      }
      controller.dismiss(animated: true)
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
      onScanComplete(.failure(ScanError.notSupported))
      controller.dismiss(animated: true)
    }

    func documentCameraViewController(
      _ controller: VNDocumentCameraViewController,
      didFailWithError error: Error
    ) {
      onScanComplete(.failure(error))
      controller.dismiss(animated: true)
    }
  }
}
