//
//  NSArray+Circular.m
//  CasaDelLibro
//
//  Created by Eva Madrazo on 9/15/10.
//  Copyright 2014 Eva Madrazo. All rights reserved.
//

#import "NSArray+Circular.h"


@implementation NSMutableArray (Circular)


-(id) circularObjectAtIndex:(NSInteger)index
{
	
	while (index < 0)
    {
		index = index + [self count];
	}
		
	int i = index%[self count];

	return [self objectAtIndex:i];
}

- (id) circularPreviusObject: (NSObject *)object
{
    NSUInteger index = [self indexOfObject:object];
    if (index != NSNotFound) {
        return [self circularObjectAtIndex:index-1];
    }
    return nil;
}

- (id) circularNextObject: (NSObject *)object
{
    NSUInteger index = [self indexOfObject:object];
    if (index != NSNotFound) {
        return [self circularObjectAtIndex:index+1];
    }
    return nil;
}

@end
