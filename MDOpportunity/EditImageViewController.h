//
//  EditImageViewController.h
//  ShortGrass
//
//  Created by XAGON on 2013-05-05.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditImagePopoverDelegate <NSObject>
-(void)DeletePicture:(int)ImageID;
-(void)AnnotatePicture:(int)ImageID;
@end

@interface EditImageViewController : UIViewController <UIAlertViewDelegate>
@property (nonatomic, assign) id<EditImagePopoverDelegate> delegate;
@property int imageID;
@property (weak, nonatomic) IBOutlet UIImageView *Image;

@property (strong, nonatomic) id mainVC;

- (IBAction)DeleteImage:(id)sender;
- (IBAction)AnnotateImage:(id)sender;

@end
