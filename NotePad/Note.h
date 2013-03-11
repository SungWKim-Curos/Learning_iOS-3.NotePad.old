//
//  Note.h
//  NotePad
//
//  Created by curos on 3/12/13.
//  Copyright (c) 2013 curos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;

@end
