/*
 MixableColor
 
 Description:
 This is the color of a GridColor, and contains the logic for mixing colors.
 
 Important things to know:
 This is not in RGB. It uses primary colors, so it is RYB. This is because it is far more intuitive for most people to mix paint than to mix light. Call toRGB to get the rgb values
 maxColorValue determines how granular the coloring will get (the higher, the more granular)
 
 */

import Foundation

struct MixableColor {
    var r : Int
    var y : Int
    var b : Int
    
    static let maxColorValue = 1
    
    init(_ r: Int, _ y: Int, _ b: Int) {
        self.r = r
        self.y = y
        self.b = b
    }
    
    func toRGB() -> (r: Double, g: Double, b: Double) {
        //Found on the internet. Hope this works!
        var red : Double =    Double(r * 255) / Double(MixableColor.maxColorValue)
        var yellow : Double = Double(y * 255) / Double(MixableColor.maxColorValue)
        var blue : Double =   Double(b * 255) / Double(MixableColor.maxColorValue)
        
        let white = min(red, yellow, blue)
        
        red    -= white
        yellow -= white
        blue   -= white
        
        let maxYellow = max(red, yellow, blue)
        var green = min(yellow, blue)
        
        yellow -= green
        blue   -= green
        
        if (blue > 0 && green > 0) {
            blue  *= 2
            green *= 2
        }
        
        red   += yellow
        green += yellow
        
        let maxGreen = max(red, green, blue)
        
        if maxGreen > 0 {
            let N = Double(maxYellow) / Double(maxGreen)
            red   *= N
            green *= N
            blue  *= N
        }
        
        red   += white
        green += white
        blue  += white
        
        return (r: red, g: green, b: blue)
    }
    
    static func == (left: MixableColor, right: MixableColor) -> Bool {
        return (left.r == right.r) && (left.y == right.y) && (left.b == right.b)
    }
    
    static func + (left: MixableColor, right: MixableColor) -> MixableColor {
        var r = left.r + right.r
        var y = left.y + right.y
        var b = left.b + right.b
        
        if r > maxColorValue {
            r = maxColorValue
        }
        if y > maxColorValue {
            y = maxColorValue
        }
        if b > maxColorValue {
            b = maxColorValue
        }
        
        return MixableColor(r, y, b)
    }
    
    static func - (left: MixableColor, right: MixableColor) -> MixableColor {
        var r = left.r + right.r
        var y = left.y + right.y
        var b = left.b + right.b
        
        if r < 0 {
            r = 0
        }
        if y < 0 {
            y = 0
        }
        if b < 0 {
            b = 0
        }
        
        return MixableColor(r, y, b)
    }
}
