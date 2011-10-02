
#import "CoreDataProvider.h"

@implementation CoreDataProvider

- (void)dealloc {

    [context_ release];
    
    [super dealloc];

}

- (id)createInstance:(JSObjectionInjector *)context {
    
    if ( context_ == nil ) {
    
        NSURL *appDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [appDirectory URLByAppendingPathComponent:@"sockso-ios.sqlite"];
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SocksoDataModel" withExtension:@"momd"];
        
        NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
        
        context_ = [[[NSManagedObjectContext alloc] init] retain];
        [context_ setPersistentStoreCoordinator:persistentStoreCoordinator];
        
    }

    return context_;
    
}

@end
