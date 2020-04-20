//
//  DatabaseController.h
//  ShortGrass
//
//  Created by XAGON on 2013-04-19.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseController : NSObject
{
    sqlite3 *database;
    NSString *dbPath;
    BOOL dbSuccess;
    NSObject *databaseLock;
}

-(void)UpdateEmployees:(NSMutableArray *)Employees;
-(void)UpdateClients:(NSMutableArray *)Clients;
-(void)UpdateWeeds:(NSMutableArray *)Weeds;
-(void)UpdateChemicalMixes:(NSMutableArray *)ChemicalMixes;

-(NSMutableArray *)GetEmployees;
-(NSMutableArray *)GetReports;
-(NSMutableArray *)GetReportsUnsorted;
-(NSMutableArray *)GetReportFromID:(int)ID;
-(void)RemoveReport:(int)ID;
-(void)AddReportCustomer:(NSString *)customer Technician:(NSString *)technician Date:(NSString *)date;
-(void)UpdateReportID:(int)ID Customer:(NSString *)customer Technician:(NSString *)technician Data:(NSString *)date SiteType:(NSString *)siteType LSD:(NSString *)lsd Latitude:(NSString *)latitude Longitude:(NSString *)longitude Accuracy:(NSString *)accuracy Precipitation:(NSString *)precipitation WindDirection:(NSString *)windDirection Temperature:(NSString *)temperature WindSpeed:(NSString *)windSpeed rHumidity:(NSString *)rHumidity Time:(NSString*)time AreaSprayed:(NSString *)AreaSprayed Comments:(NSString *)comments;
-(void)UpdateReportID:(int)ID OtherWeeds:(NSString *)OtherWeeds;
-(NSMutableArray *)GetWeeds;
-(NSMutableArray *)GetClients;

-(void)AddReportChemicalMixReportID:(int)reportID;
-(NSMutableArray *)GetReportChemicalMixesReportID:(int)reportID;
-(void)UpdateReportChemicalMixID:(int)ID Chemical:(NSString *)chemical Concentration:(NSString *)concentration Units:(NSString *)units ApplicationMethod:(NSString *)applicationMethod VolumeSprayed:(NSString *)volumeSprayed ChemicalUsed:(NSString *)chemicalUsed;
-(void)RemoveReportChemicalMixID:(int)ID;
-(NSMutableArray *)GetChemicals;
-(NSMutableArray *)GetChemicalMixFromChemical:(NSString *)chemical ApplicationMethod:(NSString *)ApplicationMethod;

-(NSMutableArray *)GetReportWeeds:(int)ID;
-(void)UpdateReportWeedsReport:(int)ID Weeds:(NSMutableArray *)Weeds;
-(void)RemoveAllReports;
-(void)AddReportPictureReportID:(int)ReportID Image:(UIImage*)image;
-(NSMutableArray *)GetReportPictureReportID:(int)ReportID;
-(void)DeleteReportPictureID:(int)ID;
-(void)UpdateReportPictureID:(int)ID Image:(UIImage*)image;

-(NSMutableArray *)selectLSDFromLat:(double)Lat Long:(double)Long CeilingLat:(double)CeilingLat FloorLong:(double)FloorLong;

-(BOOL)IsReportSynced:(int)ReportID;
-(void)UpdateIsSynced:(int)ReportID IsSynced:(BOOL)IsSynced;

@end
