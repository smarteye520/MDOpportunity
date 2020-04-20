//
//  AddAPictureViewController.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-28.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "AddAPictureViewController.h"

@interface AddAPictureViewController ()
@property (strong, nonatomic) UIPopoverPresentationController *popover;
@end

@implementation AddAPictureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(IBAction)closeAction:(id)sender
{
    [self.mainVC dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)TakePhoto:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIButton *button = (UIButton *)sender;
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        /*
        if (self.popover == nil) {
            self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        }
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
         
         */
        self.selectedVC = imagePickerController;
        imagePickerController.modalPresentationStyle = UIModalPresentationPopover;

        if(self.popover == nil)
        {
            
            self.popover  = [imagePickerController popoverPresentationController];
            self.popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
            self.popover.sourceView = self.view;
            self.popover.sourceRect = button.frame;
            self.popover.delegate = self;
            
        }
        [self.mainVC presentViewController:(UIViewController *)imagePickerController animated:YES completion:nil];

    }
}

- (IBAction)ChoosePhoto:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIButton *button = (UIButton *)sender;
        UIImagePickerController *imagePickerController=[[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        
        /*
        if (self.popover == nil) {
            self.popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        }
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
         
         */
        self.selectedVC = imagePickerController;
        imagePickerController.modalPresentationStyle = UIModalPresentationPopover;
        
            self.popover  = [imagePickerController popoverPresentationController];
            self.popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
            self.popover.sourceView = self.view;
            self.popover.sourceRect = button.frame;
            self.popover.delegate = self;
         
        
        [self.mainVC presentViewController:(UIViewController *)imagePickerController animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    self.popover = nil;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image fixOrientation];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self.delegate AddPicturePopoverDoneButtonImage:image];
    
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
    
    self.popover = nil;
    [self.delegate AddPicturePopoverCancelButton];
}


- (IBAction)DrawPhoto:(id)sender
{
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
    
    self.popover = nil;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPhone" bundle:nil];
    }

    AnnotateImageViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AnnotateImage"];
    viewController.delegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)AnnotateImageDone:(UIImage *)image ID:(int)imageID
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self.delegate AddPicturePopoverDoneButtonImage:image];
}

- (void)AnnotateImageCancel
{
    [self.delegate AddPicturePopoverCancelButton];
}

@end
