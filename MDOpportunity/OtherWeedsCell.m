//
//  OtherWeedsCell.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-28.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "OtherWeedsCell.h"

@implementation OtherWeedsCell

- (IBAction)ValueChanged:(id)sender
{
    if (self.AnswerControl.selectedSegmentIndex == 0) {
        if ([self.OtherWeedsField.text isEqual:@""]) {
            self.AnswerControl.selectedSegmentIndex = 1;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"In order to select yes, first enter a name into the text field on the left." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [alert show];
            
            
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"In order to select yes, first enter a name into the text field on the left."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            
            UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            while (topController.presentedViewController) {
                topController = topController.presentedViewController;
            }
            [topController presentViewController:alert animated:YES completion:nil];

            
            
        }
        else {
            DatabaseController *dataController = [[DatabaseController alloc] init];
            [dataController UpdateReportID:self.ReportID OtherWeeds:self.OtherWeedsField.text];
            
            [dataController UpdateIsSynced:self.ReportID IsSynced:NO];

        }
    }
    else {
        self.OtherWeedsField.text = @"";
        DatabaseController *dataController = [[DatabaseController alloc] init];
        [dataController UpdateReportID:self.ReportID OtherWeeds:self.OtherWeedsField.text];
        
        [dataController UpdateIsSynced:self.ReportID IsSynced:NO];

    }
}

@end
