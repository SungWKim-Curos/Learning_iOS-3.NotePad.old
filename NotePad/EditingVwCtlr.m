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
@property(assign,nonatomic) IBOutlet UINavigationBar* navBar;

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
    
    if( nil != m_oNote )
    {
        const float fNavHeight = _navBar.frame.size.height ;
        
        CGRect frame = _noteTitle.frame ;
        frame.origin.y -= fNavHeight ;
        _noteTitle.frame = frame ;
        
        frame = _content.frame ;
        frame.origin.y -= fNavHeight ;
        frame.size.height += fNavHeight ;
        _content.frame = frame ;
        
        _navBar.hidden = TRUE ;
        
        _noteTitle.text = m_oNote.title ;
        _content.text = m_oNote.content ;
    }
    else
    {
        _navigationTitle.title = @"New Note" ;
    }
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
