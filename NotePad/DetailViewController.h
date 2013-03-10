//
//  DetailViewController.h
//  NotePad
//
//  Created by curos on 3/10/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
