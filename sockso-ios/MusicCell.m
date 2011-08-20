
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

@synthesize trackName=trackName_,
            artistName=artistName_,
            actionImage=actionImage_,
            artworkImage=artworkImage_;

#pragma mark -
#pragma mark Init

- (void) dealloc {
    
    [trackName_ release];
    [artistName_ release];
    [actionImage_ release];
    [artworkImage_ release];
    
    [super dealloc];
    
}

#pragma mark -
#pragma mark Methods

- (void) drawForItem:(MusicItem *)item fromServer:(SocksoServer *)server {

    self.imageView.image = nil;
    self.textLabel.text = @"";
    
    trackName_.text = item.name;
    artworkImage_.image = nil;
    actionImage_.image = nil;
    artistName_.text = @"";

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

    actionImage_.image = [UIImage imageNamed:@"artist-icon.png"];
    artworkImage_.imageURL = [server getImageUrlForMusicItem:artist];

}

- (void)drawForAlbum:(Album *)album fromServer:(SocksoServer *)server {

    artistName_.text = album.artist.name;
    actionImage_.image = [UIImage imageNamed:@"album-icon.png"];
    artworkImage_.imageURL = [server getImageUrlForMusicItem:album];

}

- (void)drawForTrack:(Track *)track fromServer:(SocksoServer *)server {

    artistName_.text = track.artist.name;
    artworkImage_.imageURL = [server getImageUrlForMusicItem:track.album];
    actionImage_.image = [UIImage imageNamed:@"play.png"];

}

@end
