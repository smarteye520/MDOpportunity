//
//  AddChemicalMixCell.h
//  ShortGrass
//
//  Created by XAGON on 2013-05-05.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseController.h"

@protocol AddChemicalMixCellDelegate <NSObject>
-(void)ChemicalMixAdded;
@end

@interface AddChemicalMixCell : UITableViewCell
{
    DatabaseController *dataController;
}

@property (strong, nonatomic) id mainVC;
@property (strong, nonatomic) id selectedVC;


@property int ReportID;
- (IBAction)AddChemicalMix:(id)sender;
@property (nonatomic, assign) id<AddChemicalMixCellDelegate> delegate;
@end
