//
//  CoreDataHelper.h
//  FilterGallery
//
//  Created by Satinder Singh on 4/23/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h> // NSManagedObjectContext

@interface CoreDataHelper : NSObject

+(NSManagedObjectContext *)managedObjectContext;

@end
