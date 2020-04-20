//
//  SiteDetailsPictureCell.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-21.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "SiteDetailsPictureCell.h"
#import "ReportViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation SiteDetailsPictureCell

-(void)load
{
    dataController = [[DatabaseController alloc] init];
    if (self.ImageOne.image != nil) {
        [self.ImageOne addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewSelected:)]];
        [self.ImageOne.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [self.ImageOne.layer setBorderWidth:2.0];
        self.ImageOne.layer.cornerRadius = 5;
        self.ImageOne.clipsToBounds = YES;
    }
    else {
        self.ImageOne.gestureRecognizers = nil;
        [self.ImageOne.layer setBorderWidth:0.0];
    }
    if (self.ImageTwo.image != nil) {
        [self.ImageTwo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewSelected:)]];
        [self.ImageTwo.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [self.ImageTwo.layer setBorderWidth:2.0];
        self.ImageTwo.layer.cornerRadius = 5;
        self.ImageTwo.clipsToBounds = YES;
    }
    else {
        self.ImageTwo.gestureRecognizers = nil;
        [self.ImageTwo.layer setBorderWidth:0.0];
    }
    if (self.ImageThree.image != nil) {
         [self.ImageThree addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewSelected:)]];
        [self.ImageThree.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [self.ImageThree.layer setBorderWidth:2.0];
        self.ImageThree.layer.cornerRadius = 5;
        self.ImageThree.clipsToBounds = YES;
    }
    else {
        self.ImageThree.gestureRecognizers = nil;
        [self.ImageThree.layer setBorderWidth:0.0];
    }
    if (self.ImageFour.image != nil) {
         [self.ImageFour addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewSelected:)]];
        [self.ImageFour.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [self.ImageFour.layer setBorderWidth:2.0];
        self.ImageFour.layer.cornerRadius = 5;
        self.ImageFour.clipsToBounds = YES;
    }
    else {
        self.ImageFour.gestureRecognizers = nil;
        [self.ImageFour.layer setBorderWidth:0.0];
    }
    if (self.ImageFive.image != nil) {
         [self.ImageFive addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewSelected:)]];
        [self.ImageFive.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [self.ImageFive.layer setBorderWidth:2.0];
        self.ImageFive.layer.cornerRadius = 5;
        self.ImageFive.clipsToBounds = YES;
    }
    else {
        self.ImageFive.gestureRecognizers = nil;
        [self.ImageFive.layer setBorderWidth:0.0];
    }
}

-(void)ImageViewSelected:(UIGestureRecognizer *)sender
{
    UIImageView *image = (UIImageView *)sender.view;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPhone" bundle:nil];
    }
    EditImageViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"EditImagePopover"];
    if (image == self.ImageOne) {
        viewController.imageID = self.ImageOneID;
    }
    else if (image == self.ImageTwo) {
        viewController.imageID = self.ImageTwoID;
    }
    else if (image == self.ImageThree) {
        viewController.imageID = self.ImageThreeID;
    }
    else if (image == self.ImageFour) {
        viewController.imageID = self.ImageFourID;
    }
    else {
        viewController.imageID = self.ImageFiveID;
    }
    viewController.delegate = self;
//    if (CustomPopoverController == nil) {
//        CustomPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
//    }
    
//    CustomPopoverController.delegate = self;
//    [CustomPopoverController presentPopoverFromRect:rect inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        CGRect rect = [image convertRect:image.bounds toView:self.superview];
        viewController.modalPresentationStyle = UIModalPresentationPopover;
        CustomPopoverController  = [viewController popoverPresentationController];
        CustomPopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        CustomPopoverController.sourceView = viewController.view;
        CustomPopoverController.sourceRect = rect;

    }
    self.selectedVC = viewController;
    viewController.mainVC = self.mainVC;

    [self.mainVC presentViewController:viewController animated:YES completion:nil];
    
    
    [viewController.Image setImage:[image image]];
}

-(void)DeletePicture:(int)ImageID
{
//    [CustomPopoverController dismissPopoverAnimated:YES];
    
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
    CustomPopoverController = nil;
    [dataController DeleteReportPictureID:ImageID];
    [self.delegate PictureEdited];
}

-(void)AnnotatePicture:(int)ImageID
{
//    [CustomPopoverController dismissPopoverAnimated:YES];
    
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
    
    CustomPopoverController = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPhone" bundle:nil];
    }
    AnnotateImageViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AnnotateImage"];
    viewController.delegate = self;
    if (ImageID == self.ImageOneID) {
        viewController.Image = self.ImageOne.image;
        viewController.imageID = self.ImageOneID;
    }
    else if (ImageID == self.ImageTwoID) {
        viewController.Image = self.ImageTwo.image;
        viewController.imageID = self.ImageTwoID;
    }
    else if (ImageID == self.ImageThreeID) {
        viewController.Image = self.ImageThree.image;
        viewController.imageID = self.ImageThreeID;
    }
    else if (ImageID == self.ImageFourID) {
        viewController.Image = self.ImageFour.image;
        viewController.imageID = self.ImageFourID;
    }
    else if (ImageID == self.ImageFiveID) {
        viewController.Image = self.ImageFive.image;
        viewController.imageID = self.ImageFiveID;
    }
//    UITableView *tableView = (UITableView *)self.superview.superview;
//    ReportViewController *reportViewController = [storyboard instantiateViewControllerWithIdentifier:@"ReportVC"];
    
    self.selectedVC = viewController;
    [self.mainVC presentViewController:viewController animated:YES completion:nil];
}

-(void)AnnotateImageDone:(UIImage *)image ID:(int)imageID
{
    [dataController UpdateReportPictureID:imageID Image:image];
//    UITableView *tableView = (UITableView *)self.superview.superview;
//    ReportViewController *reportViewController = (ReportViewController *)tableView.dataSource;
//    [reportViewController dismissViewControllerAnimated:YES completion:nil];
    [self.delegate PictureEdited];
    
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)AnnotateImageCancel
{
//    UITableView *tableView = (UITableView *)self.superview.superview;
//    ReportViewController *reportViewController = (ReportViewController *)tableView.dataSource;
//    [reportViewController dismissViewControllerAnimated:YES completion:nil];
    
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
}

//-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
//{
//    CustomPopoverController = nil;
//}

@end
