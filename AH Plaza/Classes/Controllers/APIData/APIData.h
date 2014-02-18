//
//  APIData.h
//  AH Plaza
//
//  Created by Casper Eekhof on 20-10-13.
//  Copyright (c) 2013 JTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface APIData : NSObject {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

typedef enum {
    PAYCHECK,
    WEEK
} ObjectType;


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;
@property (nonatomic, retain) NSEntityDescription *entity;
@property (nonatomic, retain) NSMutableArray *objects;
@property (nonatomic, retain) NSArray *fetchedObjects;

typedef void (^completion)(NSArray* objects, NSError * error);

+ (id)sharedInstance;
-(void) savePaychecks:(NSArray*)toStore onCompletion:(completion)onCompletion;
-(void) loadPaychecks:(completion)onCompletion;


@end
