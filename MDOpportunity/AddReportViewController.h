//
//  AddReportViewController.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-21.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseController.h"
#import "DatePopoeverViewController.h"
#import "OptionsPopoverViewController.h"

@protocol AddReportDelegate <NSObject>
-(void)AddReportPopoverDoneCustomer:(NSString *)Customer Date:(NSString *)Date OtherEmployee:(NSString *)OtherEmployee;
@end

@interface AddReportViewController : UIViewController <UIPopoverControllerDelegate, DatePopoverDelegate, UITextFieldDelegate, OptionsPopoverDelegate>
{
    DatabaseController *dataController;
}
@property (nonatomic, assign) id<AddReportDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *CustomerField;
@property (weak, nonatomic) IBOutlet UITextField *DateField;
@property (weak, nonatomic) IBOutlet UITextField *OtherEmploiyeeField;

@property (strong, nonatomic) id selectedVC;
@property (strong, nonatomic) id mainVC;

@end
