//
//  HandWritingViewController.swift
//  ChemNote
//
//  Created by Kirill Khudyakov on 04.07.17.
//  Copyright © 2017 ChemNote, LLC. All rights reserved.
//

import UIKit

class HandWritingViewController: UIViewController {
    
    // View
    let mainView = HandWriteView()
    
    // Drawing state variables
    /// The sketch brush width.
    fileprivate let brushWidth: CGFloat = 10
    /// Traces a bounding box around the sketch for easy extraction.
    fileprivate var boundingBox: CGRect?
    /// The last point traced by the brush during drawing.
    fileprivate var lastDrawPoint = CGPoint.zero
    
    // Touches
    /// Flag designating whether the user has dragged on the canvas during drawing.
    fileprivate var hasSwiped = false
    /// Flag designating whether the user is currently in the process of drawing.
    fileprivate var isDrawing = false
    /// Timer used for snapshotting the sketch.
    fileprivate var timer = Timer()

    @IBAction func clickClearCanvas(_ sender: Any) {
        clearCanvas()
    }
    
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

}


// MARK: Touch handling
extension HandWritingViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Reset swipe state tracker
        hasSwiped = false
        
        // Make sure the touch is inside the canvas
        guard mainView.canvasContainer.frame.contains(touch.location(in: mainView)) else {
            return super.touchesBegan(touches, with: event)
        }
        
        // Determine touch point
        let location = touch.location(in: mainView.canvas)
        
        // Reset bounding box if needed
        if boundingBox == nil {
            boundingBox = CGRect(x: location.x - brushWidth / 2,
                                 y: location.y - brushWidth / 2,
                                 width: brushWidth, height: brushWidth)
        }
        
        // Store draw location
        lastDrawPoint = location
        
        // Set drawing flag
        isDrawing = true
        
        // Invalidate timer
        timer.invalidate()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Make sure the touch is inside the canvas
        guard mainView.canvasContainer.frame.contains(touch.location(in: mainView)) else {
            hasSwiped = false
            return super.touchesMoved(touches, with: event)
        }
        
        // Determine touch point
        let currentPoint = touch.location(in: mainView.canvas)
        
        // Reset bounding box if needed
        if boundingBox == nil {
            boundingBox = CGRect(x: currentPoint.x - brushWidth,
                                 y: currentPoint.y - brushWidth,
                                 width: brushWidth, height: brushWidth)
        }
        
        // Draw a line from previous to current touch point
        if hasSwiped {
            drawLine(from: lastDrawPoint, to: currentPoint)
        } else {
            drawLine(from: currentPoint, to: currentPoint)
            hasSwiped = true
        }
        
        // Expand the bounding box to fit the extremes of the sketch
        if currentPoint.x < boundingBox!.minX {
            stretchBoundingBox(minX: currentPoint.x - brushWidth,
                               maxX: nil, minY: nil, maxY: nil)
        } else if currentPoint.x > boundingBox!.maxX {
            stretchBoundingBox(minX: nil,
                               maxX: currentPoint.x + brushWidth,
                               minY: nil, maxY: nil)
        }
        
        if currentPoint.y < boundingBox!.minY {
            stretchBoundingBox(minX: nil, maxX: nil,
                               minY: currentPoint.y - brushWidth,
                               maxY: nil)
        } else if currentPoint.y > boundingBox!.maxY {
            stretchBoundingBox(minX: nil, maxX: nil, minY: nil,
                               maxY: currentPoint.y + brushWidth)
        }
        
        // Store draw location
        lastDrawPoint = currentPoint
        
        // Invalidate timer
        timer.invalidate()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Make sure touch is inside canvas
        if mainView.canvasContainer.frame.contains(touch.location(in: mainView)) {
            if !hasSwiped {
                // Draw dot
                drawLine(from: lastDrawPoint, to: lastDrawPoint)
            }
        }
        
        // Start timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] (_) in
            self?.timerExpired()
        }
        
        // We're no longer drawing
        isDrawing = false
        
        super.touchesEnded(touches, with: event)
    }
    
    fileprivate func timerExpired() {
        // Save train image to file
        saveImage()
        
        // Reset bounding box
        boundingBox = nil
    }
    
}

// MARK: Drawing and image manipulation
extension HandWritingViewController {
    
    /// Draws a line on the canvas between the given points.
    fileprivate func drawLine(from: CGPoint, to: CGPoint) {
        // Begin graphics context
        UIGraphicsBeginImageContext(mainView.canvas.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        // Store current sketch in context
        mainView.canvas.image?.draw(in: mainView.canvas.bounds)
        
        // Append new line to image
        context?.move(to: from)
        context?.addLine(to: to)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
        context?.strokePath()
        
        // Store modified image back into image view
        mainView.canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        
        // End context
        UIGraphicsEndImageContext()
    }
    
    /// Crops the given UIImage to the provided CGRect.
    fileprivate func crop(_ image: UIImage, to: CGRect) -> UIImage {
        let img = image.cgImage!.cropping(to: to)
        return UIImage(cgImage: img!)
    }
    
    /// Scales the given image to the provided size.
    fileprivate func scale(_ image: UIImage, to: CGSize) -> UIImage {
        let size = CGSize(width: min(20 * image.size.width / image.size.height, 20),
                          height: min(20 * image.size.height / image.size.width, 20))
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height).integral
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = .none
        image.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Centers the given image in a clear 28x28 canvas and returns the result.
    fileprivate func addBorder(to image: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 28, height: 28))
        image.draw(at: CGPoint(x: (28 - image.size.width) / 2,
                               y: (28 - image.size.height) / 2))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Updates the bounding box to stretch to the provided extremes.
    /// If `nil` is passed for any value, the box's current value will be preserved.
    fileprivate func stretchBoundingBox(minX: CGFloat?, maxX: CGFloat?, minY: CGFloat?, maxY: CGFloat?) {
        guard let box = boundingBox else { return }
        boundingBox = CGRect(x: minX ?? box.minX,
                             y: minY ?? box.minY,
                             width: (maxX ?? box.maxX) - (minX ?? box.minX),
                             height: (maxY ?? box.maxY) - (minY ?? box.minY))
    }
    
    /// Resets the canvas for a new sketch.
    fileprivate func clearCanvas() {
        // Animate snapshot box
        if let box = boundingBox {
            mainView.snapshotBox.frame = box
            mainView.snapshotBox.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            // Spring outward
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
                self.mainView.snapshotBox.alpha = 1
                self.mainView.snapshotBox.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
            }, completion: nil)
            // Spring back inward
            UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
                self.mainView.snapshotBox.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
        // Animate the sketch and bounding box away
        UIView.animate(withDuration: 0.1, delay: 0.4, options: [.curveEaseIn], animations: {
            self.mainView.canvas.alpha = 0
            self.mainView.snapshotBox.alpha = 0
        }) { (_) in
            self.mainView.canvas.image = nil
            self.mainView.canvas.alpha = 1
        }
    }
    
}

// MARK: scanImage for saving to Train DataBase

extension HandWritingViewController {
    func saveImage(){
        // Clear canvas when finished
        defer { clearCanvas() }
        
        // Extract and resize image from drawing canvas
        guard let imageArray = scanImage() else { return }
        
        guard let image = mainView.networkInputCanvas.image else { return }
        guard let data = UIImagePNGRepresentation(image) else { return }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths.first
        guard let filename = documentsDirectory?.appendingPathComponent("trainingImage.png") else { return }
        try? data.write(to: filename)
        
        if let fileUrl = TrainSaver().save(with: imageArray) {
            let server = "http://chemnote.dev/api/"
            Uploader.upload(files: [fileUrl, filename], to: server, fileName: "data.txt")
            print("path: \(fileUrl)")
        }
        
    }
    
    /// Scans the current image from the canvas and returns the pixel data as Floats.
    private func scanImage() -> [Float]? {
        var pixelsArray = [Float]()
        guard let image = mainView.canvas.image, let box = boundingBox else {
            return nil
        }
        
        // Extract drawing from canvas and remove surrounding whitespace
        let croppedImage = crop(image, to: box)
        
        // Scale sketch to max 20px in both dimmensions
        let scaledImage = scale(croppedImage, to: CGSize(width: 20, height: 20))
        
        // Center sketch in 28x28 white box
        let character = addBorder(to: scaledImage)
        
        // Dispaly character in view
        mainView.networkInputCanvas.image = character
        
        // Extract pixel data from scaled/cropped image
        guard let cgImage = character.cgImage else { return nil }
        guard let pixelData = cgImage.dataProvider?.data else { return nil }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let bytesPerRow = cgImage.bytesPerRow
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        
        // Iterate through
        var position = 0
        for _ in 0..<Int(character.size.height) {
            for _ in 0..<Int(character.size.width) {
                // We only care about the alpha component
                let alpha = Float(data[position + 3])
                // Scale alpha down to range [0, 1] and append to array
                pixelsArray.append(alpha / 255)
                // Increment position
                position += bytesPerPixel
            }
            if position % bytesPerRow != 0 {
                position += (bytesPerRow - (position % bytesPerRow))
            }
        }
        return pixelsArray
    }

}

