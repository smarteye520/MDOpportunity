//
//  DatePopoeverViewController.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-20.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "DatePopoeverViewController.h"

@interface DatePopoeverViewController ()
- (IBAction)Done:(id)sender;
- (IBAction)Cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;
@end

@implementation DatePopoeverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.Name;
    if (self.textField.text != nil && ![self.textField.text isEqualToString:@""]) {
        @try {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            self.DatePicker.date = [formatter dateFromString:self.textField.text];
        }
        @catch (NSException *exception) {
            return;
        }
    }
}

- (IBAction)Done:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    [self.delegate DatePopoverDoneDate:[dateFormatter stringFromDate:self.DatePicker.date] TextField:self.textField];
}

- (IBAction)Cancel:(id)sender
{
    [self.delegate DatePopoverCancel];
}
@end
