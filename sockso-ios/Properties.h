
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Properties : NSManagedObject {}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;

//
// Finds a property by name, or returns nil if not found
//

+ (Properties *) findByName:(NSString *)name from:(NSManagedObjectContext *)context;

//
// Init a new property object with name/value
//

+ (Properties *) initWithName:(NSString *)name andValue:(NSString *)value from:(NSManagedObjectContext *)context;

//
// Updates specified property if it exists, or creates a new one
//

+ (BOOL) createOrUpdateWithName:(NSString *)name andValue:(NSString *)value from:(NSManagedObjectContext *)context;

@end
