//
//  SiteDetailsPictureCell.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-21.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseController.h"
#import "EditImageViewController.h"
#import "AnnotateImageViewController.h"

@protocol SiteDetailsPictureCellDelegate <NSObject>
-(void)PictureEdited;
@end

@interface SiteDetailsPictureCell : UITableViewCell <EditImagePopoverDelegate, AnnotateImageDelegate, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate>
{
    DatabaseController *dataController;
    UIPopoverPresentationController *CustomPopoverController;
}
@property int ReportID;
@property (nonatomic, assign) id<SiteDetailsPictureCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *ImageOne;
@property int ImageOneID;
@property (weak, nonatomic) IBOutlet UIImageView *ImageTwo;
@property int ImageTwoID;
@property (weak, nonatomic) IBOutlet UIImageView *ImageThree;
@property int ImageThreeID;
@property (weak, nonatomic) IBOutlet UIImageView *ImageFour;
@property int ImageFourID;
@property (weak, nonatomic) IBOutlet UIImageView *ImageFive;
@property int ImageFiveID;


@property (strong, nonatomic) id mainVC;
@property (strong, nonatomic) id selectedVC;

-(void)load;
@end
