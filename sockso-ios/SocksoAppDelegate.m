
#import "SocksoAppDelegate.h"
#import "ConnectViewController.h"

@implementation SocksoAppDelegate

@synthesize window, navigationController, managedObjectModel, managedObjectContext, persistentStoreCoordinator;

- (void) applicationDidFinishLaunching:(UIApplication *)application {

    [self initCoreData];
    
    ConnectViewController *aView = [[ConnectViewController alloc]
                                    initWithNibName:@"ConnectView"
                                    bundle:nil];
    
    aView.context = managedObjectContext;

    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:aView];
    
    NSLog( @"Create navigation controller" );
    
    self.navigationController = navController;
    [navController release];
    [aView release];
    
    NSLog( @"Make window visible" );
    
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];

}

- (void) initCoreData {
    
    NSURL *appDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [appDirectory URLByAppendingPathComponent:@"sockso-ios.sqlite"];
    
    NSLog( @"CoreData: Create Managed Object Model" );
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SocksoDataModel" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSLog( @"CoreData: Create Persistent Store Coordinator" );
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    
    NSLog( @"CoreData: Create Managed Object Context" );
    
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        
}

- (void) dealloc {
    
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [navigationController release];
    [window release];
    
    [super dealloc];
    
}

@end
