//
//  OptionsPopoverViewController.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-28.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "OptionsPopoverViewController.h"

@interface OptionsPopoverViewController ()
- (IBAction)NextClick:(id)sender;
- (IBAction)CancelClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *OptionPicker;
@property (weak, nonatomic) IBOutlet UITextField *ObjectField;
@property (nonatomic) NSMutableArray *Objects;
@property (weak, nonatomic) IBOutlet UINavigationItem *TitleItem;
@end

@implementation OptionsPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.Objects = [self.delegate OptionsPopoverAddObjectsName:self.Name];
    self.TitleItem.title = self.Name;
    self.ObjectField.text = self.TextField.text;
    //[self.ObjectField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.Objects count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.Objects objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _ObjectField.text = [self.Objects objectAtIndex:row];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate OptionsPopoverDoneButtonName:self.Name Object:_ObjectField.text TextField:self.TextField];
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)NextClick:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];

//    [self dismissViewControllerAnimated:YES completion:nil];

    [self.delegate OptionsPopoverDoneButtonName:self.Name Object:_ObjectField.text TextField:self.TextField];
}

- (IBAction)CancelClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

    [self.delegate OptionsPopoverCancelButton];
}

@end
