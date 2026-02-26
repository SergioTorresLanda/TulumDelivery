//
//  ImageDownloader.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 24/02/26.
//
import Foundation
import UIKit
// This automatically runs on a BACKGROUND thread pool.
// It protects its internal state (the 'storage' dictionary) from race conditions.
actor ImageDownloader {
    
    private var storage: [URL: UIImage] = [:]
    func fetchAndResize(url: URL) -> UIImage? {
        
        let data = try? Data(contentsOf: url)
        let image = UIImage(data: data ?? Data())
        
        // Simulating heavy processing (resizing)
        let resized = image //?.resize(to: CGSize(width: 100, height: 100))
        
        storage[url] = resized // Safe! No two threads can write here at once.
        return resized
    }
}
