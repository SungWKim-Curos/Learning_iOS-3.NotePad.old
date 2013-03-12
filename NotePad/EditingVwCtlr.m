//
//  EditingVwCtlr.m
//  NotePad
//
//  Created by curos on 3/11/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import "EditingVwCtlr.h"

#import "Note.h"
#import "MasterViewController.h"


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
    // 생성/삽입
    Note* oNote =
        [ NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                       inManagedObjectContext:_managedObjectContext ];
    
    // property값 대입
    oNote.title = _noteTitle.text ;
    oNote.content = _content.text ;
    oNote.date = [ NSDate date ] ;
    
    // 저장
    NSError* oErr = nil ;
    [ _managedObjectContext save:&oErr ] ;
    
    // 목록에 알려준다.
    [ m_oPrevCtlr didIndertNewNote:oNote ] ;
    
    [ super dismissModalViewControllerAnimated:YES ] ;    
}
@end
