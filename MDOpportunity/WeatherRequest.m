//
//  WeatherRequest.m
//  Shortgrass
//
//  Created by Duong Nguyen Minh on 3/15/19.
//  Copyright © 2019 Shortgrass Ecosystems. All rights reserved.
//

#import "WeatherRequest.h"
#import "WeatherInfo.h"
#import "DatabaseController.h"


@implementation WeatherRequest {
    NSMutableArray *results;
    WeatherInfo *item;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        weatherServiceURL = @"http://a3p.ca/SSWeather/S.svc";
    }
    return self;
}

-(void) connection:(NSURLConnection *) connection
  didFailWithError:(NSError *) error
{
    [self.delegate WeatherRequestErrorTitle:@"Error Sending to Server" Message:[NSString stringWithFormat:@"Cannot establish a connection to the server. Please make sure you are connected to the internet. If error persists report error to your administrator: %@", [error description]]];
}

-(void) connection:(NSURLConnection *) connection
didReceiveResponse:(NSURLResponse *) response
{
    [webData setLength: 0];
}

-(void) connection:(NSURLConnection *) connection
    didReceiveData:(NSData *) data
{
    [webData appendData:data];
}


-(void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSString *theXML = [[NSString alloc]
                        initWithBytes: [webData mutableBytes]
                        length:[webData length]
                        encoding:NSUTF8StringEncoding];
    
    NSLog(@"XML weather %@",theXML);
    xmlParser = [[NSXMLParser alloc] initWithData: [theXML dataUsingEncoding:NSUTF8StringEncoding]];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict
{
    if ([elementName isEqualToString:@"GetWeatherResult"])
    {
        results = [NSMutableArray new];
    } else if ([elementName isEqualToString:@"a:Weather"]) {
        item = [WeatherInfo new];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"a:Humidity"]) {
        item.humidity = [soapResults integerValue];
    } else if ([elementName isEqualToString:@"a:Precipitation"]) {
        item.precipitation = [soapResults integerValue];
    } else if ([elementName isEqualToString:@"a:Pressure"]) {
        item.pressure = [soapResults floatValue];
    } else if ([elementName isEqualToString:@"a:Temperature"]) {
        item.temperature = [soapResults integerValue];
    } else if ([elementName isEqualToString:@"a:WeatherDescription"]) {
        item.weatherDescription = soapResults;
    } else if ([elementName isEqualToString:@"a:WeatherID"]) {
        item.weatherID = [soapResults integerValue];
    } else if ([elementName isEqualToString:@"a:WindDirectionDegrees"]) {
        item.windDirectionDegrees = [soapResults floatValue];
    } else if ([elementName isEqualToString:@"a:WindDirectionLetter"]) {
        item.windDirectionLetter = soapResults;
    } else if ([elementName isEqualToString:@"a:WindSpeed"]) {
        item.windSpeed = [soapResults integerValue];
    } else if ([elementName isEqualToString:@"a:Weather"]) {
        [results addObject:item];
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    soapResults = string;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.delegate WeatherRequestDidFetchData:results];
}

-(void)LoadWeatherWithLatitude:(NSString *)latitude longitude:(NSString *)longitude name:(NSString *)name customer:(NSString *)customer
{
    NSMutableString *wcfMessage = [[NSMutableString alloc] init];
    [wcfMessage appendFormat:
     @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<s:Body>"
     "<GetWeather xmlns=\"http://tempuri.org/\">"
     "<latitude>%@</latitude>"
     "<longitude>%@</longitude>"
     "<name>%@</name>"
     "<customer>%@</customer>"
     "</GetWeather>"
     "</s:Body>"
     "</s:Envelope>", latitude, longitude, name, customer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *serviceURL = [defaults stringForKey:@"WEATHERWEBSERVICEURL"];
    if (serviceURL == nil) {
        serviceURL = weatherServiceURL;
    }
    NSURL *url = [NSURL URLWithString:serviceURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
    
    //---set the various headers---
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[wcfMessage length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/IService1/GetWeather" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[wcfMessage dataUsingEncoding:NSUTF8StringEncoding]];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

@end
