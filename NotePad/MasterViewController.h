//
//  MasterViewController.h
//  NotePad
//
//  Created by curos on 3/10/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class Note ;


@interface MasterViewController : UITableViewController
    < NSFetchedResultsControllerDelegate >

@property(strong,nonatomic) NSManagedObjectContext * managedObjectContext ;

@property (strong, nonatomic) DetailViewController *detailViewController;

// Methods
-(void) didIndertNewNote:(Note*)a_oNewNote ;

@end
