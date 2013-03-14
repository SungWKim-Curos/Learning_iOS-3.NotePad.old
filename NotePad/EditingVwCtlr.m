//
//  EditingVwCtlr.m
//  NotePad
//
//  Created by curos on 3/11/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import "EditingVwCtlr.h"

#import "Note.h"
#import "Picture.h"
#import "MasterViewController.h"


@interface EditingVwCtlr ()

@property(weak,nonatomic) IBOutlet UINavigationItem* navigationTitle ;
@property(weak,nonatomic) IBOutlet UITextField* noteTitle ;
@property(weak,nonatomic) IBOutlet UITextView* content ;
@property(assign,nonatomic) IBOutlet UINavigationBar* navBar;

@end


@implementation EditingVwCtlr
{
    unsigned m_uImages ;
    NSMutableArray* m_oNewImgPaths ;
    BOOL m_modalViewOn ;
}


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
        
        // 삭제button 추가
        UIBarButtonItem* oDelBtn =
            [ [UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                         target:self
                                         action:@selector(deleteNote) ] ;
        self.navigationItem.rightBarButtonItem = oDelBtn ;
        
        
        // note의 내용
        _noteTitle.text = m_oNote.title ;
        _content.text = m_oNote.content ;
        
        // 그림 보여주기
        const float fSideLen = _imagePreview.frame.size.height ;
        frame = CGRectMake( 0, 0, fSideLen, fSideLen ) ;
        for( Picture* oPicture in m_oNote.pictures )
        {
            UIImage* oImg = [ UIImage imageWithContentsOfFile:oPicture.filePath ] ;
            UIImageView* oImgVw = [ [UIImageView alloc] initWithImage:oImg ] ;
            
            frame.origin.x = fSideLen * m_uImages ;
            oImgVw.frame = frame ;
            [ _imagePreview addSubview:oImgVw ] ;
            
            ++m_uImages ;
        }
        
        // button 움직이기
        frame = _addImgBtn.frame ;
        frame.origin.x += fSideLen * m_uImages ;
        _addImgBtn.frame = frame ;
        
        CGSize size = CGSizeMake( fSideLen*(m_uImages+1), fSideLen ) ;
        _imagePreview.contentSize = size ;
    }
    else
    {
        _navigationTitle.title = @"New Note" ;
    }
    
    m_oNewImgPaths = [ [NSMutableArray alloc] initWithCapacity:10 ] ;
}


-(void) viewWillDisappear:(BOOL)a_animated
{
    [ super viewWillDisappear:a_animated ] ;
    
    if( nil == m_oNote )
        return ;
    
    if( m_modalViewOn )
        return ;
    
    m_oNote.title = _noteTitle.text ;
    m_oNote.content = _content.text ;
    
    const unsigned uCount = m_oNewImgPaths.count ;
    for( unsigned u=0 ; u<uCount ; ++u )
    {
        Picture* oPic =
            [ NSEntityDescription insertNewObjectForEntityForName:@"Picture"
                                       inManagedObjectContext:_managedObjectContext ];
        oPic.filePath = m_oNewImgPaths[u] ;
        oPic.attachedTo = m_oNote ;
    }
    
    __autoreleasing NSError* oErr = nil ;
    [_managedObjectContext save:&oErr ] ;
}


#pragma mark - Actions

-(IBAction) cancelDidClick:(UIBarButtonItem*)a_oSender
{
    NSFileManager* oFileMgr = [ NSFileManager defaultManager ] ;
    for( NSString* oFilePath in m_oNewImgPaths )
    {
        NSError* oErr = nil ;
        [ oFileMgr removeItemAtPath:oFilePath error:&oErr ] ;
    }
    
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
    
    // 그림 추가
    unsigned uCount = m_oNewImgPaths.count ;
    for( unsigned u=0 ; u<uCount ; ++u )
    {
        Picture* oPic =
            [ NSEntityDescription insertNewObjectForEntityForName:@"Picture"
                                           inManagedObjectContext:_managedObjectContext ];
        oPic.filePath = m_oNewImgPaths[u] ;
        oPic.attachedTo = oNote ;
    }
    
    // 저장
    NSError* oErr = nil ;
    [ _managedObjectContext save:&oErr ] ;
    
    // 목록에 알려준다.
    [ m_oPrevCtlr didIndertNewNote:oNote ] ;
    
    [ super dismissModalViewControllerAnimated:YES ] ;    
}


-(IBAction) addPicture
{
    UIImagePickerController* oImgPicker = [ [UIImagePickerController alloc] init ] ;
    oImgPicker.delegate = self ;
    oImgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    m_modalViewOn = TRUE ;
    [ super presentModalViewController:oImgPicker animated:YES ] ;
}


-(void) imagePickerController:(UIImagePickerController*)a_oPicker
        didFinishPickingImage:(UIImage*)a_oImg
                  editingInfo:(NSDictionary*)a_oEditingInfo
{
    [a_oPicker dismissModalViewControllerAnimated:YES];
    m_modalViewOn = FALSE ;
    
    NSString* oFileName = [ [NSDate date] description ] ;
    NSString* oFilePath = [ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES ) lastObject ] ;
    oFilePath = [ oFilePath stringByAppendingPathComponent:oFileName ] ;
    oFilePath = [ oFilePath stringByAppendingPathExtension:@"jpg" ] ;
    
    NSData *oImgData = UIImageJPEGRepresentation(a_oImg, 0) ;
    BOOL succ = [ oImgData writeToFile:oFilePath atomically:TRUE ] ;
    if( ! succ ) return ;
    [ m_oNewImgPaths addObject:oFilePath ] ;
    
    UIImageView* oImgVw = [ [UIImageView alloc] initWithImage:a_oImg ] ;
    const float fSideLen = _imagePreview.frame.size.height ;
    CGRect frame = CGRectMake( fSideLen * m_uImages, 0, fSideLen, fSideLen) ;
    oImgVw.frame = frame ;
    [ _imagePreview addSubview:oImgVw ] ;
    
    ++m_uImages ;
    
    frame = _addImgBtn.frame ;
    frame.origin.x += fSideLen ;
    _addImgBtn.frame = frame ;
    
    CGSize size = CGSizeMake( fSideLen*(m_uImages+1), fSideLen ) ;
    _imagePreview.contentSize = size ;
}


-(void)touchesEnded:(NSSet*)a_oTouches withEvent:(UIEvent*)a_oEv
{
     [ _noteTitle resignFirstResponder ] ;
     [ _content resignFirstResponder ] ;
}


-(void) deleteNote
{
    [ _managedObjectContext deleteObject:m_oNote ] ;
    NSError* oErr = nil ;
    [ _managedObjectContext save:&oErr ] ;
    
    [ super.navigationController popViewControllerAnimated:TRUE ] ;
}

@end
