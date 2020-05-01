//
//  UITileView.swift
//  minesweeper
//
//  Created by Karl Matti on 09.04.2020.
//  Copyright © 2020 karlmatti. All rights reserved.
//

import UIKit


class UITileView: UIView{
    
    //  0-empty(not clicked), 1-flag(right click), 2-empty or number(clicked or opened), 3-bomb(opened), 4-bomb w/cross (clicked)
    @IBInspectable
    var showElement: Int = 1 {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorBomb: UIColor = UIColor.black {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorCross: UIColor = UIColor.red {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorFlag: UIColor = UIColor.orange {didSet {setNeedsDisplay()}}
    
    @IBInspectable
    var colorEstoniaBlue: UIColor = UIColor.blue {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorEstoniaBlack: UIColor = UIColor.black {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorEstoniaWhite: UIColor = UIColor.white {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorEstoniaYellow: UIColor = UIColor.yellow {didSet {setNeedsDisplay()}}
    
    @IBInspectable
    var positionX: Int = 0 {didSet {setNeedsDisplay()}}
    @IBInspectable
    var positionY: Int = 0 {didSet {setNeedsDisplay()}}
    @IBInspectable
    var lineWidth: Int = 6 {didSet {setNeedsDisplay()}}

    private var currentTheme: String = "default"
    
    private var viewUpperLeftCorner: CGPoint {return CGPoint(x:0, y:0)}
    private var viewUpperRightCorner: CGPoint {return CGPoint(x: bounds.maxX, y:0)}
    private var viewLowerRightCorner: CGPoint {return CGPoint(x: bounds.maxX, y:bounds.maxY)}
    private var viewLowerLeftCorner: CGPoint {return CGPoint(x: 0, y:bounds.maxY)}
    
    private var viewRightMidPoint: CGPoint {return CGPoint(x:bounds.maxX-(bounds.midX / 2), y:bounds.midY)}
    private var viewTopMidPoint: CGPoint {return CGPoint(x:bounds.midX * 0.8, y:bounds.maxY * 0.1)}
    private var viewBottomMidPoint: CGPoint {return CGPoint(x:bounds.midX, y:bounds.midY * 1.8)}
    
    private var viewMidPoint: CGPoint {return CGPoint(x: bounds.midX, y:bounds.midY)}
    private var circleRadius: CGFloat {return min(bounds.width, bounds.height) / 2 * 0.8}
    private var count = 0
    
    private var tricolorTopStart: CGPoint {return CGPoint(x:bounds.maxX * 0.4, y:bounds.maxY * 0.2)}
    private var tricolorTopEnd: CGPoint {return CGPoint(x:bounds.maxX * 0.8, y:bounds.maxY * 0.3)}
    
    private var tricolorMidStart: CGPoint {return CGPoint(x:bounds.maxX * 0.4, y:bounds.maxY * 0.3)}
    private var tricolorMidEnd: CGPoint {return CGPoint(x:bounds.maxX * 0.8, y:bounds.maxY * 0.4)}
    
    private var tricolorBottomStart: CGPoint {return CGPoint(x:bounds.maxX * 0.4, y:bounds.maxY * 0.4)}
    private var tricolorBottomEnd: CGPoint {return CGPoint(x:bounds.maxX * 0.8, y:bounds.maxY * 0.5)}
    
    private var flagPoleStart: CGPoint {return CGPoint(x:bounds.maxX * 0.4, y:bounds.maxY * 0.1)}
    private var flagPoleEnd: CGPoint {return CGPoint(x:bounds.maxX * 0.3, y:bounds.maxY * 0.8)}
    

    func setCount(count: Int){
        self.count = count
    }
    override func draw(_ rect: CGRect) {
        
        let context=UIGraphicsGetCurrentContext()!
        switch showElement {
        case 0:
            colorEstoniaBlue.set()
            var flag = pathForStripe(stripeStart: tricolorTopStart, stripeEnd: tricolorTopEnd, lineWidth: lineWidth)
            flag.stroke()
            colorEstoniaBlack.set()
            flag = pathForStripe(stripeStart: tricolorMidStart, stripeEnd: tricolorMidEnd, lineWidth: lineWidth)
            flag.stroke()
            colorEstoniaWhite.set()
            flag = pathForStripe(stripeStart: tricolorBottomStart, stripeEnd: tricolorBottomEnd, lineWidth: lineWidth)
            flag.stroke()
            colorEstoniaYellow.set()
            flag = pathForStripe(stripeStart: flagPoleStart, stripeEnd: flagPoleEnd, lineWidth: lineWidth)
            flag.stroke()
        case 1:
            colorFlag.set()
            let flag = pathForFlag(firstLineStart: viewTopMidPoint, firstLineEnd: viewBottomMidPoint, secondLineStart: viewTopMidPoint, secondLineEnd: viewRightMidPoint, thirdLineStart: viewRightMidPoint, thirdLineEnd: viewMidPoint, lineWidth: lineWidth)
            flag.stroke()

        case 2:
           
            context.setFillColor(gray: 1.0, alpha: 1.0)
            context.fill(rect)
            var countString = ""
            if count == 0 {
                countString = ""
            } else {
                countString = "\(count)"
            }
            let string = NSAttributedString(string: countString,
                attributes: [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0),
                              NSAttributedString.Key.foregroundColor: UIColor.black ])
            
                
            
            let line = CTLineCreateWithAttributedString(string)
            let imageRect = CTLineGetImageBounds(line, context)
            context.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
            context.textPosition = CGPoint(x: rect.origin.x + floor((rect.size.width - imageRect.size.width) / 2.0),
                                           y: rect.origin.y + 10 + floor((rect.size.height - imageRect.size.height) / 2.0))
            context.setFillColor(gray: 0.9, alpha: 1.0)
            context.fill(rect)
            
            CTLineDraw(line, context)
            context.flush()
          
            
        case 3:
            colorBomb.set()
            let bomb = pathForBomb(midPoint: viewMidPoint, radius: circleRadius, lineWidth: lineWidth)
            bomb.stroke()
            

        case 4:
            colorBomb.set()
            let bomb = pathForBomb(midPoint: viewMidPoint, radius: circleRadius, lineWidth: lineWidth)
            bomb.stroke()
            
            colorCross.set()
            let cross = pathForCross(firstLineStart: viewUpperLeftCorner, firstLineEnd: viewLowerRightCorner, secondLineStart: viewUpperRightCorner, secondLineEnd: viewLowerLeftCorner, lineWidth: lineWidth)
            cross.stroke()

        
        default:
            break
        }
    }
    
    
    private func pathForBomb(midPoint: CGPoint, radius: CGFloat, lineWidth: Int) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        path.lineWidth = CGFloat(lineWidth)
        return path
    }
    private func pathForCross(firstLineStart: CGPoint, firstLineEnd: CGPoint, secondLineStart: CGPoint, secondLineEnd: CGPoint, lineWidth: Int) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = CGFloat(lineWidth)
        
        path.move(to: firstLineStart)
        path.addLine(to: firstLineEnd)
        path.move(to: secondLineStart)
        path.addLine(to: secondLineEnd)
        
        return path
    }
    
    private func pathForFlag(firstLineStart: CGPoint, firstLineEnd: CGPoint, secondLineStart: CGPoint, secondLineEnd: CGPoint, thirdLineStart: CGPoint, thirdLineEnd: CGPoint, lineWidth: Int) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = CGFloat(lineWidth)
        
        path.move(to: firstLineStart)
        path.addLine(to: firstLineEnd)
        path.move(to: secondLineStart)
        path.addLine(to: secondLineEnd)
        path.move(to: thirdLineStart)
        path.addLine(to: thirdLineEnd)
        
        return path
    }
    
    private func pathForTricolorFlag(upperColorStart: CGPoint, upperColorEnd: CGPoint, midColorStart: CGPoint, midColorEnd: CGPoint, bottomColorStart: CGPoint, bottomColorEnd: CGPoint, flagPoleStart: CGPoint, flagPoleEnd: CGPoint, lineWidth: Int)-> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = CGFloat(lineWidth)
        
        
        
        return path
    }
        
    private func pathForStripe(stripeStart: CGPoint, stripeEnd: CGPoint, lineWidth: Int)-> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = CGFloat(lineWidth)
        path.move(to: stripeStart)
        path.addLine(to: stripeEnd)
        return path
    }
    

    func drawUnknownTile(_ rect: CGRect, context: CGContext) {
        context.setFillColor(gray: 0.75, alpha: 1.0)
        context.setStrokeColor(gray: 0.5, alpha: 1.0)
        context.fill(rect)
        context.stroke(rect, width: 4.0)
    }
    
}
