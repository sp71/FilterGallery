//
//  AlbumTableVC.h
//  FilterGallery
//
//  Created by Satinder Singh on 4/21/15.
//
//

#import <UIKit/UIKit.h>

@interface AlbumTableVC : UITableViewController

@property (strong, nonatomic) NSMutableArray *albums;
- (IBAction)addAlbumPressed:(UIBarButtonItem *)sender;

@end
