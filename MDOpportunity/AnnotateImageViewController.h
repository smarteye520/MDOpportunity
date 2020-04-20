//
//  AnnotateImageViewController.h
//  ShortGrass
//
//  Created by XAGON on 2013-05-22.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPopoverViewController.h"
#import "DrawingView.h"

@protocol AnnotateImageDelegate <NSObject>
-(void)AnnotateImageDone:(UIImage *)image ID:(int)imageID;
-(void)AnnotateImageCancel;
@end

@interface AnnotateImageViewController : UIViewController <ColorPopoverDelegate>
{
//    UIPopoverController *seguePopover;
}
@property (nonatomic, assign) id<AnnotateImageDelegate> delegate;
@property UIImage *Image;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property int imageID;

@property(strong, nonatomic) id selectedVC;
@end
