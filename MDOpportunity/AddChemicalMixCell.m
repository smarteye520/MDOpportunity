//
//  AddChemicalMixCell.m
//  ShortGrass
//
//  Created by XAGON on 2013-05-05.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "AddChemicalMixCell.h"

@implementation AddChemicalMixCell

- (IBAction)AddChemicalMix:(id)sender
{
    dataController = [[DatabaseController alloc] init];
    [dataController AddReportChemicalMixReportID:self.ReportID];
    [self.delegate ChemicalMixAdded];
}

@end
