//
//  MainCell.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-21.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LocationManager.h"
#import "DatePopoeverViewController.h"
#import "OptionsPopoverViewController.h"
#import "DirectionController.h"
#import "SVProgressHUD.h"
#import "WeatherRequest.h"

//#import "ReportViewController.h"

@interface MainCell : UITableViewCell <LocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate, WeatherRequestDelegate, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, DatePopoverDelegate, OptionsPopoverDelegate, DirectionPopoverDelegate, CLLocationManagerDelegate>
{
    LocationManager *locationManager;
    DatabaseController *dataController;
    UIPopoverPresentationController *CustomPopoverController;
    //UIViewController *CustomUIViewController;
    
    CLLocationManager * myLocationMananger;
    UITextView *textView;
    UITextField * textField;
}

@property (strong, nonatomic) id mainVC;
@property (strong, nonatomic) id selectedVC;

-(void)Load;
@property NSMutableArray *report;
- (IBAction)GetGPSLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *CustomerField;
@property (weak, nonatomic) IBOutlet UITextField *SiteTypeField;
@property (weak, nonatomic) IBOutlet UITextField *DateField;
@property (weak, nonatomic) IBOutlet UITextField *TechnicianField;
@property (weak, nonatomic) IBOutlet UITextField *LSDField;
@property (weak, nonatomic) IBOutlet UITextField *LatitudeField;
@property (weak, nonatomic) IBOutlet UITextField *LongitudeField;
@property (weak, nonatomic) IBOutlet UITextField *AccuracyField;
@property (weak, nonatomic) IBOutlet UITextField *PrecipitationField;
@property (weak, nonatomic) IBOutlet UITextField *TemperatureField;
@property (weak, nonatomic) IBOutlet UITextField *RelativeHumidity;
@property (weak, nonatomic) IBOutlet UITextField *AreaSprayedField;
@property (weak, nonatomic) IBOutlet UITextField *WindDirectionField;
@property (weak, nonatomic) IBOutlet UITextField *WindSpeedField;
@property (weak, nonatomic) IBOutlet UITextField *TimeField;
@property (weak, nonatomic) IBOutlet UITextView *CommentsField;


@end
