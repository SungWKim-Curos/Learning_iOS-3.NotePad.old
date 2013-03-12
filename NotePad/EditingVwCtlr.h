//
//  EditingVwCtlr.h
//  NotePad
//
//  Created by curos on 3/11/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasterViewController ;
@class Note ;


@interface EditingVwCtlr : UIViewController
    < UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
@public
    MasterViewController* m_oPrevCtlr ;
    Note* m_oNote ;
}

@property(strong,nonatomic) NSManagedObjectContext * managedObjectContext ;

@end
