//
//  PhotoDetailVC.m
//  FilterGallery
//
//  Created by Satinder Singh on 4/30/15.
//
//

#import "PhotoDetailVC.h"
#import "Photo.h"
#import "FiltersCollectionVC.h"

@interface PhotoDetailVC ()

@end

@implementation PhotoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.imageView.image = self.photo.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Filter Segue"] && [segue.destinationViewController isKindOfClass:[FiltersCollectionVC class]]) {
        FiltersCollectionVC *targetVC = segue.destinationViewController;
        targetVC.photo = self.photo;
    }
}


- (IBAction)addFilterPressed:(UIButton *)sender { 
}

- (IBAction)deletePressed:(UIButton *)sender {
    [[self.photo managedObjectContext] deleteObject:self.photo];
    // save is called explicitly here because simulator is used. Actual device uses Core Data's autosave.
    NSError *error = nil;
    [[self.photo managedObjectContext] save:&error];
    if (error){
        NSLog(@"Error in delete Pressed");
    }

    [self.navigationController popViewControllerAnimated:YES];
      
}
@end
