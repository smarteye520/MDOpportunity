//
//  NetworkController.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-20.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "NetworkController.h"

@implementation NetworkController

-(id)init {
    self = [super init];
    if (self != nil) {
        standardServiceURL = @"http://a3p.ca/S.svc";
        streamServiceURL = @"http://a3p.ca/SS.svc";
    }
    return self;
}

-(void)UploadReportID:(int)ID
{
    dataController = [[DatabaseController alloc] init];
    NSMutableArray *report = [dataController GetReportFromID:ID];
    NSMutableArray *reportChemicalMixes = [dataController GetReportChemicalMixesReportID:ID];
    NSMutableArray *reportWeeds = [dataController GetReportWeeds:ID];
    pictures = [dataController GetReportPictureReportID:ID];
    
    NSMutableString *wcfMessage = [[NSMutableString alloc] init];
    [wcfMessage appendFormat:
     @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<s:Body>"
     "<SaveReport xmlns=\"http://tempuri.org/\">"
     "<report xmlns:d4p1=\"http://schemas.datacontract.org/2004/07/ShortgrassWebService.Models\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">"
     "<d4p1:Accuracy>%@</d4p1:Accuracy>"
     "<d4p1:AreaSprayed>%@</d4p1:AreaSprayed>"
     "<d4p1:Comments>%@</d4p1:Comments>"
     "<d4p1:Customer>%@</d4p1:Customer>"
     "<d4p1:Date>%@</d4p1:Date>"
     "<d4p1:LSD>%@</d4p1:LSD>"
     "<d4p1:Latitude>%@</d4p1:Latitude>"
     "<d4p1:Longitude>%@</d4p1:Longitude>"
     "<d4p1:OtherWeeds>%@</d4p1:OtherWeeds>"
     "<d4p1:Precipitation>%@</d4p1:Precipitation>"
     "<d4p1:RelativeHumidity>%@</d4p1:RelativeHumidity>"
     "<d4p1:SiteType>%@</d4p1:SiteType>"
     "<d4p1:Technician>%@</d4p1:Technician>"
     "<d4p1:Temperature>%@</d4p1:Temperature>"
     "<d4p1:Time>%@</d4p1:Time>"
     "<d4p1:WindDirection>%@</d4p1:WindDirection>"
     "<d4p1:WindSpeed>%@</d4p1:WindSpeed>"
     "</report>", [report objectAtIndex:6], [report objectAtIndex:15], [self EscapeString:[report objectAtIndex:16]], [self EscapeString:[report objectAtIndex:1]], [report objectAtIndex:7], [report objectAtIndex:3], [report objectAtIndex:4], [report objectAtIndex:5], [report objectAtIndex:17], [report objectAtIndex:9], [report objectAtIndex:11], [report objectAtIndex:2], [report objectAtIndex:8], [report objectAtIndex:10], [report objectAtIndex:14], [report objectAtIndex:12], [report objectAtIndex:13]];
    
    [wcfMessage appendFormat:
     @"<chemicalMixes xmlns:d4p1=\"http://schemas.datacontract.org/2004/07/ShortgrassWebService.Models\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">"];
    
    for (int i = 0; i < reportChemicalMixes.count; i++) {
        NSMutableArray *mix = [reportChemicalMixes objectAtIndex:i];
        [wcfMessage appendFormat:
         @"<d4p1:ReportChemicalMixes>"
         "<d4p1:ApplicationMethod>%@</d4p1:ApplicationMethod>"
         "<d4p1:ChemicalUsed>%@</d4p1:ChemicalUsed>"
         "<d4p1:Concentration>%@</d4p1:Concentration>"
         "<d4p1:Name>%@</d4p1:Name>"
         "<d4p1:Units>%@</d4p1:Units>"
         "<d4p1:VolumeSprayed>%@</d4p1:VolumeSprayed>"
         "</d4p1:ReportChemicalMixes>", [mix objectAtIndex:5], [mix objectAtIndex:7], [mix objectAtIndex:3], [mix objectAtIndex:2], [mix objectAtIndex:4], [mix objectAtIndex:6]];
    }
    
    [wcfMessage appendFormat:
     @"</chemicalMixes>"
     "<weeds xmlns:d4p1=\"http://schemas.datacontract.org/2004/07/ShortgrassWebService.Models\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">"];

    for (int i = 0; i < reportWeeds.count; i++) {
        [wcfMessage appendFormat:
         @"<d4p1:ReportWeeds>"
         "<d4p1:Name>%@</d4p1:Name>"
         "</d4p1:ReportWeeds>", [reportWeeds objectAtIndex:i]];
    }
    
     [wcfMessage appendFormat:
     @"</weeds>"
      "</SaveReport>"
     "</s:Body>"
     "</s:Envelope>"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *serviceURL = [defaults stringForKey:@"WEBSERVICEURL"];
    if (serviceURL == nil) {
        serviceURL = standardServiceURL;
    }
    NSURL *url = [NSURL URLWithString:serviceURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
    
    //---set the various headers---
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[wcfMessage length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/IService1/SaveReport" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[wcfMessage dataUsingEncoding:NSUTF8StringEncoding]];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

-(void)UploadPicturesFromReportID:(NSString *)ReportID
{
    picturesCount = 0;
    for (int i = 0; i < pictures.count; i++) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
        [manager setResponseSerializer:[AFXMLParserResponseSerializer new]];
        NSDictionary *parameters = @{@"ReportID": ReportID};
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *serviceURL = [defaults stringForKey:@"STREAMEDWEBSERVICEURL"];
        if (serviceURL == nil) {
            serviceURL = streamServiceURL;
        }
        [manager POST:[NSString stringWithFormat:@"%@/UploadReportPicture", serviceURL] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:[[pictures objectAtIndex:i] objectAtIndex:1] name:@"ReportPicture" fileName:[NSString stringWithFormat:@"TempPicture%i.jpg", i] mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSXMLParser *parser = (NSXMLParser *)responseObject;
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:YES];
            [parser parse];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.delegate NetworkControllerErrorTitle:@"Error Sending to Server" Message:[NSString stringWithFormat:@"Cannot establish a connection to the server. Please make sure you are connected to the internet. If error persists report error to your administrator: %@", [error description]]];
        }];
    }
}

-(void)UpdateTables
{
    [self LoadEmployees];
}

-(void)LoadEmployees
{
    NSMutableString *wcfMessage = [[NSMutableString alloc] init];
    [wcfMessage appendFormat:
     @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<s:Body>"
     "<GetEmployees xmlns=\"http://tempuri.org/\">"
     "</GetEmployees>"
     "</s:Body>"
     "</s:Envelope>"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *serviceURL = [defaults stringForKey:@"WEBSERVICEURL"];
    if (serviceURL == nil) {
        serviceURL = standardServiceURL;
    }
    NSURL *url = [NSURL URLWithString:serviceURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
    
    //---set the various headers---
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[wcfMessage length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/IService1/GetEmployees" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[wcfMessage dataUsingEncoding:NSUTF8StringEncoding]];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

-(void)LoadClients
{
    NSMutableString *wcfMessage = [[NSMutableString alloc] init];
    [wcfMessage appendFormat:
     @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<s:Body>"
     "<GetClients xmlns=\"http://tempuri.org/\">"
     "</GetClients>"
     "</s:Body>"
     "</s:Envelope>"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *serviceURL = [defaults stringForKey:@"WEBSERVICEURL"];
    if (serviceURL == nil) {
        serviceURL = standardServiceURL;
    }
    NSURL *url = [NSURL URLWithString:serviceURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
    
    //---set the various headers---
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[wcfMessage length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/IService1/GetClients" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[wcfMessage dataUsingEncoding:NSUTF8StringEncoding]];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

-(void)LoadWeeds
{
    NSMutableString *wcfMessage = [[NSMutableString alloc] init];
    [wcfMessage appendFormat:
     @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<s:Body>"
     "<GetWeeds xmlns=\"http://tempuri.org/\">"
     "</GetWeeds>"
     "</s:Body>"
     "</s:Envelope>"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *serviceURL = [defaults stringForKey:@"WEBSERVICEURL"];
    if (serviceURL == nil) {
        serviceURL = standardServiceURL;
    }
    NSURL *url = [NSURL URLWithString:serviceURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
    
    //---set the various headers---
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[wcfMessage length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/IService1/GetWeeds" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[wcfMessage dataUsingEncoding:NSUTF8StringEncoding]];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

-(void)LoadChemicalMixes
{
    NSMutableString *wcfMessage = [[NSMutableString alloc] init];
    [wcfMessage appendFormat:
     @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<s:Body>"
     "<GetChemicalMixes xmlns=\"http://tempuri.org/\">"
     "</GetChemicalMixes>"
     "</s:Body>"
     "</s:Envelope>"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *serviceURL = [defaults stringForKey:@"WEBSERVICEURL"];
    if (serviceURL == nil) {
        serviceURL = standardServiceURL;
    }
    NSURL *url = [NSURL URLWithString:serviceURL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
    
    //---set the various headers---
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[wcfMessage length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/IService1/GetChemicalMixes" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[wcfMessage dataUsingEncoding:NSUTF8StringEncoding]];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
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

-(void) connection:(NSURLConnection *) connection
  didFailWithError:(NSError *) error
{
    [self.delegate NetworkControllerErrorTitle:@"Error Sending to Server" Message:[NSString stringWithFormat:@"Cannot establish a connection to the server. Please make sure you are connected to the internet. If error persists report error to your administrator: %@", [error description]]];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    NSString *theXML = [[NSString alloc]
                        initWithBytes: [webData mutableBytes]
                        length:[webData length]
                        encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@",theXML);
    xmlParser = [[NSXMLParser alloc] initWithData: [theXML dataUsingEncoding:NSUTF8StringEncoding]];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict
{
    if (!soapResults)
    {
        soapResults = [[NSMutableString alloc] init];
    }
    elementFound = YES;
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (elementFound)
    {
        [soapResults appendString: string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"GetEmployeesResult"])
    {
        NSArray *soapResultParts = [soapResults componentsSeparatedByString:@";"];
        if ([[soapResultParts objectAtIndex:0] isEqualToString:@"SUC"]) {
            employees = [[NSMutableArray alloc] init];
            for (int i = 1; i < soapResultParts.count - 1; i++) {
                [employees addObject:[soapResultParts objectAtIndex:i]];
            }
            [self LoadClients];
        }
        else {
            NSString *Exception = [soapResultParts objectAtIndex:1];
            [self.delegate NetworkControllerErrorTitle:@"Error on Server" Message:[NSString stringWithFormat:@"Report error to your administrator: %@", Exception]];
        }
    }
    else if ([elementName isEqualToString:@"GetClientsResult"])
    {
        NSArray *soapResultParts = [soapResults componentsSeparatedByString:@";"];
        if ([[soapResultParts objectAtIndex:0] isEqualToString:@"SUC"]) {
            clients = [[NSMutableArray alloc] init];
            for (int i = 1; i < soapResultParts.count - 1; i++) {
                [clients addObject:[soapResultParts objectAtIndex:i]];
            }
            [self LoadWeeds];
        }
        else {
            NSString *Exception = [soapResultParts objectAtIndex:1];
            [self.delegate NetworkControllerErrorTitle:@"Error on Server" Message:[NSString stringWithFormat:@"Report error to your administrator: %@", Exception]];
        }
    }
    else if ([elementName isEqualToString:@"GetWeedsResult"]) {
        NSArray *soapResultParts = [soapResults componentsSeparatedByString:@";"];
        if ([[soapResultParts objectAtIndex:0] isEqualToString:@"SUC"]) {
            weeds = [[NSMutableArray alloc] init];
            for (int i = 1; i < soapResultParts.count - 1; i++) {
                [weeds addObject:[soapResultParts objectAtIndex:i]];
            }
            [self LoadChemicalMixes];
        }
        else {
            NSString *Exception = [soapResultParts objectAtIndex:1];
            [self.delegate NetworkControllerErrorTitle:@"Error on Server" Message:[NSString stringWithFormat:@"Report error to your administrator: %@", Exception]];
        }
    }
    else if ([elementName isEqualToString:@"GetChemicalMixesResult"]) {
        NSArray *soapResultParts = [soapResults componentsSeparatedByString:@";"];
        if ([[soapResultParts objectAtIndex:0] isEqualToString:@"SUC"]) {
            chemicalMixes = [[NSMutableArray alloc] init];
            for (int i = 1; i < soapResultParts.count - 1; i+=4) {
                NSMutableArray *mix = [[NSMutableArray alloc] init];
                [mix addObject:[soapResultParts objectAtIndex:i]];
                [mix addObject:[soapResultParts objectAtIndex:i + 1]];
                [mix addObject:[soapResultParts objectAtIndex:i + 2]];
                [mix addObject:[soapResultParts objectAtIndex:i + 3]];
                [chemicalMixes addObject:mix];
            }
            [self.delegate NetworkControllerUpdateTablesEmployees:employees Clients:clients Weeds:weeds ChemicalMixes:chemicalMixes];
        }
        else {
            NSString *Exception = [soapResultParts objectAtIndex:1];
            [self.delegate NetworkControllerErrorTitle:@"Error on Server" Message:[NSString stringWithFormat:@"Report error to your administrator: %@", Exception]];
        }
    }
    else if ([elementName isEqualToString:@"SaveReportResult"]) {
        NSArray *soapResultParts = [soapResults componentsSeparatedByString:@";"];
        if ([[soapResultParts objectAtIndex:0] isEqualToString:@"SUC"]) {
            if (pictures.count <= 0) {
                [self.delegate NetworkControllerReportUploaded];
            }
            else {
                [self UploadPicturesFromReportID:[soapResultParts objectAtIndex:1]];
            }
        }
        else {
            NSString *Exception = [soapResultParts objectAtIndex:1];
            [self.delegate NetworkControllerErrorTitle:@"Error on Server" Message:[NSString stringWithFormat:@"Report error to your administrator: %@", Exception]];
        }
    }
    else if ([elementName isEqualToString:@"string"])
    {
        NSArray *ResultParts = [soapResults componentsSeparatedByString:@";"];
        if ([[ResultParts objectAtIndex:0] isEqualToString:@"UploadReportPicture"]) {
            if ([[ResultParts objectAtIndex:1] isEqualToString:@"SUC"]) {
                picturesCount++;
                if (picturesCount >= pictures.count) {
                    [self.delegate NetworkControllerReportUploaded];
                }
            }
            else {
                NSString *Exception = [ResultParts objectAtIndex:2];
                [self.delegate NetworkControllerErrorTitle:@"Error on Server" Message:[NSString stringWithFormat:@"Report error to your administrator: %@", Exception]];
            }
        }
    }
    else if ([elementName isEqualToString:@"faultstring"])
    {
        if ([soapResults rangeOfString:@"No connection could be made because the target machine actively refused it"].location != NSNotFound) {
            [self.delegate NetworkControllerErrorTitle:@"Error Connecting to Report Server" Message:@"The Report Server appears to be offline contact your administrator for more information, or try again later"];
        }
        else {
            [self.delegate NetworkControllerErrorTitle:@"Error on Server" Message:[NSString stringWithFormat:@"Report error to your administrator: %@", soapResults]];
        }
    }
    elementFound = NO;
    [soapResults setString:@""];
    elementFound = FALSE;
}

- (NSString*)EscapeString:(NSString *)Data
{
    NSString *result = [Data stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    result = [result stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    result = [result stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    result = [result stringByReplacingOccurrencesOfString:@">" withString:@"gt;"];
    result = [result stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    return result;
}

@end
