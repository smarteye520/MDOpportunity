//
//  AddReportViewController.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-21.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "AddReportViewController.h"

@interface AddReportViewController () <UIPopoverPresentationControllerDelegate>
- (IBAction)DoneClick:(id)sender;
- (IBAction)CancelClick:(id)sender;
@property (strong, nonatomic) UIPopoverPresentationController *CustomPopoverController;
@end

@implementation AddReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    dataController = [[DatabaseController alloc] init];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.DateField)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
        {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPhone" bundle:nil];
        }
        
        DatePopoeverViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"DatePopover"];
        [viewController setDelegate:self];
        viewController.textField = self.DateField;
        
        self.selectedVC = viewController;
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
        
            viewController.modalPresentationStyle = UIModalPresentationPopover;
            self.CustomPopoverController  = [viewController popoverPresentationController];
            self.CustomPopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            self.CustomPopoverController.sourceView = self.view;
            self.CustomPopoverController.sourceRect = textField.frame;
            self.CustomPopoverController.delegate = self;
        }
        [self presentViewController:viewController animated:YES completion:nil];
        
//        if (self.CustomPopoverController == nil) {
//            self.CustomPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
//        }
//        self.CustomPopoverController.delegate = self;
//        [self.CustomPopoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        return NO;
    }
    else if (textField == self.CustomerField || textField == self.OtherEmploiyeeField) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
        {
            storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPhone" bundle:nil];
        }
        
        OptionsPopoverViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"OptionsPopover"];
        if (textField == self.CustomerField) {
            viewController.Name = @"Customer";
            viewController.TextField = self.CustomerField;
        }
        else {
            viewController.Name = @"Other Technician";
            viewController.TextField = self.OtherEmploiyeeField;
        }
        [viewController setDelegate:self];
        
        self.selectedVC = viewController;
        viewController.modalPresentationStyle = UIModalPresentationPopover;
        self.CustomPopoverController  = [viewController popoverPresentationController];
        self.CustomPopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.CustomPopoverController.sourceView = self.view;
        self.CustomPopoverController.sourceRect = textField.frame;
        self.CustomPopoverController.delegate = self;
        
        [self presentViewController:viewController animated:YES completion:nil];
        
//        if (self.CustomPopoverController == nil) {
//            self.CustomPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
//        }
//        self.CustomPopoverController.delegate = self;
//        [self.CustomPopoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        return NO;
    }
    return YES;
}

- (void)DatePopoverDoneDate:(NSString *)date TextField:(UITextField *)textField
{
    textField.text = date;
    //[self.CustomPopoverController dismissPopoverAnimated:YES];
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
    
    self.CustomPopoverController = nil;
}

- (void)DatePopoverCancel
{
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];

//    [self.CustomPopoverController dismissPopoverAnimated:YES];
    self.CustomPopoverController = nil;
}

- (NSMutableArray *)OptionsPopoverAddObjectsName:(NSString *)name
{
    if ([name isEqual: @"Customer"]) {
        return [dataController GetClients];
    }
    else {
        return [dataController GetEmployees];
    }
}

- (void)OptionsPopoverDoneButtonName:(NSString *)name Object:(NSString *)object TextField:(UITextField *)textField
{
    textField.text = object;

    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];

//    [self.CustomPopoverController dismissPopoverAnimated:YES];
    self.CustomPopoverController = nil;
}

- (void)OptionsPopoverCancelButton
{
    
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];

//    [self.CustomPopoverController dismissPopoverAnimated:YES];
    self.CustomPopoverController = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
//{
//    self.CustomPopoverController = nil;
//}

- (IBAction)DoneClick:(id)sender
{
    
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    [self.delegate AddReportPopoverDoneCustomer:self.CustomerField.text Date:self.DateField.text OtherEmployee:self.OtherEmploiyeeField.text];
}

- (IBAction)CancelClick:(id)sender
{
    [self.delegate AddReportPopoverDoneCustomer:nil Date:nil OtherEmployee:nil];
}

@end
