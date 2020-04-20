//
//  DirectionController.m
//  ShortGrass
//
//  Created by XAGON on 2013-05-24.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "DirectionController.h"

@interface DirectionController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *FromOrTwoControl;
- (IBAction)DirectionSelected:(id)sender;

@end

@implementation DirectionController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)DirectionSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (self.FromOrTwoControl.selectedSegmentIndex == 1) {
        NSString *result;
        if ([button.titleLabel.text isEqual:@"N"]) {
            result = @"S";
        }
        else if ([button.titleLabel.text isEqual:@"NE"]) {
            result = @"SW";
        }
        else if ([button.titleLabel.text isEqual:@"E"]) {
            result = @"W";
        }
        else if ([button.titleLabel.text isEqual:@"SE"]) {
            result = @"NW";
        }
        else if ([button.titleLabel.text isEqual:@"S"]) {
            result = @"N";
        }
        else if ([button.titleLabel.text isEqual:@"SW"]) {
            result = @"NE";
        }
        else if ([button.titleLabel.text isEqual:@"NW"]) {
            result = @"SE";
        }
        else {
            result = @"E";
        }
        [self.delegate DirectionPopoverDoneButtonName:self.Name Object:result TextField:self.TextField];
    }
    else {
        [self.delegate DirectionPopoverDoneButtonName:self.Name Object:button.titleLabel.text TextField:self.TextField];
    }
}

@end
