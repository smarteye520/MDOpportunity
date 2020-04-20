//
//  DrawingView.m
//  ShortGrass
//
//  Created by XAGON on 2013-05-22.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "DrawingView.h"

@implementation DrawingView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        currentPath = [[UIBezierPath alloc]init];
        currentPath.lineWidth=3;
    }
    return self;
}

- (void)Load
{
    paths = [[NSMutableArray alloc] init];
    currentPath = [[UIBezierPath alloc]init];
    currentPath.lineWidth = self.LineSize;
}

- (void)Clear
{
    for (int i = 0; i < paths.count; i++) {
        UIBezierPath *pathAtI = (UIBezierPath *)[[paths objectAtIndex:i] objectAtIndex:0];
        [pathAtI removeAllPoints];
    }
    [paths removeAllObjects];
    [currentPath removeAllPoints];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    for (int i = 0; i < paths.count; i++) {
        UIColor *pathColor = (UIColor *)[[paths objectAtIndex:i] objectAtIndex:1];
        UIBezierPath *pastPath = (UIBezierPath *)[[paths objectAtIndex:i] objectAtIndex:0];
        int width = [(NSNumber *)[[paths objectAtIndex:i] objectAtIndex:2] intValue];
        [pathColor set];
        pastPath.lineWidth = width;
        [pastPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    }
    [self.Color set];
    currentPath.lineWidth = self.LineSize;
    [currentPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    gestureStartPoint = [touch locationInView:self];
    [currentPath moveToPoint:(gestureStartPoint)];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    currentPosition = [touch locationInView:self];
    [currentPath addLineToPoint:(currentPosition)];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableArray *pathParts = [[NSMutableArray alloc] init];
    [pathParts addObject:currentPath];
    [pathParts addObject:self.Color];
    [pathParts addObject:[NSNumber numberWithInt:self.LineSize]];
    [paths addObject:pathParts];
    currentPath = [[UIBezierPath alloc] init];
    currentPath.lineWidth = self.LineSize;
}

@end
