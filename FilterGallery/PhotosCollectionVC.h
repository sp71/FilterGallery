//
//  PhotosCollectionVC.h
//  FilterGallery
//
//  Created by Satinder Singh on 4/23/15.
//
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface PhotosCollectionVC : UICollectionViewController

@property(strong, nonatomic) Album *album;
- (IBAction)cameraPressed:(UIBarButtonItem *)sender;

@end
