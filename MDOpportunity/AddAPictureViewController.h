//
//  AddAPictureViewController.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-28.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+fixOrientation.h"
#import "AnnotateImageViewController.h"

@protocol AddPicturePopoverDelegate <NSObject>
-(void)AddPicturePopoverDoneButtonImage:(UIImage *)image;
-(void)AddPicturePopoverCancelButton;
@end

@interface AddAPictureViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, AnnotateImageDelegate, UIPopoverPresentationControllerDelegate>
@property (nonatomic, assign) id<AddPicturePopoverDelegate>delegate;
@property (nonatomic, assign) id mainVC;
@property (nonatomic, assign) id selectedVC;

- (IBAction)TakePhoto:(id)sender;
- (IBAction)ChoosePhoto:(id)sender;
- (IBAction)DrawPhoto:(id)sender;
@end
