
#import "MusicCell.h"
#import "Track.h"
#import "Album.h"
#import "SocksoServer.h"

@interface MusicCell (Private)

- (void)drawForArtist:(Artist *)artist fromServer:(SocksoServer *)server;
- (void)drawForAlbum:(Album *)album fromServer:(SocksoServer *)server;
- (void)drawForTrack:(Track *)track fromServer:(SocksoServer *)server;

@end

@implementation MusicCell

@synthesize trackName, artistName, actionImage, artworkImage;

#pragma mark -
#pragma mark Init

- (void) dealloc {
    
    [trackName release];
    [artistName release];
    [actionImage release];
    [artworkImage release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Methods

- (void) drawForItem:(MusicItem *)item fromServer:(SocksoServer *)server {

    self.imageView.image = nil;
    self.artworkImage.image = nil;
    self.actionImage.image = nil;
    self.textLabel.text = @"";
    
    trackName.text = item.name;
    artistName.text = @"";

    if ( [item isArtist] ) {
        [self drawForArtist:(Artist *)item fromServer:server];
    }
    
    else if ( [item isAlbum] ) {
        [self drawForAlbum:(Album *)item fromServer:server];
    }
    
    else if ( [item isTrack] ) {
        [self drawForTrack:(Track *)item fromServer:server];
    }
    
}

- (void)drawForArtist:(Artist *)artist fromServer:(SocksoServer *)server {

    actionImage.image = [UIImage imageNamed:@"artist-icon.png"];
    artworkImage.imageURL = [server getImageUrlForMusicItem:artist];

}

- (void)drawForAlbum:(Album *)album fromServer:(SocksoServer *)server {

    artistName.text = album.artist.name;
    actionImage.image = [UIImage imageNamed:@"album-icon.png"];
    artworkImage.imageURL = [server getImageUrlForMusicItem:album];

}

- (void)drawForTrack:(Track *)track fromServer:(SocksoServer *)server {

    artistName.text = track.artist.name;
    artworkImage.imageURL = [server getImageUrlForMusicItem:track.album];
    actionImage.image = [UIImage imageNamed:@"play.png"];

}

@end
