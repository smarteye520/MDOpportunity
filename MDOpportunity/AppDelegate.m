//
//  AppDelegate.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-19.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
//    [locationManager stopUpdatingLocation];
    
//    if(!self.myLocationManager)
//        self.myLocationManager = [[LocationManager alloc] init];
//    self.myLocationManager.delegate = self;
//    [self.myLocationManager FindHeading];
//    [self.myLocationManager FindLocation];
    
    return YES;
}

//- (void)LocationManagerFoundLocationLat:(CLLocationDegrees)Lat Long:(CLLocationDegrees)Long Accuracy:(CLLocationAccuracy)Accuracy LSD:(NSString *)LSD
//{
//    self.lat = [NSString stringWithFormat:@"%f", Lat];
//    self.lng = [NSString stringWithFormat:@"%f", Long];
//    self.accuracy = [NSString stringWithFormat:@"%.F", Accuracy];
//    self.lsd = LSD;
//}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations API_AVAILABLE(ios(6.0), macos(10.9));
{
    
    self.location = locations[0];
    NSLog(@"%f *****%f", self.location.coordinate.latitude, self.location.coordinate.longitude);
    
    CLLocation *newLocation = [locations lastObject];
   // NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    self.bestLocation = newLocation;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
