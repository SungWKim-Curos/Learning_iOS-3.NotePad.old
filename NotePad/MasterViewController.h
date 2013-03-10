//
//  MasterViewController.h
//  NotePad
//
//  Created by curos on 3/10/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
