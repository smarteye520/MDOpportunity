//
//  ReportTableViewController.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-19.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseController.h"
#import "ReportViewController.h"
#import "AddReportViewController.h"
#import "NetworkController.h"

@interface ReportTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, AddReportDelegate, UIPopoverControllerDelegate, NetworkControllerDelegate>
{
    DatabaseController *dataController;
    NSMutableArray *reports;
    
    NetworkController *netController;
    NSMutableArray *uploadReports;
    int reportIndex;
}
@property NSString *employee;
@property id selectedVC;
- (IBAction)AddReport:(id)sender;

@end
