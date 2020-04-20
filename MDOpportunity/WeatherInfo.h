//
//  WeatherInfo.h
//  Shortgrass
//
//  Created by Duong Nguyen Minh on 3/15/19.
//  Copyright © 2019 Shortgrass Ecosystems. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherInfo : NSObject

@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, assign) NSInteger precipitation;
@property (nonatomic, assign) CGFloat pressure;
@property (nonatomic, assign) NSInteger temperature;
@property (nonatomic, retain) NSString *weatherDescription;
@property (nonatomic, assign) NSInteger weatherID;
@property (nonatomic, assign) CGFloat windDirectionDegrees;
@property (nonatomic, retain) NSString *windDirectionLetter;
@property (nonatomic, assign) NSInteger windSpeed;
@end

NS_ASSUME_NONNULL_END
