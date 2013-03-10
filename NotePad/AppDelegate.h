//
//  AppDelegate.h
//  NotePad
//
//  Created by curos on 3/10/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/*=============================================================*/
// Core Data을 위해서 추가된 property들과 method
@property(readonly,strong,nonatomic)
    NSManagedObjectContext * managedObjectContext ;
@property(readonly,strong,nonatomic)
    NSPersistentStoreCoordinator * persistentStoreCoordinator ;
@property(readonly,strong,nonatomic)
    NSManagedObjectModel * managedObjectModel ;


-(void) saveContext ;
/*============================================================*/

@property (strong, nonatomic) UINavigationController *navigationController;

@end
