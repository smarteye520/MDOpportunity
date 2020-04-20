//
//  OtherWeedsCell.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-28.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseController.h"

@interface OtherWeedsCell : UITableViewCell

@property int ReportID;
@property (weak, nonatomic) IBOutlet UITextField *OtherWeedsField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *AnswerControl;

@property (strong, nonatomic) id mainVC;
@property (strong, nonatomic) id selectedVC;

- (IBAction)ValueChanged:(id)sender;

@end
