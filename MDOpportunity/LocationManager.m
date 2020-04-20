//
//  LocationManager.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-20.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "LocationManager.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation LocationManager

- (id)init
{
    self = [super init];
    if (self != nil) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager requestAlwaysAuthorization];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        timeout = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(Timeout) userInfo:nil repeats:NO];
    }
    return self;
}

- (void)FindLocation
{
    if([self isGPSEnabled]) {
        [locationManager startUpdatingLocation];
    }
    else {
        UIAlertController *_alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Location services need to be enabled for this application. (x09)"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [_alert addAction:defaultAction];
        [_alert presentViewController:_alert animated:YES completion:nil];
    }
}

- (void)FindHeading
{
    [locationManager requestWhenInUseAuthorization];
    if ([self isGPSEnabled]) {
        [locationManager startUpdatingHeading];
    }
    else {
        UIAlertController *_alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:@"Location services need to be enabled for this application. (x09)"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [_alert addAction:defaultAction];
        [_alert presentViewController:_alert animated:YES completion:nil];
    }
}

- (void)StopUpdatingHeading
{
    [locationManager stopUpdatingHeading];
}

- (BOOL)isGPSEnabled
{

    if (! ([CLLocationManager locationServicesEnabled])
        || ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))
    {
        return NO;
    }
    return YES;
}

- (void)Timeout
{
    if (bestLocation != nil) {
        [locationManager stopUpdatingLocation];
        NSString *lsd = [self LSDFromLat:bestLocation.coordinate.latitude Long:bestLocation.coordinate.longitude];
        if (self.delegate != nil) {
            [self.delegate LocationManagerFoundLocationLat:bestLocation.coordinate.latitude Long:bestLocation.coordinate.longitude Accuracy:bestLocation.horizontalAccuracy LSD:lsd];
        }
    }
    else {
        NSMutableDictionary *details = [NSMutableDictionary dictionary];
        [details setValue:@"Could not obtain a GPS location at your current position. Make sure that Maps is able to find your location. If Maps was able to find your location try this option again. Otherwise report this problem to the Administrator" forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"world" code:200 userInfo:details];
        [self.delegate LocationManagerError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge <= 5.0 && newLocation.horizontalAccuracy >= 0) {
        if (bestLocation == nil || bestLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
            bestLocation = newLocation;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
    [self.delegate LocationManagerError:error];
}

- (NSString*)LSDFromLat:(double)Lat Long:(double)Long
{
    DatabaseController *objDB = [[DatabaseController alloc] init];
    Lat = fabs(Lat);
    Long = fabs(Long);
//    Lat = fabs(37.279518);
//    Long = fabs(-121.867905);
    
    
    double ceilingLat = Lat + 1;
    double floorLong = Long - 1;
    
    ////
    NSString *OutQuarter = nil;
    NSString *OutLSD = nil;
    NSMutableArray *rows = [objDB selectLSDFromLat:Lat Long:Long CeilingLat:ceilingLat FloorLong:floorLong];

    if(rows.count == 0)
    {
        return @"";
    }
    
    NSMutableArray *topResult = [rows objectAtIndex:0];

    
    [self GetLSDAndQuarterSectionFromCornerLat:[[topResult objectAtIndex:5] doubleValue] CornerLong:[[topResult objectAtIndex:6] doubleValue] PointLat:Lat PointLong:Long OutQuarter:&OutQuarter OutLSD:&OutLSD];
    return [NSString stringWithFormat:@"(%@) %@-%02d-%03d-%02d W%@", OutQuarter, OutLSD, [[topResult objectAtIndex:4] intValue], [[topResult objectAtIndex:3] intValue], [[topResult objectAtIndex:2] intValue], [topResult objectAtIndex:1]];
    
}

-(void)GetLSDAndQuarterSectionFromCornerLat:(double)CornerLat CornerLong:(double)CornerLong PointLat:(double)PointLat PointLong:(double)PointLong OutQuarter:(NSString**)OutQuarter OutLSD:(NSString**)OutLSD
{
    *OutQuarter = @"";
    *OutLSD = @"";
    //approximated based on 1.6 km squared sections
    //1 degree of latitude is approximately 111.2 km
    //1 degree of longitude is equal to 111.321 * cos(lat)
    double yDist = (CornerLat - PointLat) * 111.2;
    double xDist = (PointLong - CornerLong) * 111.321 * cos(((PointLat + CornerLat) / 2) * M_PI / 180);
    
    int yLsd = (int)floor((yDist * 4.0) / 1.6) + 1;
    if (yLsd > 4)
    {
        yLsd = 4;
    }
    yLsd = 5 - yLsd;
    int xLsd = (int)floor((xDist * 4.0) / 1.6) + 1;
    if (xLsd > 4)
    {
        xLsd = 4;
    }
    if (yLsd % 2 != 0)
    {
        *OutLSD = [NSString stringWithFormat:@"%i", (yLsd * 4) - (4 - xLsd)];
    }
    else
    {
        *OutLSD = [NSString stringWithFormat:@"%i", (yLsd * 4) - (xLsd - 1)];
    }
    if ([*OutLSD isEqual: @"1"] || [*OutLSD isEqual: @"2"] || [*OutLSD isEqual: @"7"] || [*OutLSD isEqual: @"8"])
    {
        *OutQuarter = @"SE";
    }
    else if ([*OutLSD isEqual: @"3"] || [*OutLSD isEqual: @"4"] || [*OutLSD isEqual: @"5"] || [*OutLSD isEqual: @"6"])
    {
        *OutQuarter = @"SW";
    }
    else if ([*OutLSD isEqual: @"11"] || [*OutLSD isEqual: @"12"] || [*OutLSD isEqual: @"13"] || [*OutLSD isEqual: @"14"])
    {
        *OutQuarter = @"NW";
    }
    else
    {
        *OutQuarter = @"NE";
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    [self.delegate LocationManagerUpdatingMagneticHeading:newHeading.magneticHeading TrueHeading:newHeading.trueHeading];
}

@end
