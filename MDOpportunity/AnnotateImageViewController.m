//
//  AnnotateImageViewController.m
//  ShortGrass
//
//  Created by XAGON on 2013-05-22.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "AnnotateImageViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AnnotateImageViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *TitleItem;
- (IBAction)Cancel:(id)sender;
- (IBAction)Done:(id)sender;
- (IBAction)Clear:(id)sender;
- (IBAction)SizeChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ColorButton;
@property (weak, nonatomic) IBOutlet DrawingView *DrawingView;
@property (weak, nonatomic) IBOutlet UIView *PictureView;

@end

@implementation AnnotateImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ImageView.image = self.Image;
    [self.DrawingView Load];
    self.DrawingView.Color = [UIColor blackColor];
    self.ColorButton.tintColor = [UIColor blackColor];
    self.DrawingView.LineSize = 1;
}

- (IBAction)Clear:(id)sender
{
    [self.DrawingView Clear];
}

- (IBAction)SizeChanged:(id)sender
{
    UISegmentedControl *lineWidthSegment = (UISegmentedControl *)sender;
    int index = (int)lineWidthSegment.selectedSegmentIndex;
    if (index == 0) {
        self.DrawingView.LineSize = 1;
    }
    else if (index == 1) {
        self.DrawingView.LineSize = 8;
    }
    else {
        self.DrawingView.LineSize = 20;
    }
}

- (IBAction)Cancel:(id)sender
{
    [self.delegate AnnotateImageCancel];
}

- (IBAction)Done:(id)sender
{
    UIGraphicsBeginImageContext(self.PictureView.bounds.size);
    [self.PictureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.delegate AnnotateImageDone:image ID:self.imageID];
}
- (void) ColorPopoverPickedColor:(UIColor *)color
{
    self.ColorButton.tintColor = color;
    self.DrawingView.Color = color;
    //    [seguePopover dismissPopoverAnimated:YES];
    
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"ColorPopoverSegue"]) {
//        seguePopover = ((UIStoryboardPopoverSegue *)segue).popoverController;
        ColorPopoverViewController *colorPop = (ColorPopoverViewController *)segue.destinationViewController;
        colorPop.delegate = self;
        self.selectedVC = colorPop;
        
    }
}

@end
