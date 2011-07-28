
#import "ArtistsViewController.h"
#import "SocksoServer.h"
#import "MusicCell.h"
#import "ArtistViewController.h"

@interface ArtistsViewController ()

- (void)initArtists;
- (void)initSectionsFromArtists:(NSArray *)artists;

- (void)showArtists:(NSArray *)artists;
- (void)showQueryError;

- (Artist *)artistForIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)sortedArtists;

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
    
    NSString *title = [[self sortedArtists] objectAtIndex:section];
    
    return [title isEqualToString:@"_"] ? @"Misc" : title;
    
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *letter = [[self sortedArtists] objectAtIndex:section];
    
    return [[sections valueForKey:letter] count];
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicCell *cell = (MusicCell *) [tableView dequeueReusableCellWithIdentifier:@"artistCell"];
    
    if ( cell == nil ) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MusicCellView" owner:self options:nil];
        cell = (MusicCell *) [objects objectAtIndex:0];
    }
    
    Artist *artist = [self artistForIndexPath:indexPath];

    cell.trackName.text = artist.name;
    cell.artistName.text = @"";
    cell.artworkImage.imageURL = [server getImageUrlForMusicItem:artist];
    
    return cell;
    
}

- (NSArray *)sortedArtists {
    
    return [[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

}

- (Artist *)artistForIndexPath:(NSIndexPath *)indexPath {
    
    return [[sections valueForKey:[[self sortedArtists] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog( @"Artist selected" );
    
    Artist *artist = [self artistForIndexPath:indexPath];
    ArtistViewController *artistView = [ArtistViewController initWithItem:artist forServer:server];
    
    [self.homeViewController.navigationController pushViewController:artistView animated:YES];
    
}

@end
