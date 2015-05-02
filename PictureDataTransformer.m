//
//  PictureDataTransformer.m
//  FilterGallery
//
//  Created by Satinder Singh on 4/24/15.
//
//

#import "PictureDataTransformer.h"

@implementation PictureDataTransformer

+(Class) transformedValueClass{
    return [NSData class];
}

+(BOOL)allowsReverseTransformation{
    return YES;
}
// UIImage to NSData
-(id)transformedValue:(id)value{
    return UIImagePNGRepresentation(value);
}
// NSData to UIImage
-(id)reverseTransformedValue:(id)value{
    return [UIImage imageWithData:value];
}

@end
