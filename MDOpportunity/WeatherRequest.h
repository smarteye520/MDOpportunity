//
//  WeatherRequest.h
//  Shortgrass
//
//  Created by Duong Nguyen Minh on 3/15/19.
//  Copyright © 2019 Shortgrass Ecosystems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WeatherRequestDelegate <NSObject>
@required
-(void)WeatherRequestErrorTitle:(NSString *)Title Message:(NSString *)Message;
-(void)WeatherRequestDidFetchData:(NSArray *)results;
@optional
@end

@interface WeatherRequest : NSObject <NSXMLParserDelegate>
{
    NSURLConnection *conn;
    NSMutableData *webData;
    NSString *soapResults;
    
    NSXMLParser *xmlParser;
    NSString *weatherServiceURL;
    DatabaseController *dataController;
}
@property (nonatomic, assign) id<WeatherRequestDelegate> delegate;
-(void)LoadWeatherWithLatitude:(NSString *)latitude longitude:(NSString *)longitude name:(NSString *)name customer:(NSString *)customer;

@end

NS_ASSUME_NONNULL_END
