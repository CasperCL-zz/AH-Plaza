//
//  APIData.m
//  AH Plaza
//
//  Created by Casper Eekhof on 20-10-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import "APIData.h"
#import "AHParser.h"
#import "AppDelegate.h"
#import "String.h"

#import "Paycheck.h"

@implementation APIData
@synthesize fetchedResultsController, managedObjectContext;

dispatch_queue_t queue;
AHParser * parser;

+ (id)sharedInstance {
    static APIData *instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{ instance = [[APIData alloc] init]; });
    
    return instance;
}


- (id)init
{
    self = [super init];
    if (self) {
        parser = [[AHParser alloc] init];
        queue = dispatch_queue_create("APIData retrieval queue", 0);
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        managedObjectContext = [appDelegate managedObjectContext];
        _fetchRequest = [[NSFetchRequest alloc] init];
        _objects = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void) savePaychecks:(NSArray*)toStore onCompletion:(completion)onCompletion {
    for(NSArray *year in toStore)
        for (Paycheck* paycheck in year) {
            if(![self isStored:paycheck.date forEntity:entity_paycheck type: PAYCHECK]) {
                NSManagedObject *infoToStore = [NSEntityDescription insertNewObjectForEntityForName:entity_paycheck inManagedObjectContext:managedObjectContext];
                [infoToStore setValue: [NSNumber numberWithInt: paycheck.month] forKey:@"month"];
                [infoToStore setValue: paycheck.year forKey:@"year"];
                [infoToStore setValue: paycheck.date forKey:@"date"];
                [infoToStore setValue: paycheck.urlToPDF forKey:@"urlToPDF"];
                [infoToStore setValue: [NSNumber numberWithInt: paycheck.type] forKey: @"type"];
                
                NSError *error;
                if (![managedObjectContext save:&error]) {
                    NSLog(@"Couldn't save office: %@", [error localizedDescription]);
                }
            }
        }
    [managedObjectContext save: nil];
}


-(void) loadPaychecks:(completion)onCompletion {
    [self getObjects:PAYCHECK onCompletion:^(NSArray *objects, NSError *error) {
        if(!error && [objects count]) {
            NSMutableArray * years = [[NSMutableArray alloc] init];
            
            NSString * lastYear = [(Paycheck*)[objects objectAtIndex: 0] year];
            NSMutableArray * month = [[NSMutableArray alloc] init];
            for (Paycheck * paycheck in objects) {
                if([[paycheck year] isEqualToString: lastYear]){
                    [month addObject: paycheck];
                } else {
                    [years addObject: month];
                    lastYear = [paycheck year];
                    month = [[NSMutableArray alloc] init];
                    [month addObject: paycheck];
                }
            }
            [years addObject: month];
            onCompletion(years, error);
        } else {
            onCompletion(nil, error);
        }
    }];
}



-(void) getObjects: (ObjectType)objectType onCompletion: (completion) onCompletion  {
    NSString *entity_name;
    
    switch (objectType) {
        case WEEK:
            //            entity_name =
            break;
        case PAYCHECK:
            entity_name = entity_paycheck;
            break;
    }
    
    _entity = [NSEntityDescription entityForName:entity_name inManagedObjectContext:managedObjectContext];
    [_fetchRequest setEntity:_entity];
    _fetchedObjects = [managedObjectContext executeFetchRequest:_fetchRequest error:nil];
    
    [_objects removeAllObjects];
    
    for (NSManagedObject *info in _fetchedObjects) {
        switch (objectType) {
            case WEEK:
                //                [_objects addObject: [parser parseWeek]];
                break;
                
            case PAYCHECK:
                [_objects addObject: [parser parseSavedPaycheck: info]];
                break;
        }
    }
    
    onCompletion(_objects, nil);
}


-(BOOL)isStored:(id)value forEntity:(NSString *)entityName type:(ObjectType)objectType{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:entityName
                inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate;
    
    //Parameter used to select JUST one row of the database. Never should be duplicated.
    switch (objectType) {
        case WEEK:
            predicate = [NSPredicate predicateWithFormat:@"week == %@", value];
            [request setPredicate:predicate];
            break;
            
        case PAYCHECK:
            predicate = [NSPredicate predicateWithFormat:@"date == %@", value];
            [request setPredicate:predicate];
            break;
    }
    
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) {
        NSUInteger count = [array count]; // May be 0 if the object has been deleted.
        if(count == 0){
            return NO;
        }
    }
    else {
        // Deal with error.
    }
    
    return YES;
}


@end
