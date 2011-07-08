
#import "Properties.h"

@implementation Properties

@dynamic name;
@dynamic value;

+ (Properties *) findByName:(NSString *)name from:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Properties" inManagedObjectContext:context];
    
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name = %@", name]];
    
    NSArray *results = [context executeFetchRequest:request error:nil];

    [request release];

    return ([results count] > 0)
        ? [results objectAtIndex:0]
        : nil;

}

+ (Properties *) initWithName:(NSString *)name andValue:(NSString *)value from:(NSManagedObjectContext *)context {
    
    Properties *prop = [NSEntityDescription insertNewObjectForEntityForName:@"Properties"
                                         inManagedObjectContext:context];
    
    prop.name = name;
    prop.value = value;
    
    return prop;
    
}

+ (BOOL) createOrUpdateWithName:(NSString *)name andValue:(NSString *)value from:(NSManagedObjectContext *)context {
    
    Properties *prop = [Properties findByName:name from:context];
    
    if ( prop != nil ) {
        prop.value = value;
    }
    
    else {
        prop = [Properties initWithName:name andValue:value from:context];
    }
    
    NSError *error;
    
    if ( ![context save:&error] ) {
        NSLog( @"Failed to save context: %@", [error localizedDescription] );
        return NO;
    }
    
    return YES;

}

@end
