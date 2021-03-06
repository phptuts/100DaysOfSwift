//
//  ViewController.swift
//  Project27
//
//  Created by Noah Glaser on 2/7/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawTwin()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType == 8 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawTwin()
        case 1:
            drawStar()
        case 2:
            drawCheckerboard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawCircle()
        case 7:
            drawRectange()
        default:
            break
        }
    }
    
    func drawStar() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            
            let moveUp = -50
            ctx.cgContext.move(to: CGPoint(x: 100, y: 400 + moveUp))

            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)

            ctx.cgContext.addLine(to: CGPoint(x: 250, y: 100 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 400, y: 400 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 400 + moveUp))
            ctx.cgContext.fillPath()

            ctx.cgContext.move(to: CGPoint(x: 100, y: 200 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 400, y: 200 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 250, y: 500 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 200 + moveUp))
            ctx.cgContext.fillPath()


        }
        imageView.image = image

    }
    
    func drawTwin() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            
            let moveUp = 0
            // T
            ctx.cgContext.move(to: CGPoint(x: 50, y: 50 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 50 + moveUp))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
            ctx.cgContext.move(to: CGPoint(x: 75, y: 50 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 75, y: 100 + moveUp))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()

            // W
            ctx.cgContext.move(to: CGPoint(x: 125, y: 50 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 135, y: 100 + moveUp))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
            ctx.cgContext.move(to: CGPoint(x: 135, y: 100 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 145, y: 75 + moveUp))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
            ctx.cgContext.move(to: CGPoint(x: 145, y: 75 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 155, y: 100 + moveUp))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
            ctx.cgContext.move(to: CGPoint(x: 155, y: 100  + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 165, y: 50 + moveUp))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
            // I
            ctx.cgContext.move(to: CGPoint(x: 190, y: 50 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 190, y: 100 + moveUp))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()

            // N
            ctx.cgContext.move(to: CGPoint(x: 215, y: 50 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 215, y: 100 + moveUp))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
            ctx.cgContext.move(to: CGPoint(x: 215, y: 50 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 240, y: 100 + moveUp))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
            ctx.cgContext.move(to: CGPoint(x: 240, y: 50 + moveUp))
            ctx.cgContext.addLine(to: CGPoint(x: 240, y: 100 + moveUp))
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = image

    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .paragraphStyle : paragraphStyle
            ]
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 300))
        }
        imageView.image = image
    }
    
    
    func drawRectange() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            // awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            // awesome drawing code
            ctx.cgContext.translateBy(x: 256, y: 256)
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2) {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let image = renderer.image { ctx in
            // awesome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
}

