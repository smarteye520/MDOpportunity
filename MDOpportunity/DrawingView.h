//
//  DrawingView.h
//  ShortGrass
//
//  Created by XAGON on 2013-05-22.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingView : UIView
{
    CGPoint gestureStartPoint;
    CGPoint currentPosition;
    UIBezierPath *currentPath;
    NSMutableArray *paths;
}
-(void)Load;
-(void)Clear;
@property int LineSize;
@property(nonatomic,retain)UIColor *Color;
@end
