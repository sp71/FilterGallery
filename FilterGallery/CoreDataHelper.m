//
//  CoreDataHelper.m
//  FilterGallery
//
//  Created by Satinder Singh on 4/23/15.
//
//

#import "CoreDataHelper.h"
#import <UIKit/UIKit.h> // UIApplication

@implementation CoreDataHelper

+(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
        context = [delegate managedObjectContext];
    return context;
}

@end
