//
//  SKGifNode.swift
//  iFlappy
//
//  Created by Aaryan Kothari on 19/02/21.
//

import SpriteKit
import ImageIO
extension SKSpriteNode{

func animateWithLocalGIF(fileNamed name:String) {
// Check gif
    guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else { return }
    
// Validate data
    guard let imageData = NSData(contentsOf: bundleURL) else {
print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
return }
    
    if let textures = SKSpriteNode.gifWithData(data: imageData){
        let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
        self.run(action)
        }
    }
    
public class func gifWithData(data: NSData) -> [SKTexture]? {
// Create source from data
        guard let source = CGImageSourceCreateWithData(data, nil) else {
print("SwiftGif: Source for the image does not exist")
return nil
        }
    return SKSpriteNode.animatedImageWithSource(source: source)
    }
    
class func animatedImageWithSource(source: CGImageSource) -> [SKTexture]? {
let count = CGImageSourceGetCount(source)
var delays = [Int]()
var textures = [SKTexture]()
// Fill arrays
        for i in 0..<count {
// Add image
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let texture = SKTexture(cgImage: image)
                textures.append(texture)
            }
// At it's delay in cs
            let delaySeconds = 1
            delays.append(Int(Double(delaySeconds) * 1000.0)) // Seconds to ms
        }
// Calculate full duration
        let duration: Int = {
var sum = 0
for val: Int in delays {
                sum += val
            }
return sum
        }()
// may use later
    _ = Double(duration) / 1000.0 / Double(count)
return textures
    }
class func gcdForArray(array: Array<Int>) -> Int {
if array.isEmpty {
return 1
        }
var gcd = array[0]
for val in array {
    gcd = SKSpriteNode.gcdForPair(a: val, gcd)
        }
return gcd
    }
    
//class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
//var delay = 0.1
//// Get dictionaries
//        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
//    let gifProperties: CFDictionary = unsafeBitCast(
//CFDictionaryGetValue(cfProperties,
//unsafeAddressOf(kCGImagePropertyGIFDictionary)),
//            CFDictionary.self)
//// Get delay time
//        var delayObject: AnyObject = unsafeBitCast(
//CFDictionaryGetValue(gifProperties,
//unsafeAddressOf(kCGImagePropertyGIFUnclampedDelayTime)),
//AnyObject.self)
//if delayObject.doubleValue == 0 {
//            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
//unsafeAddressOf(kCGImagePropertyGIFDelayTime)), AnyObject.self)
//        }
//        delay = delayObject as! Double
//if delay < 0.1 {
//            delay = 0.1 // Make sure they're not too fast
//        }
//return delay
//    }
    
class func gcdForPair(a: Int?, _ b: Int?) -> Int {
var a = a
var b = b
// Check if one of them is nil
        if b == nil || a == nil {
if b != nil {
return b!
            } else if a != nil {
return a!
            } else {
return 0
            }
        }
// Swap for modulo
    if a ?? 0 < b ?? 0 { 
let c = a
            a = b
            b = c
        }
// Get greatest common divisor
        var rest: Int
while true {
            rest = a! % b!
if rest == 0 {
return b! // Found it
            } else {
                a = b
                b = rest
            }
        }
    }
}
