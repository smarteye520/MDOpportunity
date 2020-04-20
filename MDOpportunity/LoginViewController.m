//
//  LoginViewController.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-19.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataController = [[DatabaseController alloc] init];
    employees = [dataController GetEmployees];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return employees.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        selectedEmployee = [employees objectAtIndex:row];
    }
    return [employees objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedEmployee = [employees objectAtIndex:row];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqual:@"LoginSegue"]) {
        
//        self.EmployeesPickerView.sel
        
        if (selectedEmployee == nil || [selectedEmployee isEqual:@""]) {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                           message:@"Please select employee."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];

            return NO;
        }
        else {
            return YES;
        }
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"LoginSegue"]) {
        ReportTableViewController *destViewController = (ReportTableViewController*)[[segue destinationViewController] topViewController];
        destViewController.employee = selectedEmployee;
    }
}

- (IBAction)UpdateEmployeeList:(id)sender
{
    
    [self.EmployeesPickerView selectRow:0 inComponent:0 animated:YES];

//    DELETEREPUPDATE
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *toggle = [defaults stringForKey:@"DELETEREPUPDATE"];
    
    if([toggle isEqualToString:@"1"])
    {
        [dataController RemoveAllReports];
        [defaults setValue:@"0" forKey:@"DELETEREPUPDATE"];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Deletion Successfull!"
                                                                            message:@"Application database has been deleted."
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];

    }

    netController = [[NetworkController alloc] init];
    netController.delegate = self;
    [netController UpdateTables];
    [SVProgressHUD showWithStatus:@"Contacting server, please wait." maskType:SVProgressHUDMaskTypeBlack];
}

-(void)NetworkControllerUpdateTablesEmployees:(NSMutableArray *)Employees Clients:(NSMutableArray *)Clients Weeds:(NSMutableArray *)Weeds ChemicalMixes:(NSMutableArray *)ChemicalMixes
{
    [dataController UpdateEmployees:Employees];
    [dataController UpdateClients:Clients];
    [dataController UpdateWeeds:Weeds];
    [dataController UpdateChemicalMixes:ChemicalMixes];
    employees = [dataController GetEmployees];
    [self.EmployeesPickerView reloadAllComponents];
    [SVProgressHUD dismiss];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sync Complete"
                                                                   message:@"Application database has been updated successfully."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)NetworkControllerErrorTitle:(NSString *)Title Message:(NSString *)Message
{
    [SVProgressHUD dismiss];

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:Title
                                                                   message:Message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
