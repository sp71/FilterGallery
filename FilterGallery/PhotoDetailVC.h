//
//  PhotoDetailVC.h
//  FilterGallery
//
//  Created by Satinder Singh on 4/30/15.
//
//

#import <UIKit/UIKit.h>

@class Photo;

@interface PhotoDetailVC : UIViewController

@property(strong, nonatomic) Photo *photo;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)addFilterPressed:(UIButton *)sender;
- (IBAction)deletePressed:(UIButton *)sender;

@end
