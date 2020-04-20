//
//  WeedsCell.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-21.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeedsCellDelegate <NSObject>
-(void)UpdateReportedWeeds;
@end

@interface WeedsCell : UITableViewCell
@property int ReportID;
@property (weak, nonatomic) IBOutlet UISegmentedControl *AnswerControl;
@property (weak, nonatomic) IBOutlet UILabel *TextLabel;

@property (strong, nonatomic) id mainVC;
@property (strong, nonatomic) id selectedVC;


- (IBAction)ValueChanged:(id)sender;
@property (nonatomic, assign) id<WeedsCellDelegate> delegate;
@end
