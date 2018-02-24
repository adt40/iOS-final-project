/*
 MixableColor
 
 Description:
 This is the color of a GridColor, and contains the logic for mixing colors.
 
 Important things to know:
 maxColorValue determines how granular the coloring will get (the higher, the more granular)
 
 */

import Foundation

struct MixableColor {
    var r : Int
    var g : Int
    var b : Int
    
    static let maxColorValue = 1
    
    init(_ r: Int, _ g: Int, _ b: Int) {
        self.r = r
        self.g = g
        self.b = b
    }
    
    static func == (left: MixableColor, right: MixableColor) -> Bool {
        return (left.r == right.r) && (left.g == right.g) && (left.b == right.b)
    }
    
    static func + (left: MixableColor, right: MixableColor) -> MixableColor {
        var r = left.r + right.r
        var g = left.g + right.g
        var b = left.b + right.b
        
        if r > maxColorValue {
            r = maxColorValue
        }
        if g > maxColorValue {
            g = maxColorValue
        }
        if b > maxColorValue {
            b = maxColorValue
        }
        
        return MixableColor(r, g, b)
    }
    
    static func - (left: MixableColor, right: MixableColor) -> MixableColor {
        var r = left.r + right.r
        var g = left.g + right.g
        var b = left.b + right.b
        
        if r < 0 {
            r = 0
        }
        if g < 0 {
            g = 0
        }
        if b < 0 {
            b = 0
        }
        
        return MixableColor(r, g, b)
    }
}
