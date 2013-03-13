//
//  Note.m
//  NotePad
//
//  Created by curos on 3/13/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import "Note.h"
#import "Picture.h"


@implementation Note

@dynamic content;
@dynamic date;
@dynamic title;
@dynamic pictures;


-(void) prepareForDeletion
{
    NSFileManager* oFileMgr = [ NSFileManager defaultManager ] ;
    for( Picture* oPic in self.pictures )
    {
        NSError* oErr = nil ;
        [ oFileMgr removeItemAtPath:oPic.filePath error:&oErr ] ;
    }
}

@end
