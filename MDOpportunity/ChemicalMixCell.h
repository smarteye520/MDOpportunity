//
//  ChemicalMixCell.h
//  ShortGrass
//
//  Created by XAGON on 2013-05-05.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsPopoverViewController.h"
#import "DatabaseController.h"

@interface ChemicalMixCell : UITableViewCell <UITextFieldDelegate, UIPopoverControllerDelegate, OptionsPopoverDelegate, UIPopoverPresentationControllerDelegate>
{
    DatabaseController *dataController;
    UIPopoverPresentationController *CustomPopoverController;
}

@property (strong, nonatomic) id mainVC;
@property (strong, nonatomic) id selectedVC;


-(void)Load;
@property int ChemicalID;
@property int ReportID;
@property (weak, nonatomic) IBOutlet UITextField *ChemicalField;
@property (weak, nonatomic) IBOutlet UITextField *ApplicationMethod;
@property (weak, nonatomic) IBOutlet UITextField *VolumeSprayed;
@property (weak, nonatomic) IBOutlet UITextField *ConcentrationField;
@property (weak, nonatomic) IBOutlet UITextField *UnitsField;
@property (weak, nonatomic) IBOutlet UITextField *ChemicalUsed;

@end
