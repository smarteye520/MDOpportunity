//
//  WeedsCell.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-21.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "WeedsCell.h"

@implementation WeedsCell

- (IBAction)ValueChanged:(id)sender
{
    [self.delegate UpdateReportedWeeds];
}

@end
