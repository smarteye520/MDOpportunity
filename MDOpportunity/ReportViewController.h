//
//  ReportViewController.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-19.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseController.h"
#import "NetworkController.h"
#import "MainCell.h"
#import "ChemicalMixCell.h"
#import "AddChemicalMixCell.h"
#import "SiteDetailsCell.h"
#import "WeedsCell.h"
#import "OtherWeedsCell.h"
#import "SiteDetailsPictureCell.h"
#import "SVProgressHUD.h"

@interface ReportViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, SiteDetailsCellDelegate, WeedsCellDelegate, AddChemicalMixCellDelegate, SiteDetailsPictureCellDelegate, NetworkControllerDelegate>
{
    DatabaseController *dataController;
    NetworkController *netController;
    NSMutableArray *WeedsList;
    NSMutableArray *ReportWeeds;
    NSMutableArray *Pictures;
    NSMutableArray *ChemicalMixes;
}

@property NSMutableArray *report;
- (IBAction)UploadReport:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *LSDField;
@property (weak, nonatomic) IBOutlet UITextField *CustomerName;

@end
