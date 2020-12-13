//
//  CoreDataManager.m
//  AirTicket
//
//  Created by Оксана Зверева on 05.12.2020.
//

#import "CoreDataManager.h"
#import "Ticket.h"

@interface CoreDataManager ()

@property (readonly, strong) NSPersistentContainer *persistenContainer;

@end

@implementation CoreDataManager


+ (instancetype) sharedInstance {
    static CoreDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CoreDataManager new];
    });
    return instance;
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return  [self favoriteFromTicket:ticket] != nil;
}


- (NSArray <FavoriteTicket *> *) favorites {
    NSError *error;
    NSFetchRequest *request = [FavoriteTicket fetchRequest];
    request.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]
    ];
    NSArray *tickets = [self.persistenContainer.viewContext executeFetchRequest: request error:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    
    return tickets;
}


- (void)addToFavorite:(Ticket *)ticket {
    FavoriteTicket *object = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:self.persistenContainer.viewContext];
    object.airline = ticket.airline;
    object.price = ticket.price.integerValue;
    object.from = ticket.from;
    object.to = ticket.to;
    object.departure = ticket.departure;
    object.expiers = ticket.expiers;
    object.flightNumber = ticket.flightNumber.integerValue;
    object.returnDate = ticket.returnDate;
    object.created = [NSDate date];
    [self saveContext];
}


- (void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicket * object = [self favoriteFromTicket:ticket];
    if (object) {
        [self.persistenContainer.viewContext deleteObject:object];
        [self saveContext];
        
    }
}

#pragma mark - Private
- (FavoriteTicket *)favoriteFromTicket: (Ticket *) ticket {
    NSError *error;
    NSFetchRequest *request = [FavoriteTicket fetchRequest];
    NSString *format = @"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expiers == %@ AND flightNumber == %ld";
    
    request.predicate = [NSPredicate predicateWithFormat:format,
                         (long)ticket.price.integerValue,
                         ticket.airline,
                         ticket.from,
                         ticket.to,
                         ticket.departure,
                         ticket.expiers,
                         (long)ticket.flightNumber.integerValue];
    
    NSArray *tickets = [self.persistenContainer.viewContext executeFetchRequest: request error:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        return  nil;
    }
    return tickets.firstObject;
    
}

#pragma mark - Core Date stack

@synthesize persistenContainer = _persistenContainer;

- (NSPersistentContainer * ) persistenContainer {
    
    @synchronized (self) {
        if (_persistenContainer == nil) {
            _persistenContainer = [[NSPersistentContainer alloc] initWithName:@"Tickets"];
            [_persistenContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error){
                if (error != nil) {
                    NSLog(@"Failed to load Core Data stack: %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return  _persistenContainer;
}

- (void) saveContext {
    NSManagedObjectContext * context = self.persistenContainer.viewContext;
    NSError * error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolverd error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
