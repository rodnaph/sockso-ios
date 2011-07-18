
#import "SearchViewController.h"
#import "MusicItem.h"
#import "SocksoServer.h"
#import "PlayViewController.h"
#import "Track.h"
#import "ImageLoader.h"
#import "ImageLoaderDelegate.h"
#import "MusicCell.h"
#import "ArtistViewController.h"
#import "AlbumViewController.h"

@implementation SearchViewController

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

+ (SearchViewController *) viewForServer:(SocksoServer *)server {
    
    SearchViewController *aView = [[SearchViewController alloc]
                                    initWithNibName:@"SearchView"
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
    
    else {
        cell.actionImage.image = [UIImage imageNamed:@"play.png"];
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
        
        cell.imageView.image = [UIImage imageNamed:@"transparent.png"];
        
        ImageLoader *loader = [ImageLoader fromServer:server forItem:item atIndex:indexPath];
        [loader setDelegate:(id<ImageLoaderDelegate> *)self];
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
    
    __block SearchViewController *this = self;
    
    [server search:query
         onComplete:^(NSMutableArray *items) {
             [this showSearchResults:items];
         }
         onFailure:^{ [this showSearchFailed]; }];
    
}

//
// Informs the user their search failed
//

- (void) showSearchFailed {
    
    // @todo
    
    NSLog( @"Search failed..." );
    
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
    
    else if ( [item isArtist] ) {
        ArtistViewController *ctrl = [ArtistViewController initWithItem:item forServer:server];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    else if ( [item isAlbum] ) {
        AlbumViewController *ctrl = [AlbumViewController initWithItem:item forServer:server];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    else {
        NSLog( @"NOT YET IMPLEMENTED" );
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

