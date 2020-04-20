//
//  DatabaseController.m
//  ShortGrass
//
//  Created by XAGON on 2013-04-19.
//  Copyright (c) 2013 Shortgrass. All rights reserved.
//

#import "DatabaseController.h"

@implementation DatabaseController

- (id)init
{
    self = [super init];
    if (self != nil) {
        databaseLock = [[NSObject alloc] init];
    }
    return self;
}

- (void)createEditableCopyOfDatabaseIfNeeded
{
    // First, test for existence.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"ShortGrassDB.sqlite"];
    dbPath=writableDBPath;
    dbSuccess = [fileManager fileExistsAtPath:writableDBPath];
    if (dbSuccess)
    {
        return;
    }
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ShortGrassDB.sqlite"];
    dbSuccess = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!dbSuccess) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

-(void)Query:(NSString *)query Parameters:(NSMutableArray *)parameters
{
    @synchronized(databaseLock)
    {
        // The database is stored in the application bundle.
        [self createEditableCopyOfDatabaseIfNeeded];
        
        // Open the database. The database was prepared outside the application.
        if ((sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) && (dbSuccess ==TRUE) )
        {
            const char *sql = [query UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
            {
                [self AttachParameters:parameters ToStatement:statement];
                sqlite3_step(statement);
            }
            else
            {
                NSLog(@"Database error: %s", sqlite3_errmsg(database));
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
        else
        {
            sqlite3_close(database);
            NSLog(@"%s", sqlite3_errmsg(database));
            NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        }
    }
}

-(NSMutableArray *)QueryArray:(NSString *)query Parameters:(NSMutableArray *)parameters
{
    @synchronized(databaseLock)
    {
        NSMutableArray *arrResult = [[NSMutableArray alloc] init];
        
        // The database is stored in the application bundle.
        [self createEditableCopyOfDatabaseIfNeeded];
        // Open the database. The database was prepared outside the application.
        if ((sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) && (dbSuccess ==TRUE) )
        {
            const char *sql = [query UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
            {
                [self AttachParameters:parameters ToStatement:statement];
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    //sqlite3_column_count(statement);
                    // The second parameter indicates the column index into the result set.
                    for (int i = 0; i < sqlite3_column_count(statement); i++)
                    {
                        @try {
                            NSString *name;
                            if (sqlite3_column_text(statement, i) != NULL)
                            {
                                name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                            }
                            else
                            {
                                name = @"";
                            }
                            [arrResult addObject:name];
                        }
                        @catch (NSException *exception) {
                            NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, i) length:sqlite3_column_bytes(statement, i)];
                            [arrResult addObject:data];
                        }
                        //NSLog(@"name %@",name);
                    }
                }
            }
            else
            {
                NSLog(@"Database error: %s", sqlite3_errmsg(database));
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
        else
        {
            sqlite3_close(database);
            NSLog(@"%s", sqlite3_errmsg(database));
            NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        }
        return arrResult;
    }
}

-(NSMutableArray *)Query2dArray:(NSString *)query Parameters:(NSMutableArray *)parameters
{
    @synchronized(databaseLock)
    {
        NSMutableArray *arrResult = [[NSMutableArray alloc] init];
        // The database is stored in the application bundle.
        [self createEditableCopyOfDatabaseIfNeeded];
        // Open the database. The database was prepared outside the application.
        if ((sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) && (dbSuccess ==TRUE) )
        {
            const char *sql = [query UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
            {
                [self AttachParameters:parameters ToStatement:statement];
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    //sqlite3_column_count(statement);
                    // The second parameter indicates the column index into the result set.
                    NSMutableArray *row = [[NSMutableArray alloc] init];
                    for (int i = 0; i < sqlite3_column_count(statement); i++)
                    {
                        @try {
                            NSString *name;
                            if (sqlite3_column_text(statement, i) != NULL)
                            {
                                name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                            }
                            else
                            {
                                name = @"";
                            }
                            [row addObject:name];
                        }
                        @catch (NSException *exception) {
                            NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, i) length:sqlite3_column_bytes(statement, i)];
                            [row addObject:data];
                        }
                    }
                    [arrResult addObject:row];
                }
            }
            else
            {
                NSLog(@"Database error: %s", sqlite3_errmsg(database));
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
        else
        {
            sqlite3_close(database);
            NSLog(@"%s", sqlite3_errmsg(database));
            NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        }
        return arrResult;
    }
}

-(int)QueryLastInsertIndex:(NSString *)query Parameters:(NSMutableArray *)parameters
{
    @synchronized(databaseLock)
    {
        int insertIndex = -1;
        // The database is stored in the application bundle.
        [self createEditableCopyOfDatabaseIfNeeded];
        // Open the database. The database was prepared outside the application.
        if ((sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) && (dbSuccess ==TRUE) )
        {
            const char *sql = [query UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
            {
                [self AttachParameters:parameters ToStatement:statement];
                sqlite3_step(statement);
                NSInteger index = sqlite3_last_insert_rowid(database);
                insertIndex = (int)index;
            }
            else
            {
                NSLog(@"Database error: %s", sqlite3_errmsg(database));
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
        else
        {
            sqlite3_close(database);
            NSLog(@"%s", sqlite3_errmsg(database));
            NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        }
        return insertIndex;
    }
}

-(void)AttachParameters:(NSMutableArray *)parameters ToStatement:(sqlite3_stmt *)statement
{
    for (int i = 0; i < parameters.count; i++)
    {
        id parameter = [parameters objectAtIndex:i];
        if ([parameter isKindOfClass:[NSString class]]) {
            NSString *parameterString = (NSString *)parameter;
            if (sqlite3_bind_text(statement, i + 1, [parameterString UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK) {
                NSLog(@"Binding Parameter error: %s", sqlite3_errmsg(database));
            }
        }
        else if ([parameter isKindOfClass:[NSData class]]) {
            NSData *parameterData = (NSData *)parameter;
            if (sqlite3_bind_blob(statement, i + 1, [parameterData bytes], (int)[parameterData length], NULL) != SQLITE_OK) {
                NSLog(@"Binding Parameter error: %s", sqlite3_errmsg(database));
            }
        }
        else {
            int parameterInt = [(NSNumber *)parameter intValue];
            if (sqlite3_bind_int(statement, i + 1, parameterInt) != SQLITE_OK) {
                NSLog(@"Binding Parameter error: %s", sqlite3_errmsg(database));
            }
        }
    }
}

-(void)UpdateEmployees:(NSMutableArray *)Employees
{
    NSString *query = @"DELETE FROM Employees";
    [self Query:query Parameters:[[NSMutableArray alloc] init]];
    if (Employees.count > 0) {
        query = @"INSERT INTO Employees (Name) SELECT ? AS Name";
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        [parameters addObject:[Employees objectAtIndex:0]];
        for (int i = 1; i < Employees.count; i++) {
            query = [query stringByAppendingString:@" UNION SELECT ?"];
            [parameters addObject:[Employees objectAtIndex:i]];
        }
        [self Query:query Parameters:parameters];
    }
}

-(void)UpdateClients:(NSMutableArray *)Clients
{
    NSString *query = @"DELETE FROM Clients";
    [self Query:query Parameters:[[NSMutableArray alloc] init]];
    if (Clients.count > 0) {
        query = @"INSERT INTO Clients (Name) SELECT ? AS Name";
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        [parameters addObject:[Clients objectAtIndex:0]];
        for (int i = 1; i < Clients.count; i++) {
            query = [query stringByAppendingString:@" UNION SELECT ?"];
            [parameters addObject:[Clients objectAtIndex:i]];
        }
        [self Query:query Parameters:parameters];
    }
}

-(void)UpdateWeeds:(NSMutableArray *)Weeds
{
    NSString *query = @"DELETE FROM Weeds";
    [self Query:query Parameters:[[NSMutableArray alloc] init]];
    if (Weeds.count > 0) {
        query = @"INSERT INTO Weeds (Name) SELECT ? AS Name";
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        [parameters addObject:[Weeds objectAtIndex:0]];
        for (int i = 1; i < Weeds.count; i++) {
            query = [query stringByAppendingString:@" UNION SELECT ?"];
            [parameters addObject:[Weeds objectAtIndex:i]];
        }
        [self Query:query Parameters:parameters];
    }
}

-(void)UpdateChemicalMixes:(NSMutableArray *)ChemicalMixes
{
    NSString *query = @"DELETE FROM ChemicalMixes";
    [self Query:query Parameters:[[NSMutableArray alloc] init]];
    if (ChemicalMixes.count > 0) {
        query = @"INSERT INTO ChemicalMixes (Name, Concentration, Units, ApplicationMethod) SELECT ? AS Name, ? AS Concentration, ? AS Units, ? AS ApplicationMethod";
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        [parameters addObject:[[ChemicalMixes objectAtIndex:0] objectAtIndex:0]];
        [parameters addObject:[[ChemicalMixes objectAtIndex:0] objectAtIndex:1]];
        [parameters addObject:[[ChemicalMixes objectAtIndex:0] objectAtIndex:2]];
        [parameters addObject:[[ChemicalMixes objectAtIndex:0] objectAtIndex:3]];
        for (int i = 1; i < ChemicalMixes.count; i++) {
            query = [query stringByAppendingString:@" UNION SELECT ?, ?, ?, ?"];
            [parameters addObject:[[ChemicalMixes objectAtIndex:i] objectAtIndex:0]];
            [parameters addObject:[[ChemicalMixes objectAtIndex:i] objectAtIndex:1]];
            [parameters addObject:[[ChemicalMixes objectAtIndex:i] objectAtIndex:2]];
            [parameters addObject:[[ChemicalMixes objectAtIndex:i] objectAtIndex:3]];
        }
        [self Query:query Parameters:parameters];
    }
}

-(NSMutableArray*)GetEmployees
{
    NSString *query = @"SELECT name FROM Employees";
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:@""];
    [result addObjectsFromArray:[self QueryArray:query Parameters:[[NSMutableArray alloc] init]]];
    return result;
}

-(NSMutableArray *)GetReports
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT DISTINCT Date FROM Report";
    NSMutableArray *dates = [self QueryArray:query Parameters:[[NSMutableArray alloc] init]];
    NSArray *sortedDates = [[NSArray alloc] initWithArray:dates];
    sortedDates = [sortedDates sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = (NSString *)a;
        NSString *second = (NSString *)b;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *firstDate = [dateFormatter dateFromString:first];
        NSDate *secondDate = [dateFormatter dateFromString:second];
        return [secondDate compare:firstDate];
    }];
    for (int i = 0; i < sortedDates.count; i++) {
        query = @"SELECT * FROM Report WHERE Date = ?";
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        [parameters addObject:[sortedDates objectAtIndex:i]];
        [result addObject:[self Query2dArray:query Parameters:parameters]];
    }
    return result;
}

-(NSMutableArray*)GetReportsUnsorted
{
    NSString *query = @"SELECT * FROM Report";
    return [self Query2dArray:query Parameters:[[NSMutableArray alloc] init]];
}

-(NSMutableArray *)GetReportFromID:(int)ID
{
    NSString *query = @"SELECT * FROM Report WHERE ID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:ID]];
    return [self QueryArray:query Parameters:parameters];
}

-(void) RemoveAllReports
{
    NSString *query = @"DELETE FROM Report";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [self Query:query Parameters:parameters];
    
    query = @"DELETE FROM ReportChemicalMixes";
    [self Query:query Parameters:parameters];
    
    query = @"DELETE FROM ReportWeeds";
    [self Query:query Parameters:parameters];
    
    query = @"DELETE FROM ReportPictures";
    [self Query:query Parameters:parameters];
    
    query = @"DELETE FROM IsSynced";
    [self Query:query Parameters:parameters];

}

-(void)RemoveReport:(int)ID
{
    NSString *query = @"DELETE FROM Report WHERE ID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:ID]];
    [self Query:query Parameters:parameters];
    
    query = @"DELETE FROM ReportChemicalMixes WHERE ReportID = ?";
    [self Query:query Parameters:parameters];
    
    query = @"DELETE FROM ReportWeeds WHERE ReportID = ?";
    [self Query:query Parameters:parameters];
    
    query = @"DELETE FROM ReportPictures WHERE ReportID = ?";
    [self Query:query Parameters:parameters];
}

-(void)AddReportCustomer:(NSString *)customer Technician:(NSString *)technician Date:(NSString *)date
{
    NSString *query = @"INSERT INTO Report (Customer, Technician, Date) VALUES (?, ?, ?)";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:customer];
    [parameters addObject:technician];
    [parameters addObject:date];
    int reportID = [self QueryLastInsertIndex:query Parameters:parameters];
    [self InsertIsSynced:reportID];
}

-(void)UpdateReportID:(int)ID Customer:(NSString *)customer Technician:(NSString *)technician Data:(NSString *)date SiteType:(NSString *)siteType LSD:(NSString *)lsd Latitude:(NSString *)latitude Longitude:(NSString *)longitude Accuracy:(NSString *)accuracy Precipitation:(NSString *)precipitation WindDirection:(NSString *)windDirection Temperature:(NSString *)temperature WindSpeed:(NSString *)windSpeed rHumidity:(NSString *)rHumidity Time:(NSString *)time AreaSprayed:(NSString *)AreaSprayed Comments:(NSString *)comments
{
    NSString *query = @"UPDATE Report SET Customer = ?, SiteType = ?, LSD = ?, Latitude = ?, Longitude = ?, Accuracy = ?, Date = ?, Technician = ?, Precipitation = ?, Temperature = ?, RHumidity = ?, WindDirection = ?, WindSpeed = ?, Time = ?, AreaSprayed = ?, Comments = ? WHERE ID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:customer];
    [parameters addObject:siteType];
    [parameters addObject:lsd];
    [parameters addObject:latitude];
    [parameters addObject:longitude];
    [parameters addObject:accuracy];
    [parameters addObject:date];
    [parameters addObject:technician];
    [parameters addObject:precipitation];
    [parameters addObject:temperature];
    [parameters addObject:rHumidity];
    [parameters addObject:windDirection];
    [parameters addObject:windSpeed];
    [parameters addObject:time];
    [parameters addObject:AreaSprayed];
    [parameters addObject:comments];
    [parameters addObject:[NSNumber numberWithInt:ID]];
    [self Query:query Parameters:parameters];
//    [self UpdateIsSynced:ID IsSynced:NO];
}

-(void)UpdateReportID:(int)ID OtherWeeds:(NSString *)OtherWeeds
{
    NSString *query = @"UPDATE Report SET OtherWeeds = ? WHERE ID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:OtherWeeds];
    [parameters addObject:[NSNumber numberWithInt:ID]];
    [self Query:query Parameters:parameters];
//    [self UpdateIsSynced:ID IsSynced:NO];
}

-(NSMutableArray *)GetWeeds
{
    NSString *query = @"SELECT Name FROM Weeds";
    return [self QueryArray:query Parameters:[[NSMutableArray alloc] init]];
}

-(NSMutableArray *)GetClients
{
    NSString *query = @"SELECT Name From Clients";
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:@""];
    [result addObjectsFromArray:[self QueryArray:query Parameters:[[NSMutableArray alloc] init]]];
    return result;
}

-(void)AddReportChemicalMixReportID:(int)reportID
{
    NSString *query = @"INSERT INTO ReportChemicalMixes (ReportID) VALUES (?)";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:reportID]];
    [self Query:query Parameters:parameters];
//    [self UpdateIsSynced:reportID IsSynced:NO];
}

-(NSMutableArray *)GetReportChemicalMixesReportID:(int)reportID
{
    NSString *query = @"SELECT * FROM ReportChemicalMixes WHERE ReportID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:reportID]];
    return [self Query2dArray:query Parameters:parameters];
}

-(void)UpdateReportChemicalMixID:(int)ID Chemical:(NSString *)chemical Concentration:(NSString *)concentration Units:(NSString *)units ApplicationMethod:(NSString *)applicationMethod VolumeSprayed:(NSString *)volumeSprayed ChemicalUsed:(NSString *)ChemicalUsed
{
    NSString *query = @"UPDATE ReportChemicalMixes SET Name = ?, Concentration = ?, Units = ?, ApplicationMethod = ?, VolumeSprayed = ?, ChemicalUsed = ? WHERE ID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    
    if(chemical == nil)
        [parameters addObject:@""];
    else
        [parameters addObject:chemical];
    if(concentration == nil)
        [parameters addObject:@""];
    else
        [parameters addObject:concentration];
    
    if(units == nil)
        [parameters addObject:@""];
    else
        [parameters addObject:units];
    if(applicationMethod == nil)
        [parameters addObject:@""];
    else
        [parameters addObject:applicationMethod];
    if(volumeSprayed == nil)
        [parameters addObject:@""];
    else
        [parameters addObject:volumeSprayed];
    if(ChemicalUsed == nil)
        [parameters addObject:@""];
    else
        [parameters addObject:ChemicalUsed];
    
    [parameters addObject:[NSNumber numberWithInt:ID]];
    [self Query:query Parameters:parameters];
//    [self UpdateIsSynced:ID IsSynced:NO];
}

-(void)RemoveReportChemicalMixID:(int)ID
{
    NSString *query = @"DELETE FROM ReportChemicalMixes WHERE ID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:ID]];
    [self Query:query Parameters:parameters];
//    [self UpdateIsSynced:ID IsSynced:NO];
}

-(NSMutableArray *)GetChemicalMixFromChemical:(NSString *)chemical ApplicationMethod:(NSString *)ApplicationMethod
{
    NSString *query = @"SELECT * FROM ChemicalMixes WHERE Name = ? AND ApplicationMethod = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:chemical];
    [parameters addObject:ApplicationMethod];
    return [self Query2dArray:query Parameters:parameters];
}

-(NSMutableArray *)GetChemicals
{
    NSString *query = @"SELECT DISTINCT Name FROM ChemicalMixes";
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject:@""];
    [result addObjectsFromArray:[self QueryArray:query Parameters:[[NSMutableArray alloc] init]]];
    return result;
}

-(NSMutableArray *)GetReportWeeds:(int)ID
{
    NSString *query = @"SELECT WeedName FROM ReportWeeds WHERE ReportID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:ID]];
    return [self QueryArray:query Parameters:parameters];
//    [self UpdateIsSynced:ID IsSynced:NO];
}

-(void)UpdateReportWeedsReport:(int)ID Weeds:(NSMutableArray *)Weeds
{
    NSString *query = @"DELETE FROM ReportWeeds WHERE ReportID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:ID]];
    [self Query:query Parameters:parameters];
    for (int i = 0; i < Weeds.count; i++) {
        query = @"INSERT INTO ReportWeeds (ReportID, WeedName) VALUES (?, ?)";
        parameters = [[NSMutableArray alloc] init];
        [parameters addObject:[NSNumber numberWithInt:ID]];
        [parameters addObject:(NSString *)[Weeds objectAtIndex:i]];
        [self Query:query Parameters:parameters];
    }
//    [self UpdateIsSynced:ID IsSynced:NO];
}

-(void)AddReportPictureReportID:(int)ReportID Image:(UIImage *)image
{
    NSString *query = @"INSERT INTO ReportPictures (ReportID, Picture) VALUES (?, ?)";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:ReportID]];
    [parameters addObject:UIImageJPEGRepresentation(image, 0.7)];
    [self Query:query Parameters:parameters];
//    [self UpdateIsSynced:ReportID IsSynced:NO];
}

-(void)UpdateReportPictureID:(int)ID Image:(UIImage *)image
{
    NSString *query = @"UPDATE ReportPictures SET Picture = ? WHERE ID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:UIImageJPEGRepresentation(image, 0.7)];
    [parameters addObject:[NSNumber numberWithInt:ID]];
    [self Query:query Parameters:parameters];
//    [self UpdateIsSynced:ID IsSynced:NO];
}

-(NSMutableArray *)GetReportPictureReportID:(int)ReportID
{
    NSString *query = @"SELECT ID, Picture FROM ReportPictures WHERE ReportID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:ReportID]];
    return [self Query2dArray:query Parameters:parameters];
}

-(void)DeleteReportPictureID:(int)ID
{
    NSString *query = @"DELETE FROM ReportPictures WHERE ID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:ID]];
    [self Query:query Parameters:parameters];
}

-(BOOL)IsReportSynced:(int)ReportID
{
    NSString *query = @"SELECT * FROM IsSynced WHERE ReportID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:ReportID]];
    NSMutableArray *result = [self QueryArray:query Parameters:parameters];
    if ([[result objectAtIndex:2] isEqual:@"YES"]) {
        return YES;
    }
    else {
        return NO;
    }
}

-(void)UpdateIsSynced:(int)ReportID IsSynced:(BOOL)IsSynced
{
    NSString *isSynced;
    if (IsSynced == YES) {
        isSynced = @"YES";
    }
    else {
        isSynced = @"NO";
    }
    NSString *query = @"UPDATE IsSynced SET IsSynced = ? WHERE ReportID = ?";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:isSynced];
    [parameters addObject:[NSNumber numberWithInt:ReportID]];
    [self Query:query Parameters:parameters];
}

-(void)InsertIsSynced:(int)ReportID
{
    NSString *query = @"INSERT INTO IsSynced (ReportID, IsSynced) VALUES (?, 'No')";
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    [parameters addObject:[NSNumber numberWithInt:ReportID]];
    [self Query:query Parameters:parameters];
}

-(NSMutableArray *)selectLSDFromLat:(double)Lat Long:(double)Long CeilingLat:(double)CeilingLat FloorLong:(double)FloorLong
{
    double ceilingLat = Lat + 1;
    double floorLong = Long - 1;
    
//    ceilingLat = 49.01367245 + 1;
//    floorLong = 110.0948890 - 1;
    
    NSString *query;
    query = [NSString stringWithFormat:@"SELECT *, distance(latitude, longitude, %f, %f) as dist FROM lsdLocations WHERE latitude > %f AND latitude < %f AND longitude > %f AND longitude < %f ORDER BY dist", Lat, Long, Lat, ceilingLat, floorLong, Long];
    return [self QueryLocation:query];
}

-(NSMutableArray *)QueryLocation:(NSString *)query
{
    @synchronized(databaseLock)
    {
        NSMutableArray *arrResult = [[NSMutableArray alloc] init];
        // The database is stored in the application bundle.
        [self createEditableCopyOfDatabaseIfNeeded];
        // Open the database. The database was prepared outside the application.
        if ((sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) && (dbSuccess ==TRUE) )
        {
            sqlite3_create_function_v2(database, "Distance", 4, SQLITE_UTF8, NULL, &distance, NULL, NULL, NULL);
            
            const char *sql = [query UTF8String];
            sqlite3_stmt *statement;
            
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    //sqlite3_column_count(statement);
                    // The second parameter indicates the column index into the result set.
                    NSMutableArray *row = [[NSMutableArray alloc] init];
                    for (int i = 0; i < sqlite3_column_count(statement); i++)
                    {
                        NSString *name;
                        if (sqlite3_column_text(statement, i) != NULL)
                        {
                            name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                        }
                        else
                        {
                            name = @"";
                        }
                        [row addObject:name];
                    }
                    [arrResult addObject:row];
                }
            }
            else
            {
                NSLog(@"Database error: %s", sqlite3_errmsg(database));
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
        }
        else
        {
            sqlite3_close(database);
            NSLog(@"%s", sqlite3_errmsg(database));
            NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        }
        return arrResult;
    }
}

static void distance (sqlite3_context* context, int argc, sqlite3_value** argv)
{
    double cornerLatRad = sqlite3_value_double(argv[0]) * M_PI / 180.0;
    double cornerLongRad = sqlite3_value_double(argv[1]) * M_PI / 180.0;
    double LatRad = sqlite3_value_double(argv[2]) * M_PI / 180.0;
    double LongRad = sqlite3_value_double(argv[3]) * M_PI / 180.0;
    
    double result = 6371.0 * 2 * asin(sqrt(pow(sin((LatRad - cornerLatRad) / 2), 2) + cos(LatRad) *
                                           cos(cornerLatRad) * pow(sin((LongRad - cornerLongRad) / 2), 2)
                                           ));
    sqlite3_result_double(context, result);
}

@end
