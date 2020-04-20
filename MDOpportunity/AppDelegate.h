//
//  AppDelegate.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-19.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, LocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *bestLocation;
@property (strong, nonatomic) CLLocation * location;
@property (strong, nonatomic) LocationManager *myLocationManager;

@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *accuracy;
@property (strong, nonatomic) NSString * lsd;


@end
