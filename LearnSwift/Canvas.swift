//
//  Canvas.swift
//  LearnSwift
//
//  Created by Mady Mellor on 8/23/14.
//  Copyright (c) 2014 Mady Mellor. All rights reserved.
//

import Cocoa
import Foundation

public class Canvas: NSView {
    
    var canvasColor: NSColor
    var myColor: NSColor
    
    var drawActions: [DrawAction]
    var removedActions: [DrawAction]
    
    var brushSize: CGFloat
    var initialBrushSize: CGFloat
    
    required public init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: NSRect) {
        self.canvasColor = NSColor.whiteColor()
        self.myColor = NSColor.blueColor()
        self.brushSize = 10
        self.initialBrushSize = -1
        self.drawActions = []
        self.removedActions = []
        
        super.init(frame: frame)
    }
    
    override public func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        if (initialBrushSize == -1) {
            initialBrushSize = brushSize
        }
        canvasColor.setFill()
        NSRectFill(self.bounds)
        for cr in drawActions {
            cr.draw(initialBrushSize)
        }
    }
    
    override public func mouseDown(theEvent: NSEvent!) {
        super.mouseDown(theEvent)
        addRect(theEvent)
    }
    
    override public func mouseDragged(theEvent: NSEvent!) {
        super.mouseDragged(theEvent)
        addRect(theEvent)
    }
    
    public func setColour(color: NSColor) {
        myColor = color
        needsDisplay = true
    }
    
    public func setCanvasColour(color: NSColor) {
        canvasColor = color
        needsDisplay = true
    }
    
    public func setBrushSize(size: CGFloat) {
        if (initialBrushSize == -1) {
            initialBrushSize = size
        }
        brushSize = size
        needsDisplay = true
    }
    
    public func clearScreen() {
        removedActions = drawActions.reverse()
        drawActions = []
        needsDisplay = true
    }
    
    public func saveScreen(url: NSURL!) {
        var beautifulArtwork = self.bitmapImageRepForCachingDisplayInRect(self.bounds)
        self.cacheDisplayInRect(self.bounds, toBitmapImageRep: beautifulArtwork!)
        var data = beautifulArtwork!.TIFFRepresentation
        var nsData = NSData.self.dataWithData(data)
        nsData.writeToFile(url.path, atomically: false)
    }
    
    private func addRect(theEvent: NSEvent!) {
        var point = convertPoint(theEvent.locationInWindow, fromView:nil)
        var da = DrawAction(color: myColor, brushSize: brushSize, point: point)
        drawActions.append(da)
        needsDisplay = true
    }
    
    public func removeLastRect(goBackBy: NSInteger) {
        var actuallyGoBackBy = min(goBackBy, drawActions.count - 1)
        for (var i = 0; i < goBackBy && !drawActions.isEmpty; i++) {
            var lastOf = drawActions.removeLast()
            removedActions.append(lastOf)
        }
        needsDisplay = true
    }
    
    public func readdRect(goBackBy: NSInteger) {
        var actuallyGoBackBy = min(goBackBy, removedActions.count - 1)
        for (var i = 0; i < goBackBy && !removedActions.isEmpty; i++) {
            var lastOf = removedActions.removeLast()
            drawActions.append(lastOf)
        }
        needsDisplay = true
    }
}
