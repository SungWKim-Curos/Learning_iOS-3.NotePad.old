//
//  AppDelegate.m
//  NotePad
//
//  Created by curos on 3/10/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    
    masterViewController.managedObjectContext = self.managedObjectContext ;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void) saveContext
{
    NSError* error = nil ;
    NSManagedObjectContext * managedObjectContext = self.managedObjectContext ;
    if( nil == managedObjectContext )
        return ;
    
    if( [managedObjectContext hasChanges] &&
       ! [managedObjectContext save:&error] ) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext ;
@synthesize managedObjectModel = _managedObjectModel ;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator ;

-(NSManagedObjectContext*) managedObjectContext
{
    if( _managedObjectContext != nil )
        return _managedObjectContext;

    
    NSPersistentStoreCoordinator* coordinator = self.persistentStoreCoordinator ;
    if( coordinator != nil ) {
        _managedObjectContext = [ [NSManagedObjectContext alloc] init ];
        [ _managedObjectContext setPersistentStoreCoordinator:coordinator ];
    }
    return _managedObjectContext ;
}


-(NSPersistentStoreCoordinator*) persistentStoreCoordinator
{
    if( _persistentStoreCoordinator != nil )
        return _persistentStoreCoordinator ;

    
    // File을 쓰고 읽을 수 있는 directory를 알아낸다.
    NSArray* docDirURLs =
        [ [NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                inDomains:NSUserDomainMask ];
    NSURL* docDirURL = [ docDirURLs lastObject ] ;
    
    // Store File의 위치를 지정한다.
    NSURL* storeURL = [ docDirURL URLByAppendingPathComponent:@"NotePad.sqlite" ];

    // Model을 property를 통해 얻어내서 그것을 이용해 객체 생성
    _persistentStoreCoordinator =
        [ [NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel ];
    NSError* error = nil ;
    if( ! [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                    configuration:nil
                                                              URL:storeURL
                                                          options:nil
                                                            error:&error] ) {
        NSLog( @"Unresolved error %@, %@", error, error.userInfo );
        abort();
    }
    
    return _persistentStoreCoordinator;
}


-(NSManagedObjectModel*) managedObjectModel
{
    if( _managedObjectModel != nil )
        return _managedObjectModel ;
    
    
    NSURL* modelURL = [ [NSBundle mainBundle] URLForResource:@"NotePad"
                                               withExtension:@"momd" ];
    _managedObjectModel = [ [NSManagedObjectModel alloc]
                                initWithContentsOfURL:modelURL ];
    
    return _managedObjectModel ;
}

@end
