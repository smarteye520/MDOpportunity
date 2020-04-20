//
//  SiteDetailsCell.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-21.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseController.h"
#import "AddAPictureViewController.h"

@protocol SiteDetailsCellDelegate <NSObject>
-(void)PictureAdded;
@end

@interface SiteDetailsCell : UITableViewCell <AddPicturePopoverDelegate>
{
    DatabaseController *dataController;
    UIPopoverPresentationController *CustomPopoverController;
}
-(void)load;
@property int ReportID;
@property (nonatomic, assign) id<SiteDetailsCellDelegate> delegate;
- (IBAction)AddAPicture:(id)sender;


@property (strong, nonatomic) id mainVC;
@property (strong, nonatomic) id selectedVC;

@end
