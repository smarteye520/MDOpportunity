//
//  EditImageViewController.m
//  ShortGrass
//
//  Created by XAGON on 2013-05-05.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "EditImageViewController.h"

@interface EditImageViewController ()

@end

@implementation EditImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)DeleteImage:(id)sender
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Are you sure you want to delete this image?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//    [alert show];
    
    UIAlertController *_alert = [UIAlertController alertControllerWithTitle:@"Are you sure?"
                                                                    message:@"Are you sure you want to delete this image?"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              [self.delegate DeletePicture:self.imageID];

                                                          }];
    UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [_alert addAction:defaultAction];
    [_alert addAction:defaultAction1];
    
    [self presentViewController:_alert animated:YES completion:nil];
    
}

- (IBAction)AnnotateImage:(id)sender
{
    [self.delegate AnnotatePicture:self.imageID];
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex != 0)
//    {
//    }
//}
@end
