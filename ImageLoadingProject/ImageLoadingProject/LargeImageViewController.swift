//
//  LargeImageViewController.swift
//  ImageLoadingProject
//
//  Created by Булат Хабибуллин on 23.11.2020.
//

struct Image {
    var title: String
    var urlString: String
    var largeImageUrlString: String?
}

import UIKit

class LargeImageViewController: UIViewController, URLSessionDownloadDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var image: Image?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        loadData()
    }
    
    func loadData() {
        guard let image = image else { return }
        let url = image.largeImageUrlString
                
        progressView.setProgress(0.0, animated: true)
        if let imageURL = getURLFromString(url ?? "") {
            download(from: imageURL)
        }
    }
    
    func download(from url: URL) {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
            
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func readDownloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
                
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    func getUIImageFromData(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func getURLFromString(_ str: String) -> URL? {
        return URL(string: str)
    }
    
    func setImageToImageView(from data: Data?) {
        guard let imageData = data else { return }
        guard let image = getUIImageFromData(imageData) else { return }
            
        DispatchQueue.main.async {
            self.largeImage.image = image
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let data = readDownloadedData(of: location)
        setImageToImageView(from: data)
        DispatchQueue.main.async {
            self.progressView.isHidden = true
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentDownloaded = totalBytesWritten / totalBytesExpectedToWrite
        DispatchQueue.main.async {
            self.progressView.setProgress(Float(percentDownloaded), animated: true)
//            if percentDownloaded == 1 {
//                self.progressView.isHidden = true
//            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return largeImage
    }
}
