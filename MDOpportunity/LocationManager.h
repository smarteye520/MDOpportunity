//
//  LocationManager.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-20.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DatabaseController.h"

@protocol LocationManagerDelegate <NSObject>
@optional -(void)LocationManagerFoundLocationLat:(CLLocationDegrees)Lat Long:(CLLocationDegrees)Long Accuracy:(CLLocationAccuracy)Accuracy LSD:(NSString*)LSD;
@optional -(void)LocationManagerUpdatingMagneticHeading:(CLLocationDirection)MagneticHeading TrueHeading:(CLLocationDirection)TrueHeading;
-(void)LocationManagerError:(NSError *)Error;
@end

@interface LocationManager : NSObject
<CLLocationManagerDelegate>
{
    NSTimer *timeout;
    CLLocationManager *locationManager;
    CLLocation *bestLocation;
    bool isFindingLocation;
}

-(void)FindLocation;
-(void)FindHeading;
-(void)StopUpdatingHeading;
- (NSString*)LSDFromLat:(double)Lat Long:(double)Long;

@property (nonatomic, assign) id<LocationManagerDelegate> delegate;

@end
