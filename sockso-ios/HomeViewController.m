
#import "HomeViewController.h"
#import "MusicItem.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "SocksoServer.h"
#import "PlayViewController.h"
#import "MusicViewController.h"
#import "Track.h"
#import "ImageLoader.h"
#import "ImageLoaderDelegate.h"
#import "MusicCell.h"

@implementation HomeViewController

@synthesize server, listContent;

- (void) viewDidLoad {
    
    images = [[NSMutableDictionary alloc] init];
    
    self.title = server.title;
    
    if ( [self.title isEqualToString:@""] ) {
        self.title = server.tagline;
    }

    if ( [self.title isEqualToString:@""] ) {
        self.title = @"Sockso";
    }
    
}

//
// Create a view controller for the server
//

+ (HomeViewController *) viewForServer:(SocksoServer *)server {
    
    HomeViewController *aView = [[HomeViewController alloc]
                                 initWithNibName:@"HomeView"
                                 bundle:nil];
    
    aView.server = server;
    
    return [aView autorelease];
    
}

//
// return the number of rows in the list
//

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [self.listContent count];

}

//
// return the cell for the row at the specified index
//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *kCellID = @"cellID";
	
	MusicCell *cell = (MusicCell *) [tableView dequeueReusableCellWithIdentifier:kCellID];
    
	if ( cell == nil ) {
        
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MusicCellView"
                                                         owner:self
                                                       options:nil];
        cell = (MusicCell *) [objects objectAtIndex:0];
        
	}
	    
    MusicItem *item = [self.listContent objectAtIndex:indexPath.row];
	
    [cell drawForItem:item];
    
    if ( [item isAlbum] || [item isArtist] ) {
        [self setArtworkOnCell:cell forMusicItem:item atIndex:indexPath];
    }
    
	return cell;
    
}

//
// Sets cell artwork for an artist or album
//

- (void) setArtworkOnCell:(UITableViewCell *)cell forMusicItem:(MusicItem *)item atIndex:(NSIndexPath *)indexPath {
    
    NSString *key = [NSString stringWithFormat:@"image-%@", item.mid];
    UIImage *image = [images objectForKey:key];
    
    if ( image ) {
        cell.imageView.image = image;
    }
    
    else {
        ImageLoader *loader = [ImageLoader fromServer:server forItem:item atIndex:indexPath];
        [loader setDelegate:self];
        [loader load];
    }

}

//
// search button clicked, make search request
//

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [searchBar resignFirstResponder];
    
    [self performSearch:[searchBar text]];
    
}

//
//  perform a search with the specified text
//

- (void) performSearch:(NSString *)query {
    
    [server search:query
         onComplete:^(NSMutableArray *items) {
             [self showSearchResults:items];
         }
         onFailure:^{}];
    
}

//
// Informs the user their search failed
//

- (void) showSearchFailed {
    
    // @todo
    
}

//
// puts search result data into listContent then reloads the table
//

- (void) showSearchResults:(NSMutableArray *) items {
        
    self.listContent = items;
    
    [self.tableView reloadData];
    
}

//
// Music item selected
//

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MusicItem *item = [self.listContent objectAtIndex:[indexPath row]];
    
    if ( [item isTrack] ) {
        
        int trackId = [[item.mid substringFromIndex:2] intValue];
        
        [server getTrack:trackId onComplete:^(Track *track){
            [self.navigationController pushViewController:[PlayViewController viewForTrack:track server:server]
                                                 animated:YES];
        }];
        
    }
    
    else {
        NSLog( @"NOT YET IMPLEMENTED" );
//        [self.navigationController pushViewController:[MusicViewController viewForItem:item] animated:YES];
    }
    
}

//
// The image has loaded and is for the table item at the specified index
//

- (void) imageDidLoad:(UIImage *)image atIndex:(NSIndexPath *)indexPath {

    MusicItem *item = [listContent objectAtIndex:indexPath.row];
    NSString *key = [NSString stringWithFormat:@"image-%@", item.mid];
        
    [images setValue:image forKey:key];
        
    [self.tableView reloadData];
    
}

//
// dealloc
//

- (void) dealloc {
    
    [images release];
    [server release];
    [listContent release];
    
    [super dealloc];
    
}

@end

