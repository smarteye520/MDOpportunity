//
//  NetworkController.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-20.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLResponseSerialization.h"

@protocol NetworkControllerDelegate <NSObject>
@required
-(void)NetworkControllerErrorTitle:(NSString *)Title Message:(NSString *)Message;
@optional
-(void)NetworkControllerReportUploaded;
-(void)NetworkControllerUpdateTablesEmployees:(NSMutableArray*)Employees Clients:(NSMutableArray *)Clients Weeds:(NSMutableArray *)Weeds ChemicalMixes:(NSMutableArray*)ChemicalMixes;
@end

@interface NetworkController : NSObject <NSXMLParserDelegate>
{
    DatabaseController *dataController;
    NSURLConnection *conn;
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSXMLParser *xmlParser;
    BOOL elementFound;
    
    NSMutableArray *employees;
    NSMutableArray *clients;
    NSMutableArray *weeds;
    NSMutableArray *chemicalMixes;
    NSMutableArray *pictures;
    int picturesCount;
    
    NSString *standardServiceURL;
    NSString *streamServiceURL;
}
@property (nonatomic, assign) id<NetworkControllerDelegate> delegate;
-(void)UploadReportID:(int)ID;
-(void)UpdateTables;

@end
