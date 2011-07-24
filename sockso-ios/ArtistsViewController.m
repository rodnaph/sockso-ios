
#import "ArtistsViewController.h"
#import "SocksoServer.h"
#import "MusicCell.h"

@interface ArtistsViewController ()

- (void)initArtists;
- (void)initSectionsFromArtists:(NSArray *)artists;

- (void)showArtists:(NSArray *)artists;
- (void)showQueryError;

@end

@implementation ArtistsViewController

@synthesize artistsTable, server, homeViewController;

+ (ArtistsViewController *) viewForServer:(SocksoServer *)server {
    
    ArtistsViewController *ctrl = [[ArtistsViewController alloc]
                                   initWithNibName:@"ArtistsView"
                                   bundle:nil];
    
    ctrl.server = server;
    
    return [ctrl autorelease];
    
}

#pragma mark -
#pragma mark init

- (void) dealloc {

    [sections release];
    [artistsTable release];
    [server release];
    [homeViewController release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark View

- (void) viewDidLoad {

    sections = [[NSMutableDictionary alloc] init];
    
    [self initArtists];
    
}

- (void) initArtists {
    
    __block ArtistsViewController *this = self;
    
    [server getArtists:^(NSArray *artists){ [this showArtists:artists]; }
             onFailure:^{ [this showQueryError]; }];
    
}

- (void)showArtists:(NSArray *)artists {

    [self initSectionsFromArtists:artists];
    
    [artistsTable reloadData];
    
}

- (void)initSectionsFromArtists:(NSArray *)artists {
    
    for ( Artist *artist in artists ) {
        
        char firstLetter = [artist.name characterAtIndex:0];
        NSString *letter = ( firstLetter > 90 || firstLetter < 65 ) ? @"_" : [artist.name substringToIndex:1];
        
        if ( [sections objectForKey:letter] == nil ) {
            NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
            [sections setObject:array forKey:letter];
        }
        
        [[sections objectForKey:letter] addObject:artist];
        
    }
    
}

- (void)showQueryError {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Error fetching artists"
                                                   delegate:self
                                          cancelButtonTitle:@"Ignore"
                                          otherButtonTitles:@"Try again", nil];
    
    [alert show];
    [alert release];
    
}

#pragma mark -
#pragma mark Table

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[sections allKeys] count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = [[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    
    return [title isEqualToString:@"_"] ? @"Misc" : title;
    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *sorted = [[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *letter = [sorted objectAtIndex:section];
    
    return [[sections valueForKey:letter] count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicCell *cell = (MusicCell *) [tableView dequeueReusableCellWithIdentifier:@"artistCell"];
    
    if ( cell == nil ) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MusicCellView" owner:self options:nil];
        cell = (MusicCell *) [objects objectAtIndex:0];
    }
    
    Artist *artist = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    cell.trackName.text = artist.name;
    cell.artistName.text = @"";
    cell.artworkImage.imageURL = [server getImageUrlForMusicItem:artist];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
