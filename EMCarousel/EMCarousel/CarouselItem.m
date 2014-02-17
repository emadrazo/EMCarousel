//
//  CarouselItem.m
//  Carousel
//
//  Created by Eva Madrazo on 6/12/10.
//  Copyright 2014 Eva Madrazo. All rights reserved.
//

#import "CarouselItem.h"
#import "CarouselConstants.h"


@implementation CarouselItem

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
		[self communSetup];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder])) {
		[self communSetup];
	}
	
	return self;
}

- (void) drawRect:(CGRect)rect { 
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, YES);
}

- (void) communSetup
{
    self.userInteractionEnabled = YES;
    
}

@end
