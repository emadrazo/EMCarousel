//
//  NSArray+Circular.h
//  Carousel
//
//  Created by Eva Madrazo on 9/15/10.
//  Copyright 2014 Eva Madrazo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (Circular)
/**Get object in circular array
 @param index: index of object. 
 */
- (id) circularObjectAtIndex:(NSInteger)index;

/**Get object previous to another in circular array
 @param object: object that exists in array.
 @return the previous object
 */
- (id) circularPreviusObject: (NSObject *)object;

/**Get object next to another in circular array
 @param object: object that exists in array.
 @return the next object
 */
- (id) circularNextObject: (NSObject *)object;
@end
