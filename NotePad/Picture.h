//
//  Picture.h
//  NotePad
//
//  Created by curos on 3/13/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Picture : NSManagedObject

@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) Note *attachedTo;

@end
