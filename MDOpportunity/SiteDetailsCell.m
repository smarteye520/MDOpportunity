//
//  SiteDetailsCell.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-21.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "SiteDetailsCell.h"
#import "ReportViewController.h"

@implementation SiteDetailsCell

-(void)load
{
    dataController = [[DatabaseController alloc] init];
}

- (IBAction)AddAPicture:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPhone" bundle:nil];
    }
    
    NSMutableArray *pictures = [dataController GetReportPictureReportID:self.ReportID];
    if (pictures.count < 4) {

        AddAPictureViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AddPicturePopover"];
        [viewController setDelegate:self];
//        if (CustomPopoverController == nil) {
//            CustomPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
//        }
        UIButton *button = (UIButton *)sender;
//        CGRect rect = [button convertRect:button.bounds toView:self.superview];
//        [CustomPopoverController presentPopoverFromRect:rect inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
        self.selectedVC = viewController;
        viewController.mainVC = viewController;
        viewController.modalPresentationStyle = UIModalPresentationPopover;
        
            CustomPopoverController  = [viewController popoverPresentationController];
            CustomPopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            CustomPopoverController.sourceView = self.superview;
            CustomPopoverController.sourceRect = CGRectMake(button.frame.origin.x, self.superview.frame.size.height - button.frame.size.height, button.frame.size.width, button.frame.size.height);
//            CustomPopoverController.delegate = self;
        
        [self.mainVC presentViewController:viewController animated:YES completion:nil];
    }
    else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exceeded Picture Limit" message:@"Each report has a limit of 4 pictures, please remove a picture and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
        
        UIAlertController *_alert = [UIAlertController alertControllerWithTitle:@"Exceeded Picture Limit"
                                                                        message:@"Each report has a limit of 4 pictures, please remove a picture and try again."
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [_alert addAction:defaultAction];
        [self.mainVC presentViewController:_alert animated:YES completion:nil];

    }
}

- (void)AddPicturePopoverDoneButtonImage:(UIImage *)image
{
//    [CustomPopoverController dismissPopoverAnimated:YES];
    
    CustomPopoverController = nil;
    [dataController AddReportPictureReportID:self.ReportID Image:image];
    [self.delegate PictureAdded];
    
    [self.selectedVC dismissViewControllerAnimated:YES completion:^{
        [self.mainVC dismissViewControllerAnimated:NO completion:nil];
        [[(ReportViewController *)self.mainVC tableView] reloadData];
    }];
//    [self.selectedVC dismissViewControllerAnimated:YES completion:^{
//
//    }];

}

- (void)AddPicturePopoverCancelButton
{
//    [CustomPopoverController dismissPopoverAnimated:YES];
    
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
    CustomPopoverController = nil;
}

@end
