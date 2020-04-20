//
//  ReportTableViewController.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-19.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "ReportTableViewController.h"

@interface ReportTableViewController () <UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) UIPopoverPresentationController *CustomPopoverController;
@end

@implementation ReportTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataController = [[DatabaseController alloc] init];
//    reports = [dataController GetReports];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    reports = [dataController GetReports];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return reports.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSMutableArray *)[reports objectAtIndex:section]).count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[reports objectAtIndex:section] objectAtIndex:0] objectAtIndex:7];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[[reports objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:3];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@: %@",[[[reports objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:1], [[[reports objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:8]];
    if ([dataController IsReportSynced:[[[[reports objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:0] intValue]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *report = [[reports objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [dataController RemoveReport:[[report objectAtIndex:0] intValue]];
        reports = [dataController GetReports];
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqual:@"ReportSegue"]) {
        ReportViewController *destViewController = (ReportViewController*)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        destViewController.report = [[reports objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
}

- (IBAction)AddReport:(id)sender
{
    /* actual add report code */
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPhone" bundle:nil];
    }
    AddReportViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"AddReport"];
    viewController.delegate = self;
//    if (self.CustomPopoverController == nil) {
//        self.CustomPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
//    }
    self.selectedVC = viewController;
    viewController.mainVC = self;
    self.CustomPopoverController  = [viewController popoverPresentationController];
    self.CustomPopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    self.CustomPopoverController.sourceView = self.view;
//    self.CustomPopoverController.barButtonItem = self.navigationItem.rightBarButtonItem;
    self.CustomPopoverController.sourceRect = CGRectMake(0, 0, 400, 500);
    self.CustomPopoverController.delegate = self;
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
    
//    self.CustomPopoverController.delegate = self;
//    [self.CustomPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    /* Upload all
    uploadReports = [dataController GetReportsUnsorted];
    reportIndex = 0;
    netController = [[NetworkController alloc] init];
    netController.delegate = self;
    [netController load];
    [netController UploadReportID:[[[uploadReports objectAtIndex:reportIndex] objectAtIndex:0] intValue]];
     */
}

- (void)NetworkControllerErrorTitle:(NSString *)Title Message:(NSString *)Message
{
    NSLog(@"%@: %@", Title, Message);
    [self ContinueUpload];
}

-(void)NetworkControllerReportUploaded
{
    NSLog(@"Uploaded Report: %i", reportIndex);
    [self ContinueUpload];
}

-(void)ContinueUpload
{
    reportIndex++;
    if (reportIndex < uploadReports.count) {
        netController = [[NetworkController alloc] init];
        netController.delegate = self;
        [netController UploadReportID:[[[uploadReports objectAtIndex:reportIndex] objectAtIndex:0] intValue]];
    }
    else {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Upload Complete"
                                                                       message:@"Report(s) have uploaded successfully."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)AddReportPopoverDoneCustomer:(NSString *)Customer Date:(NSString *)Date OtherEmployee:(NSString *)OtherEmployee
{
    
    
    if(self.selectedVC)
    {
        [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
        
    }
//    [self.CustomPopoverController dismissPopoverAnimated:YES];
    self.CustomPopoverController = nil;
    if (Customer != nil && Date != nil && OtherEmployee != nil) {
        
        [dataController AddReportCustomer:Customer Technician:[NSString stringWithFormat:@"%@, %@", self.employee, OtherEmployee] Date:Date];
        reports = [dataController GetReports];
        [self.tableView reloadData];
    }
}

//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
//{
//
//    
////    [self.CustomPopoverController dismissPopoverAnimated:YES];
//    self.CustomPopoverController = nil;
//}
@end
