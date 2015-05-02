//
//  AlbumTableVC.m
//  FilterGallery
//
//  Created by Satinder Singh on 4/21/15.
//
//

#import "AlbumTableVC.h"
#import "Album.h"
#import "CoreDataHelper.h"
#import "PhotosCollectionVC.h"

@interface AlbumTableVC () <UIAlertViewDelegate>

@end

@implementation AlbumTableVC

-(NSMutableArray *)albums{
    if(!_albums) _albums = [[NSMutableArray alloc] init];
    return _albums;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    NSError *error = nil;
    self.albums = [[[CoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error] mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)addAlbumPressed:(UIBarButtonItem *)sender {
    UIAlertView *albumAlertView = [[UIAlertView alloc] initWithTitle:@"Enter New Album Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [albumAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [albumAlertView show];
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        [self.albums addObject:[self albumWithName:alertText]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.albums count]-1 inSection:0];
        // insertRowAtIndexPath is more efficient than reloadData for inserting
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Helper Methods

-(Album *)albumWithName:(NSString *)name{
    NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    album.name = name;
    album.date = [NSDate date];
    
    NSError *error = nil;
    if(![context save:&error]){
        // error happened
    }
    return album;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.albums count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
//     Configure the cell...
    Album *selectedAlbum = self.albums[indexPath.row];
    cell.textLabel.text = selectedAlbum.name;
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
//Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
//album.name = name;
//album.date = [NSDate date];
//
//NSError *error = nil;
//if(![context save:&error]){
//    // error happened
//}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Album *selectedAlbum = self.albums[indexPath.row];
        NSManagedObjectContext *context = [CoreDataHelper managedObjectContext];
        NSEntityDescription *albumEntity=[NSEntityDescription entityForName:@"Album" inManagedObjectContext:context];
        NSFetchRequest *fetchrequest = [[NSFetchRequest alloc] init];
        [fetchrequest setEntity:albumEntity];
        NSPredicate *p = [NSPredicate predicateWithFormat:@"date == %@", selectedAlbum.date];
        [fetchrequest setPredicate:p];
        
        NSError *fetchError;
        NSError *error = nil;
        NSArray *fetchedAlbums = [context executeFetchRequest:fetchrequest error:&fetchError];
        if (fetchError) {
            NSLog(@"Fetch Error in Album Table VC");
            return;
        }
        [context deleteObject:fetchedAlbums[0]];
        
        [[selectedAlbum managedObjectContext] save:&error];
        
        if (error) NSLog(@"Error in delete Album");
        else{
            [self.albums removeObject:selectedAlbum]; // number of rows in Section is also updated.
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PhotosCollectionVC class]] &&
        [segue.identifier isEqualToString:@"Album Chosen"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        PhotosCollectionVC *targetVC = segue.destinationViewController;
        targetVC.album = self.albums[path.row];
    }
}


@end
