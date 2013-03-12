//
//  EditingVwCtlr.h
//  NotePad
//
//  Created by curos on 3/11/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasterViewController ;


@interface EditingVwCtlr : UIViewController
{
@public
    MasterViewController* m_oPrevCtlr ;
}

@property(strong,nonatomic) NSManagedObjectContext * managedObjectContext ;

@end
