//
//  ReportViewController.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-19.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "ReportViewController.h"


@interface ReportViewController ()

@end

@implementation ReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    dataController = [[DatabaseController alloc] init];
    WeedsList = [dataController GetWeeds];
    Pictures = [dataController GetReportPictureReportID:[[self.report objectAtIndex:0] intValue]];
    ReportWeeds = [dataController GetReportWeeds:[[self.report objectAtIndex:0] intValue]];
    ChemicalMixes = [dataController GetReportChemicalMixesReportID:[[self.report objectAtIndex:0] intValue]];
    
   self.navigationItem.title = [NSString stringWithFormat: @"%@ - %@", [self.report objectAtIndex:1], [self.report objectAtIndex:3]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
//    NSDictionary* info = [aNotification userInfo];
//    CGRect kbRawRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect ownFrame = [self.tableView.window convertRect:self.tableView.frame fromView:self.tableView.superview];
//
//    // Calculate the area that is covered by the keyboard
//    CGRect coveredFrame = CGRectIntersection(ownFrame, kbRawRect);
//
//    coveredFrame = [self.tableView.window convertRect:coveredFrame toView:self.tableView.superview];
//
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, -coveredFrame.size.height, 0.0);
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
//
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return ChemicalMixes.count;
    }
    else if (section == 2) {
        return 1;
    }
    else if (section == 3) {
        return WeedsList.count;
    }
    else if (section == 4) {
        return 1;
    }
    else if (section == 5) {
        return 1;
    }
    else {
        return ceil((double)Pictures.count / 5.0);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    else if (section == 1) {
        return @"Chemical Mix";
    }
    else if (section == 2) {
        return nil;
    }
    else if (section == 3) {
        return @"Weeds";
    }
    else if (section == 4) {
        return nil;
    }
    else if (section == 5) {
        return @"Site Photos";
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //return self.tableView.rowHeight * 11.8;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            return 400;
        else
            return 960;
    }
    else if (indexPath.section == 1) {
        //return self.tableView.rowHeight * 4;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            return 116;
        else
            return 320;
        
    }
    else if (indexPath.section == 2) {
        //return self.tableView.rowHeight;
        return 48;
    }
    else if (indexPath.section == 3) {
        //return self.tableView.rowHeight * 1.2;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            return 45;
        
        return 55;
    }
    else if (indexPath.section == 4) {
        //return self.tableView.rowHeight * 1.4;
        return 64;
    }
    else if (indexPath.section == 5) {
        //return self.tableView.rowHeight;
        return 44;
    }
    else {
        //return self.tableView.rowHeight * 4.5;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            return 199;
        
        return  272;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"MainCell";
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        MainCell *mainCell = (MainCell *)cell;
        mainCell.report = self.report;
        mainCell.mainVC = self;
        [mainCell Load];
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"ChemicalMixCell";
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        ChemicalMixCell *chemMixCell = (ChemicalMixCell *)cell;
        chemMixCell.ChemicalField.text = [[ChemicalMixes objectAtIndex:indexPath.row] objectAtIndex:2];
        chemMixCell.ConcentrationField.text = [[ChemicalMixes objectAtIndex:indexPath.row] objectAtIndex:3];
        chemMixCell.UnitsField.text = [[ChemicalMixes objectAtIndex:indexPath.row] objectAtIndex:4];
        chemMixCell.ApplicationMethod.text = [[ChemicalMixes objectAtIndex:indexPath.row] objectAtIndex:5];
        chemMixCell.VolumeSprayed.text = [[ChemicalMixes objectAtIndex:indexPath.row] objectAtIndex:6];
        chemMixCell.ChemicalUsed.text = [[ChemicalMixes objectAtIndex:indexPath.row] objectAtIndex:7];
        chemMixCell.ChemicalID = [[[ChemicalMixes objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        chemMixCell.ReportID = [[[ChemicalMixes objectAtIndex:indexPath.row] objectAtIndex:1] intValue];
        [chemMixCell Load];
       
        chemMixCell.mainVC = self;
        
        return cell;
    }
    else if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"AddChemicalMixCell";
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        AddChemicalMixCell *addChemMixCell = (AddChemicalMixCell *)cell;
        addChemMixCell.ReportID = [[self.report objectAtIndex:0] intValue];
        addChemMixCell.delegate = self;
        
        addChemMixCell.mainVC = self;
        return cell;
    }
    else if (indexPath.section == 3) {
        static NSString *CellIdentifier = @"WeedsCell";
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        WeedsCell *weedCell = (WeedsCell *)cell;
        weedCell.TextLabel.text = [WeedsList objectAtIndex:indexPath.row];
        weedCell.ReportID = [[self.report objectAtIndex:0] intValue];
        if ([ReportWeeds containsObject:weedCell.TextLabel.text]) {
            weedCell.AnswerControl.selectedSegmentIndex = 0;
        }
        else {
            weedCell.AnswerControl.selectedSegmentIndex = 1;
        }
        weedCell.delegate = self;
        weedCell.mainVC = self;
        
        return cell;
    }
    else if (indexPath.section == 4) {
        static NSString *CellIdentifier = @"OtherWeedsCell";
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        OtherWeedsCell *otherWeedsCell = (OtherWeedsCell *)cell;
        otherWeedsCell.ReportID = [[self.report objectAtIndex:0] intValue];
        otherWeedsCell.OtherWeedsField.text = [self.report objectAtIndex:17];
        if ([otherWeedsCell.OtherWeedsField.text isEqual:@""]) {
            otherWeedsCell.AnswerControl.selectedSegmentIndex = 1;
        }
        else {
            otherWeedsCell.AnswerControl.selectedSegmentIndex = 0;
        }
        
        otherWeedsCell.mainVC =self;
        
        return cell;
    }
    else if (indexPath.section == 5) {
        static NSString *CellIdentifier = @"SiteDetailsCell";
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        SiteDetailsCell *detailCell = (SiteDetailsCell *)cell;
        [detailCell load];
        detailCell.ReportID = [[self.report objectAtIndex:0] intValue];
        detailCell.delegate = self;
        
        detailCell.mainVC = self;
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"PictureCell";
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        SiteDetailsPictureCell *detailCell = (SiteDetailsPictureCell *)cell;
        detailCell.delegate = self;
        detailCell.ReportID = [[self.report objectAtIndex:0] intValue];
        if (Pictures.count <= indexPath.row * 5) {
            detailCell.ImageOne.image = nil;
            detailCell.ImageOneID = -1;
        }
        if (Pictures.count > indexPath.row * 5) {
            detailCell.ImageOne.image = [UIImage imageWithData:(NSData *)([[Pictures objectAtIndex:(indexPath.row * 5)] objectAtIndex:1])];
            detailCell.ImageOneID = [[[Pictures objectAtIndex:(indexPath.row * 5)] objectAtIndex:0] intValue];
        }
        if (Pictures.count <= (indexPath.row * 5) + 1) {
            detailCell.ImageTwo.image = nil;
            detailCell.ImageTwoID = -1;
        }
        if (Pictures.count > (indexPath.row * 5) + 1) {
            detailCell.ImageTwo.image = [UIImage imageWithData:[[Pictures objectAtIndex:(indexPath.row * 5) + 1] objectAtIndex:1]];
            detailCell.ImageTwoID = [[[Pictures objectAtIndex:(indexPath.row * 5) + 1] objectAtIndex:0] intValue];
        }
        if (Pictures.count <= (indexPath.row * 5) + 2) {
            detailCell.ImageThree.image = nil;
            detailCell.ImageThreeID = -1;
        }
        if (Pictures.count > (indexPath.row * 5) + 2) {
            detailCell.ImageThree.image = [UIImage imageWithData:[[Pictures objectAtIndex:(indexPath.row * 5) + 2] objectAtIndex:1]];
            detailCell.ImageThreeID = [[[Pictures objectAtIndex:(indexPath.row * 5) + 2] objectAtIndex:0] intValue];
        }
        if (Pictures.count <= (indexPath.row * 5) + 3) {
            detailCell.ImageFour.image = nil;
            detailCell.ImageFourID = -1;
        }
        if (Pictures.count > (indexPath.row * 5) + 3) {
            detailCell.ImageFour.image = [UIImage imageWithData:[[Pictures objectAtIndex:(indexPath.row * 5) + 3] objectAtIndex:1]];
            detailCell.ImageFourID = [[[Pictures objectAtIndex:(indexPath.row * 5) + 3] objectAtIndex:0] intValue];
        }
        if (Pictures.count <= (indexPath.row * 5) + 4) {
            detailCell.ImageFive.image = nil;
            detailCell.ImageFiveID = -1;
        }
        if (Pictures.count > (indexPath.row * 5) + 4) {
            detailCell.ImageFive.image = [UIImage imageWithData:[[Pictures objectAtIndex:(indexPath.row * 5) + 4] objectAtIndex:1]];
            detailCell.ImageFiveID = [[[Pictures objectAtIndex:(indexPath.row * 5) + 4] objectAtIndex:0] intValue];
        }
        [detailCell load];
        
        detailCell.mainVC = self;
        
        return cell;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    else {
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

        int chemicalID = [[[ChemicalMixes objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        [dataController RemoveReportChemicalMixID:chemicalID];
        ChemicalMixes = [dataController GetReportChemicalMixesReportID:[[self.report objectAtIndex:0] intValue]];
        [self.tableView reloadData];
        
    }
}

- (void)ChemicalMixAdded
{
    self.report = [dataController GetReportFromID:[[self.report objectAtIndex:0] intValue]];
    ChemicalMixes = [dataController GetReportChemicalMixesReportID:[[self.report objectAtIndex:0] intValue]];
    Pictures = [dataController GetReportPictureReportID:[[self.report objectAtIndex:0] intValue]];
    ReportWeeds = [dataController GetReportWeeds:[[self.report objectAtIndex:0] intValue]];
    [self.tableView reloadData];
}

- (void)UpdateReportedWeeds
{
    self.report = [dataController GetReportFromID:[[self.report objectAtIndex:0] intValue]];
    NSMutableArray *updateWeedsList = [[NSMutableArray alloc] init];
    for (int i = 0; i < WeedsList.count; i++) {
        WeedsCell *cell = (WeedsCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:3]];
        if (cell.AnswerControl.selectedSegmentIndex == 0) {
            [updateWeedsList addObject:cell.TextLabel.text];
        }
    }
    [dataController UpdateReportWeedsReport:[[self.report objectAtIndex:0] intValue] Weeds:updateWeedsList];
    ChemicalMixes = [dataController GetReportChemicalMixesReportID:[[self.report objectAtIndex:0] intValue]];
    ReportWeeds = [dataController GetReportWeeds:[[self.report objectAtIndex:0] intValue]];
    Pictures = [dataController GetReportPictureReportID:[[self.report objectAtIndex:0] intValue]];
    [self.tableView reloadData];
}

- (void)PictureAdded
{
    if([self.report count] > 0){
        self.report = [dataController GetReportFromID:[[self.report objectAtIndex:0] intValue]];
        Pictures = [dataController GetReportPictureReportID:[[self.report objectAtIndex:0] intValue]];
        ChemicalMixes = [dataController GetReportChemicalMixesReportID:[[self.report objectAtIndex:0] intValue]];
        ReportWeeds = [dataController GetReportWeeds:[[self.report objectAtIndex:0] intValue]];
    }
    [self.tableView reloadData];
}

-(void)PictureEdited
{
    if([self.report count] > 0){
        self.report = [dataController GetReportFromID:[[self.report objectAtIndex:0] intValue]];
        Pictures = [dataController GetReportPictureReportID:[[self.report objectAtIndex:0] intValue]];
        ChemicalMixes = [dataController GetReportChemicalMixesReportID:[[self.report objectAtIndex:0] intValue]];
        ReportWeeds = [dataController GetReportWeeds:[[self.report objectAtIndex:0] intValue]];
    }
    
    [self.tableView reloadData];

}

- (IBAction)UploadReport:(id)sender
{
    if([self.report count] > 0){

        
        NSLog(@"%@", [[self.report objectAtIndex:0] description]);
//        [dataController UpdateIsSynced:[[self.report objectAtIndex:0] intValue] IsSynced:YES];

        
        netController = [[NetworkController alloc] init];
        netController.delegate = self;
        [netController UploadReportID:[[self.report objectAtIndex:0] intValue]];
        
        /*
        [dataController UpdateReportID:[[self.report objectAtIndex:0] intValue] Customer:<#(NSString *)#> Technician:<#(NSString *)#> Data:<#(NSString *)#> SiteType:<#(NSString *)#> LSD:<#(NSString *)#> Latitude:<#(NSString *)#> Longitude:<#(NSString *)#> Accuracy:<#(NSString *)#> Precipitation:<#(NSString *)#> WindDirection:<#(NSString *)#> Temperature:<#(NSString *)#> WindSpeed:<#(NSString *)#> rHumidity:<#(NSString *)#> Time:<#(NSString *)#> AreaSprayed:<#(NSString *)#> Comments:(NSString *)]
        */
        [SVProgressHUD showWithStatus:@"Communicating with Server" maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (void)NetworkControllerReportUploaded
{
    [SVProgressHUD dismiss];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Upload Complete"
                                                                   message:@"Report has been uploaded successfully."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [dataController UpdateIsSynced:[[self.report objectAtIndex:0] intValue] IsSynced:YES];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              [dataController UpdateIsSynced:[[self.report objectAtIndex:0] intValue] IsSynced:YES];

                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:^{
       
    }];
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
