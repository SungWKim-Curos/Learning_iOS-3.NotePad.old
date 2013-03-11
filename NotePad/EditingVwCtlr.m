//
//  EditingVwCtlr.m
//  NotePad
//
//  Created by curos on 3/11/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import "EditingVwCtlr.h"


@interface EditingVwCtlr ()

@property(weak,nonatomic) IBOutlet UINavigationItem* navigationTitle ;
@property(weak,nonatomic) IBOutlet UITextField* noteTitle ;
@property(weak,nonatomic) IBOutlet UITextView* content ;

@end


@implementation EditingVwCtlr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if( nil == self )
        return nil ;

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _navigationTitle.title = @"New Note" ;
}


-(IBAction) cancelDidClick:(UIBarButtonItem*)a_oSender
{
    [ super dismissModalViewControllerAnimated:YES ] ;
}


-(IBAction) saveDidClick:(UIBarButtonItem*)a_oSender
{
}
@end
