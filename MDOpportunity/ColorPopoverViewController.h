//
//  ColorPopoverViewController.h
//  ShortGrass
//
//  Created by XAGON on 2013-05-22.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorPopoverDelegate <NSObject>
-(void)ColorPopoverPickedColor:(UIColor *)color;
@end

@interface ColorPopoverViewController : UIViewController
@property (nonatomic, assign) id<ColorPopoverDelegate> delegate;
@end
