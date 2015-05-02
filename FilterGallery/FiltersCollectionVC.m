//
//  FiltersCollectionVC.m
//  FilterGallery
//
//  Created by Satinder Singh on 4/30/15.
//
//

#import "FiltersCollectionVC.h"
#import "Photo.h"
#import "PhotoCollectionViewCell.h"

@interface FiltersCollectionVC ()

@property(strong, nonatomic) NSMutableArray *filters;
@property (strong, nonatomic) CIContext *context; // renders CIImage & create CIImage from it

@end

@implementation FiltersCollectionVC

static NSString * const reuseIdentifier = @"Photo Cell";


#pragma mark - Lazy Instantiation
-(NSMutableArray *)filters{
    if (!_filters) _filters = [[NSMutableArray alloc] init];
    return _filters;
}

-(CIContext *)context{
    if(!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.filters = [[self class] photoFilters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Filter Segue"] && [segue.destinationViewController isKindOfClass:[FiltersCollectionVC class]]) {
        FiltersCollectionVC *targetVC = segue.destinationViewController;
        targetVC.photo = self.photo;
    }
}
*/
#pragma mark - Helpers
+(NSMutableArray *)photoFilters{
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"];
    CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents",
                            [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents",
                            [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil]; // XYZW is RGBA
    CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
    CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues: nil];
    CIFilter *colorControl = [CIFilter filterWithName:@"CIColorControls" keysAndValues: kCIInputSaturationKey, @0.5, nil];
    CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues: nil];
    CIFilter *unsharpen = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues: nil];
    CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: nil];
    return [[NSMutableArray alloc] initWithObjects:sepia, blur, colorClamp, instant, noir, vignette, colorControl, transfer, unsharpen, monochrome, nil];
    //return @[sepia, blur, colorClamp, instant, noir, vignette, colorControl, transfer, unsharpen, monochrome]; // for NSArray
}

-(UIImage *) filteredImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter{
    CIImage *unfilteredImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    [filter setValue:unfilteredImage forKey:kCIInputImageKey];
    CIImage *filteredImage = [filter outputImage];
    CGRect extent = [filteredImage extent];
    CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent];
    return [UIImage imageWithCGImage:cgImage];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.filters count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    dispatch_queue_t filterQ = dispatch_queue_create("filter queue", NULL);
    dispatch_async(filterQ, ^{
        UIImage *filterImage = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]];
        dispatch_async(dispatch_get_main_queue(), ^{ // only update UI on main_queue
            cell.imageView.image = filterImage;
        });
    });
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *selectedCell = (PhotoCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    self.photo.image = selectedCell.imageView.image;
    
    if (self.photo.image) { // save to Core Data only when image is fully loaded
        NSError *error;
        if (![[self.photo managedObjectContext] save:&error] ) {
            NSLog(@"Error");
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
