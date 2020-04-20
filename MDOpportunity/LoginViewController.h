//
//  LoginViewController.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-19.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseController.h"
#import "NetworkController.h"
#import "ReportTableViewController.h"
#import "SVProgressHUD.h"

@interface LoginViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, NetworkControllerDelegate>
{
    DatabaseController *dataController;
    NetworkController *netController;
    NSMutableArray *employees;
    NSString *selectedEmployee;
}
- (IBAction)UpdateEmployeeList:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *EmployeesPickerView;

@end
