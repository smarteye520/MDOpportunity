//
//  MainCell.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-21.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "MainCell.h"

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "WeatherRequest.h"
#import "WeatherInfo.h"


@implementation MainCell 

- (void)Load
{
    
    dataController = [[DatabaseController alloc] init];
    
    [self.CommentsField.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [self.CommentsField.layer setBorderColor: [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1] CGColor]];
    [self.CommentsField.layer setBorderWidth: 1.0];
    [self.CommentsField.layer setCornerRadius:8.0f];
    [self.CommentsField.layer setMasksToBounds:YES];

    dataController = [[DatabaseController alloc] init];
    
    
    self.CustomerField.text = [self.report objectAtIndex:1];
    self.SiteTypeField.text = [self.report objectAtIndex:2];
    self.LSDField.text = [self.report objectAtIndex:3];
    self.LatitudeField.text = [self.report objectAtIndex:4];
    self.LongitudeField.text = [self.report objectAtIndex:5];
    self.AccuracyField.text = [self.report objectAtIndex:6];
    self.DateField.text = [self.report objectAtIndex:7];
    self.TechnicianField.text = [self.report objectAtIndex:8];
    self.PrecipitationField.text = [self.report objectAtIndex:9];
//    self.PrecipitationField.keyboardType = UIKeyboardTypeNumberPad;
    self.TemperatureField.text = [self.report objectAtIndex:10];
    self.RelativeHumidity.text = [self.report objectAtIndex:11];
    self.WindDirectionField.text = [self.report objectAtIndex:12];
    self.WindSpeedField.text = [self.report objectAtIndex:13];
    self.TimeField.text = [self.report objectAtIndex:14];
    self.AreaSprayedField.text = [self.report objectAtIndex:15];
    self.CommentsField.text = [self.report objectAtIndex:16];
        
    self.CommentsField.delegate = self;
}
-(void) showPrecipitationAlert:(UITextField *)_field title:(NSString *) _title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_title
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Do Some action here
                                                     
                                                     UITextField *textfield = alertController.textFields.firstObject;

                                                     if(_field == self.PrecipitationField)
                                                     {
                                                         self.PrecipitationField.text = textfield.text;

                                                     }
                                                     if(_field == self.TemperatureField)
                                                     {
                                                         self.TemperatureField.text = textfield.text;

                                                     }
                                                     if(_field == self.WindSpeedField)
                                                     {
                                                         self.WindSpeedField.text = textfield.text;

                                                     }
                                                     if(_field == self.RelativeHumidity)
                                                     {
                                                         self.RelativeHumidity.text = textfield.text;

                                                     }
                                                     if(_field == self.TimeField)
                                                     {
                                                         self.TimeField.text = textfield.text;
                                                     }
                                                     if(_field == self.LSDField)
                                                     {
                                                         self.LSDField.text = textfield.text;
                                                     }
                                                     
                                                     [self Save];
                                                     
                                                     [textfield resignFirstResponder];
                                                     
                                                 }];
    UIAlertAction* cancel1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        [alertController dismissViewControllerAnimated:YES completion:nil];
                                                    }];
    [alertController addAction:okay];
    [alertController addAction:cancel1];
    
    alertController.view.autoresizesSubviews = YES;
    //    if(textView == nil)
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.text = _field.text;
         if(_field == self.PrecipitationField || _field == self.TemperatureField || _field == self.WindSpeedField || _field == self.RelativeHumidity)
         {
             textField.keyboardType = UIKeyboardTypeNumberPad;
         }
         else if(_field == self.TimeField){
             textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
         }
     }];

    
//    textField = [[UITextField alloc] initWithFrame:CGRectZero];
    
    /*
    textField.translatesAutoresizingMaskIntoConstraints = NO;
//    textField.editable = YES;
//    textField.dataDetectorTypes = UIDataDetectorTypeAll;
    textField.text = @"";
    textField.userInteractionEnabled = YES;
    textField.backgroundColor = [UIColor whiteColor];
//    textField.scrollEnabled = YES;
    
    
    NSLayoutConstraint *leadConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8.0];
    NSLayoutConstraint *trailConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeTop multiplier:1.0 constant:-44.0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:textField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:64.0];
    [alertController.view addSubview:textField];
    [NSLayoutConstraint activateConstraints:@[leadConstraint, trailConstraint, topConstraint, bottomConstraint]];
    */
    
    
    [self.mainVC presentViewController:alertController animated:YES completion:^{
        
    }];

}
-(void) showCommenAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Comment"
                                                                             message:@"\n\n\n\n"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //Do Some action here
                                                     self.CommentsField.text = self->textView.text;
                                                     [self Save];
                                                     
                                                     [self->textView resignFirstResponder];
                                                     
                                                 }];
    UIAlertAction* cancel1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        [alertController dismissViewControllerAnimated:YES completion:nil];
                                                    }];
    [alertController addAction:okay];
    [alertController addAction:cancel1];
    
    alertController.view.autoresizesSubviews = YES;
//    if(textView == nil)
        textView = [[UITextView alloc] initWithFrame:CGRectZero];
    
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.editable = YES;
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    textView.text = @"";
    textView.userInteractionEnabled = YES;
    textView.backgroundColor = [UIColor whiteColor];
    textView.scrollEnabled = YES;
    
    textView.text = self.CommentsField.text;
    
    NSLayoutConstraint *leadConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8.0];
    NSLayoutConstraint *trailConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-64.0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:alertController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:64.0];
    [alertController.view addSubview:textView];
    [NSLayoutConstraint activateConstraints:@[leadConstraint, trailConstraint, topConstraint, bottomConstraint]];
    
    [self.mainVC presentViewController:alertController animated:YES completion:^{
        
    }];


}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        [self showCommenAlert];
        
        return NO;
    }
    return YES;
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    [self Save];
    return YES;
}


- (void)Save
{
    [dataController UpdateReportID:[[self.report objectAtIndex:0] intValue] Customer:self.CustomerField.text Technician:self.TechnicianField.text Data:self.DateField.text SiteType:self.SiteTypeField.text LSD:self.LSDField.text Latitude:self.LatitudeField.text Longitude:self.LongitudeField.text Accuracy:self.AccuracyField.text Precipitation:self.PrecipitationField.text WindDirection:self.WindDirectionField.text Temperature:self.TemperatureField.text WindSpeed:self.WindSpeedField.text rHumidity:self.RelativeHumidity.text Time:self.TimeField.text AreaSprayed:self.AreaSprayedField.text Comments:self.CommentsField.text];
    
//    [dataController UpdateIsSynced:[[self.report objectAtIndex:0] intValue] IsSynced:NO];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard-iPhone" bundle:nil];
    }
    
    if(textField == self.AccuracyField || textField == self.LatitudeField || textField == self.LongitudeField)
    {
        return YES;
    }
    
    if (textField == self.DateField)
    {
        
        DatePopoeverViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"DatePopover"];
        [viewController setDelegate:self];
        viewController.Name = @"Date";
        viewController.textField = self.DateField;
        
        /*
        if (CustomPopoverController == nil) {
            CustomPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
        }
        CustomPopoverController.delegate = self;
        [CustomPopoverController presentPopoverFromRect:textField.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
         */
        self.selectedVC = viewController;
        viewController.modalPresentationStyle = UIModalPresentationPopover;

            CustomPopoverController  = [viewController popoverPresentationController];
            CustomPopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            CustomPopoverController.sourceView = viewController.view;
            CustomPopoverController.sourceRect = textField.frame;
            CustomPopoverController.delegate = self;
            
        [self.mainVC presentViewController:viewController animated:YES completion:nil];

        return NO;
    }
    else if (textField == self.WindDirectionField) {

        OptionsPopoverViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"DirectionPopover"];
        [viewController setDelegate:self];
        viewController.Name = @"Wind Direction";
        viewController.TextField = self.WindDirectionField;
        
        self.selectedVC = viewController;
        viewController.modalPresentationStyle = UIModalPresentationPopover;
        
        CustomPopoverController  = [viewController popoverPresentationController];
        CustomPopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        CustomPopoverController.sourceView = viewController.view;
        CustomPopoverController.sourceRect = textField.frame;
        CustomPopoverController.delegate = self;
        
        [self.mainVC presentViewController:viewController animated:YES completion:nil];
        if (CustomPopoverController == nil) {
//            CustomPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
        }
        CustomPopoverController.delegate = self;
//        [CustomPopoverController presentPopoverFromRect:textField.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        return NO;
    }
    else if (textField == self.AreaSprayedField || textField == self.SiteTypeField) {

        OptionsPopoverViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"OptionsPopover"];
        [viewController setDelegate:self];
        if (textField == self.SiteTypeField) {
            viewController.Name = @"Site Type";
            viewController.TextField = self.SiteTypeField;
        }
        else {
            viewController.Name = @"Area Sprayed";
            viewController.TextField = self.AreaSprayedField;
        }
        
        self.selectedVC = viewController;
        viewController.modalPresentationStyle = UIModalPresentationPopover;
        
        CustomPopoverController  = [viewController popoverPresentationController];
        CustomPopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        CustomPopoverController.sourceView = viewController.view;
        CustomPopoverController.sourceRect = textField.frame;
        CustomPopoverController.delegate = self;
        
        [self.mainVC presentViewController:viewController animated:YES completion:nil];
//        if (CustomPopoverController == nil) {
////            CustomPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
//        }
//        CustomPopoverController.delegate = self;
//        [CustomPopoverController presentPopoverFromRect:textField.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        return NO;
    }
    else if(textField == self.CustomerField){
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
        [viewController setDelegate:self];
        
        self.selectedVC = viewController;
        viewController.modalPresentationStyle = UIModalPresentationPopover;
        CustomPopoverController  = [viewController popoverPresentationController];
        CustomPopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        CustomPopoverController.sourceView = viewController.view;
        CustomPopoverController.sourceRect = textField.frame;
        CustomPopoverController.delegate = self;
        
        [self.mainVC presentViewController:viewController animated:YES completion:nil];
        
        //        if (self.CustomPopoverController == nil) {
        //            self.CustomPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
        //        }
        //        self.CustomPopoverController.delegate = self;
        //        [self.CustomPopoverController presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        return NO;
    }
    
    if(textField == self.PrecipitationField || textField == self.TemperatureField || textField == self.RelativeHumidity || textField == self.WindSpeedField || textField == self.TimeField || textField == self.LSDField)
    {
        if(textField == self.PrecipitationField)
//            self.PrecipitationField.keyboardType = UIKeyboardTypeNumberPad;
            [self showPrecipitationAlert:textField title:@"Precipitation (in mm)"];
        if(textField == self.TemperatureField)
            [self showPrecipitationAlert:textField title:@"Temperature(in 'c)"];
            self.TemperatureField.keyboardType = UIKeyboardTypeNumberPad;
        if(textField == self.RelativeHumidity)
            [self showPrecipitationAlert:textField title:@"Relative Humidity (in %)"];
            self.RelativeHumidity.keyboardType = UIKeyboardTypeNumberPad;
        if(textField == self.WindSpeedField)
            [self showPrecipitationAlert:textField title:@"Wind Speed (in km/h)"];
            self.WindSpeedField.keyboardType = UIKeyboardTypeNumberPad;
        if(textField == self.TimeField)
            [self showPrecipitationAlert:textField title:@"Time (24 Hour)"];
            self.TimeField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        if(textField == self.LSDField)
            [self showPrecipitationAlert:textField title:@"Legal Subdivision(LSD)"];
        
        return NO;
        
    }
    
    
    
    return YES;
}

- (void)DatePopoverDoneDate:(NSString *)date TextField:(UITextField *)textField
{
    textField.text = date;
//    [self GoToNextTextField:textField];
    [self Save];

    [self.selectedVC dismissViewControllerAnimated:YES completion:^{
//        CustomPopoverController = nil;
    }];
    
}

- (void)DatePopoverCancel
{
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
//    [CustomPopoverController dismissPopoverAnimated:YES];
//    CustomPopoverController = nil;
}

-(NSMutableArray *)OptionsPopoverAddObjectsName:(NSString *)name
{
    if ([name isEqual: @"Site Type"]) {
        return [@[@"", @"Private", @"Public"] mutableCopy];
    }
    else if([name isEqual: @"Customer"]){
        return [dataController GetClients];
    }
    else {
        return [@[@"", @"Tear Drop", @"Trail", @"Complete", @"Lease", @"m2", @"Well Head"] mutableCopy];
    }
}

-(void)OptionsPopoverDoneButtonName:(NSString *)name Object:(NSString *)object TextField:(UITextField *)textField
{
    textField.text = object;
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
    CustomPopoverController = nil;
//    [self GoToNextTextField:textField];
    [self Save];
}

-(void)OptionsPopoverCancelButton
{
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
    CustomPopoverController = nil;
}

-(void)DirectionPopoverDoneButtonName:(NSString *)name Object:(NSString *)object TextField:(UITextField *)textField
{
    textField.text = object;
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
    CustomPopoverController = nil;
//    [self GoToNextTextField:textField];
    [self Save];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self GoToNextTextField:textField];
    [self Save];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self Save];
    return YES;
}

- (void)GoToNextTextField:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    [self.selectedVC dismissViewControllerAnimated:YES completion:nil];
    CustomPopoverController = nil;
    UIResponder* nextResponder = [textField.superview.superview.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
}

//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
//{
//    CustomPopoverController = nil;
//}

- (IBAction)GetGPSLocation:(id)sender
{
    if(!locationManager)
        locationManager = [[LocationManager alloc] init];

    AppDelegate * delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//    [delegate.locationManager startUpdatingLocation];

    NSLog(@"%f *****%f", delegate.bestLocation.coordinate.latitude, delegate.bestLocation.coordinate.longitude);

    self.LatitudeField.text = [NSString stringWithFormat:@"%f", delegate.bestLocation.coordinate.latitude];
    self.LongitudeField.text = [NSString stringWithFormat:@"%f", delegate.bestLocation.coordinate.longitude];
    self.AccuracyField.text = [NSString stringWithFormat:@"%.F", delegate.bestLocation.horizontalAccuracy];
    self.LSDField.text = [locationManager LSDFromLat:delegate.bestLocation.coordinate.latitude Long:delegate.bestLocation.coordinate.longitude];
    [self Save];
    WeatherRequest *weatherReq = [WeatherRequest new];
    weatherReq.delegate = self;
    [weatherReq LoadWeatherWithLatitude:self.LatitudeField.text longitude:self.LongitudeField.text name:self.TechnicianField.text customer:self.CustomerField.text];
    [SVProgressHUD showWithStatus:@"Getting Weather" maskType:SVProgressHUDMaskTypeBlack];
//    //https://www.reversegeocoder.com/api/v1/test/latlng/55.417713,-120.130005
//    NSString *string = [NSString stringWithFormat:@"https://www.reversegeocoder.com/api/v1/test/latlng/%f,%f", 55.417713, -120.130005];
//    NSURL *url = [NSURL URLWithString:string];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    // 2
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    [SVProgressHUD showWithStatus:@"Getting LSD" maskType:SVProgressHUDMaskTypeBlack];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        [SVProgressHUD dismiss];
//
//        // 3
//        NSArray * dicArry = (NSArray *)responseObject;
//        NSLog(@"%@", [dicArry description]);
//        NSDictionary * resDic = [dicArry[0] objectForKey:@"response"];
//        NSString * lsd = [resDic objectForKey:@"lsd"];
//        NSLog(@"%@", lsd);
//
//        self.LSDField.text = lsd;
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        [SVProgressHUD dismiss];
//
//        // 4
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving LSD"
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }];
//
//    // 5
//    [operation start];
    
    
    
//    locationManager.delegate = self;
//    [locationManager FindHeading];
//    [locationManager FindLocation];
//    [SVProgressHUD showWithStatus:@"Getting Location" maskType:SVProgressHUDMaskTypeBlack];
}

- (void)WeatherRequestDidFetchData:(NSArray *)results {
    [SVProgressHUD dismiss];
    if (results != nil && results. count > 0) {
        WeatherInfo *info = results[0];
        self.PrecipitationField.text = [NSString stringWithFormat:@"%ld", (long)info.precipitation];
        self.TemperatureField.text = [NSString stringWithFormat:@"%ld", (long)info.temperature];
        self.WindDirectionField.text = info.windDirectionLetter;
        self.WindSpeedField.text = [NSString stringWithFormat:@"%ld", (long)info.windSpeed];
        self.RelativeHumidity.text = [NSString stringWithFormat:@"%ld", (long)info.humidity];
        self.CommentsField.text = [NSString stringWithFormat:@"%@ Barometric pressure at %ld.", info.weatherDescription, (long)info.pressure];
        [self Save];
    }
    
}

- (void)WeatherRequestErrorTitle:(NSString *)Title Message:(NSString *)Message {
    [SVProgressHUD dismiss];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving LSD"
                                                        message:Message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}


//- (NSString*)LSDFromLat:(double)Lat Long:(double)Long
//{
//    DatabaseController *objDB = [[DatabaseController alloc] init];
//    Lat = fabs(Lat);
//    Long = fabs(Long);
//    double ceilingLat = Lat + 1;
//    double floorLong = Long - 1;
//    NSMutableArray *rows = [objDB selectLSDFromLat:Lat Long:Long CeilingLat:ceilingLat FloorLong:floorLong];
//    NSMutableArray *topResult = [rows objectAtIndex:0];
//    NSString *OutQuarter = nil;
//    NSString *OutLSD = nil;
//    [self GetLSDAndQuarterSectionFromCornerLat:[[topResult objectAtIndex:5] doubleValue] CornerLong:[[topResult objectAtIndex:6] doubleValue] PointLat:Lat PointLong:Long OutQuarter:&OutQuarter OutLSD:&OutLSD];
//    return [NSString stringWithFormat:@"(%@) %@-%02d-%03d-%02d W%@", OutQuarter, OutLSD, [[topResult objectAtIndex:4] intValue], [[topResult objectAtIndex:3] intValue], [[topResult objectAtIndex:2] intValue], [topResult objectAtIndex:1]];
//}

//- (void)LocationManagerError:(NSError *)Error
//{
//    [SVProgressHUD dismiss];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:Error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [alert show];
//}
//
//- (void)LocationManagerFoundLocationLat:(CLLocationDegrees)Lat Long:(CLLocationDegrees)Long Accuracy:(CLLocationAccuracy)Accuracy LSD:(NSString *)LSD
//{
//    [SVProgressHUD dismiss];
//    self.LatitudeField.text = [NSString stringWithFormat:@"%f", Lat];
//    self.LongitudeField.text = [NSString stringWithFormat:@"%f", Long];
//    self.AccuracyField.text = [NSString stringWithFormat:@"%.F", Accuracy];
//    self.LSDField.text = LSD;
//    [self Save];
//}


@end
