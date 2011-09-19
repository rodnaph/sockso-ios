
@class SocksoServer, Artist, Album;

@interface SocksoApi : NSObject {}

@property (nonatomic, assign) SocksoServer *server;

- (id)initWithServer:(SocksoServer *)server;

- (void)albumsForArtist:(Artist *)artist onComplete:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure;
- (void)tracksForArtist:(Artist *)artist onComplete:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure;
- (void)tracksForAlbum:(Album *)item onComplete:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure;
- (void)artists:(void (^)(NSArray *))onComplete onFailure:(void (^)(void))onFailure;
- (void)session:(void (^)(void))onSuccess onFailure:(void (^)(void))onFailure;

@end
