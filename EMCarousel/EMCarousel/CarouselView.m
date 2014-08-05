//
//  CarouselView.m
//  Carousel
//
//  Created by Eva Madrazo on 6/12/10.
//  Copyright 2014 Eva Madrazo. All rights reserved.
//

#import "CarouselView.h"
#import "CarouselItem.h"
#import "CarouselConstants.h"
#import "Math.h"

#import <QuartzCore/QuartzCore.h>

#import "NSArray+Circular.h"


@interface CarouselView ()
{
    //constants
    CGFloat inclinationAngle;
    CGFloat backItemAlpha;
    BOOL centerSelectedItem;
    
    //
    int		selectedIndex;
	
	NSMutableArray	*carouselItems;
	
	CGFloat startPosition;
	
	Boolean isSingleTap;
	Boolean isDoubleTap;
	
	Boolean isRightMove;
	Boolean isLeftMove;
	
    
    CGFloat separationAngle;
    CGFloat radius;
}
	
- (void) setUpInitialState:(CGRect)aFrame ;
- (void) moveCarousel:(CGFloat) angleOffset;
- (CarouselItem *) findItemOnscreen:(CALayer *)targetLayer;
- (CarouselItem *) getSelectedItem;
- (void) refreshItemsPositionWithAnimated:(BOOL) animated;
- (void) logCarouselItems;
@end


@implementation CarouselView

NSDate *startingTime;
#pragma mark - cycle life methods
- (id)initWithFrame:(CGRect)aFrame {
	if ((self = [super initWithFrame:aFrame])) {
		[self setFrame:aFrame];
		[self setUpInitialState:aFrame];
	}
	
	return self;
}

-(void) setUpInitialState:(CGRect)aFrame  {

    //setup constants
    inclinationAngle = -0.1;
    backItemAlpha = 0.7;
    centerSelectedItem = YES;

	//carouselItems never will be nil
	carouselItems = [NSMutableArray array];
	
	self.multipleTouchEnabled = NO;
	self.userInteractionEnabled = YES;
	self.autoresizesSubviews = YES;
	self.layer.position=CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	
	[self setFrame:aFrame];
	[self setBounds:self.frame];
	[self setClipsToBounds:YES];
	
	selectedIndex=-1;
    separationAngle = 0;
}

- (void)setAntialiasing:(BOOL)flag
{
	CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(),flag);
	CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), flag);
}


#pragma mark - add item methods
- (CarouselItem *) addItem:(UIImage *)image withTitle:(NSString *)aTitle{
	DBLog(@"%@ addItem", [self class]);
	if (!image){
		DBLog(@"%@ nil Image", [self class]);
	}
    
    //create carousel item
    CarouselItem *item = [[NSBundle mainBundle] loadNibNamed:@"CarouselItem" owner:self options:nil][0];
    item.imageView.image = image;
    item.imageView.clipsToBounds = YES;
    [item.imageView.layer setEdgeAntialiasingMask:(kCALayerLeftEdge|kCALayerRightEdge|kCALayerBottomEdge|kCALayerTopEdge)];
    
    [item.titleLabel setFont:[UIFont fontWithName:@"helvetica" size:30.0]];
    [item.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [item.titleLabel setText:aTitle];
    
    if(selectedIndex == -1){
        //first item added
        selectedIndex = 0;
    }

    
    //New item added in main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.layer insertSublayer:item.layer atIndex:[carouselItems count]];
        // place the carousel just in the middle of the view
        [item.layer setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) ];
        
        
        [carouselItems addObject:item];
        
        [self refreshItemsPositionWithAnimated:YES];
        
    });
    
    return item;
    
}


- (void) addItem:(CarouselItem *)item{
	DBLog(@"%@ addItem", [self class]);
	if (!item){
		DBLog(@"%@ nil item", [self class]);
        return;
	}

	if(selectedIndex == -1){
        //first item added
		selectedIndex = 0;
	}
	
    //New item added in main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.layer insertSublayer:item.layer atIndex:[carouselItems count]];
        // place the carousel just in the middle of the view
        [item.layer setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) ];
        
        [carouselItems addObject:item];
        
        [self refreshItemsPositionWithAnimated:YES];
    });
}

- (void) removeItem:(CarouselItem *)item{
    DBLog(@"%@ removeItem", [self class]);
	if (!item){
		DBLog(@"%@ nil item", [self class]);
        return;
	}
    
		
    //Item removed in main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        [item.layer removeFromSuperlayer];
        [carouselItems removeObject:item];
        [self refreshItemsPositionWithAnimated:YES];
    });


}

- (CarouselItem *)getItemAtIndex:(NSInteger)index{
    DBLog(@"getItemAtIndex %i", index);
    if (!carouselItems || [carouselItems count] == 0) {
        return nil;
    }
    
    return [carouselItems circularObjectAtIndex:index];
}

/** returns current items
 */
- (NSArray *) getItems{
    return carouselItems;
}


///when an item is added  radius and separationAngle must change  and all the items have to be redrawn
- (void) refreshItemsPositionWithAnimated:(BOOL) animated {
    if (!carouselItems || [carouselItems count] == 0) {
        return;
    }
    
    int numberOfImages = [carouselItems count];
    UIView *itemView = (UIView *)[carouselItems objectAtIndex:0];
    radius = (itemView.bounds.size.width/2 ) /  tan((M_PI/ numberOfImages));
 //WARNING  itemView.frame.size.width depends on the position of view, we must use the bounds property...
    
    separationAngle = (2*M_PI) / numberOfImages;
    DBLog(@"width: %f radius %f angle %f    --- %f", itemView.frame.size.width, radius,separationAngle, separationAngle * numberOfImages);
                                                        

    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    CGFloat angle = 0.0;
    for (CarouselItem *item in carouselItems) {
        [item setAngle:angle];
        [item.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [item.layer setAnchorPointZ:-radius];
		item.layer.transform = CATransform3DMakeRotation(item.angle, 0, 1, 0);
        item.layer.transform = CATransform3DConcat(item.layer.transform, CATransform3DMakeRotation(inclinationAngle, 1, 0, 0));
        
        if (angle > M_PI/2 && angle< (1.5 * M_PI)) {
			item.alpha = backItemAlpha;
		} else {
			item.alpha = 1;
		}
        
        
        angle += separationAngle;
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
}


#pragma mark - touch methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint startPoint = [[touches anyObject] locationInView:self];
	startPosition = startPoint.x  ;
	startingTime = [[NSDate alloc] init];
	
	UITouch *touch= [touches anyObject];
	
	isSingleTap = ([touch tapCount] == 1);
	isDoubleTap = ([touch tapCount] > 1);
	
	isRightMove=NO;
	isLeftMove=NO;
	

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	isSingleTap = NO;
	isDoubleTap = NO;
	
	if (startingTime) {
		NSDate *now = [NSDate date];

		if (fabs ([now timeIntervalSinceDate:startingTime])>0.5) {
			//isSlowMovement = YES;
		}
	}
	
	CGPoint movedPoint = [[touches anyObject] locationInView:self];
	CGFloat offset = startPosition - movedPoint.x ;
	

    // we need to convert offset to radian angle because carousel moves radians
    CGFloat offsetToMove = - atan(offset / radius) ;
	
	startPosition = movedPoint.x ;
	
	if (offset>0) {
		isRightMove=YES;
		isLeftMove=NO;
	} else {
		isLeftMove=YES;
		isRightMove=NO;
	}
	
	[self moveCarousel:offsetToMove];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	DBLog(@"Touches ended");
	
	if (startingTime) {
		NSDate *now = [[NSDate alloc] init];
		DBLog(@"%@ movement time %f", [self class], fabs ([now timeIntervalSinceDate:startingTime]));
		
		if (fabs ([now timeIntervalSinceDate:startingTime])>0.5) {
			//isSlowMovement = YES;
		}
	}
	
	if (isSingleTap) {
		// Which item did the user tap? move carousel to center that item
		CGPoint targetPoint = [[touches anyObject] locationInView:self];
		CALayer *targetLayer = (CALayer *)[self.layer hitTest:targetPoint];
		CarouselItem *targetItem = [self findItemOnscreen:targetLayer];
		
		if (targetItem !=nil) {
			DBLog(@" single tap on item %@", targetItem);
			[self setSelectedItemAndCenter: targetItem];
		}
		
	} else if (isDoubleTap){
	
		//SELECT directly item that user taps
		CGPoint targetPoint = [[touches anyObject] locationInView:self];
		CALayer *targetLayer = (CALayer *)[self.layer hitTest:targetPoint];
		CarouselItem *targetItem = [self findItemOnscreen:targetLayer];

		if (targetItem !=nil && self.selectionDelegate!=nil){
			//[self setSelectedItemAndCenter: targetItem.number];
			DBLog(@" double tap on item %@", targetItem);
			[self.selectionDelegate carousel:self itemSelected:targetItem];
		} 

		
		
	} else {
		if (centerSelectedItem) {

            // center the item nearest to 0 angle.
			CarouselItem *selectedItem=[self getSelectedItem];

            [self setSelectedItemAndCenter: selectedItem];
            
            //TODO Future feature, if it is not a slow movement launch the carousel to rotate
		}
	}
	
	isRightMove=NO;
	isLeftMove=NO;

	isSingleTap = NO;
	isDoubleTap = NO;
	
	//isSlowMovement = NO;
}

#pragma mark - selection, move and find methods

- (void)setSelectedItemAndCenter:(CarouselItem *)newSelectedItem{
	DBLog(@"%@ setSelectedItemAndCenter %@", [self class], newSelectedItem);
    
    //Select the correct rotation way
    if (newSelectedItem.angle >= M_PI) {
        newSelectedItem.angle = newSelectedItem.angle -(2*M_PI);
    }
    
	[self moveCarousel:-newSelectedItem.angle];
}

- (CarouselItem *)findItemOnscreen:(CALayer *)targetLayer {
	CarouselItem * foundItem = nil;
	
	@try {
		
		for (int h=0 ; h<[carouselItems count]; h++){
			CarouselItem *aItem = (CarouselItem *)[carouselItems circularObjectAtIndex:h];
			
			for (int i=0; i<[[aItem subviews] count]; i++) {
				UIView *subview = [[aItem subviews] objectAtIndex:i];
				
				if ([[subview layer] isEqual:targetLayer]) {
					foundItem = aItem;
					 DBLog(@"%@ foundItemOnscreen ", [self class]);
					break;
				}
				
				for (int j=0; j<[[subview subviews] count]; j++) {
					UIView *subSubview = [[subview subviews] objectAtIndex:j];
					if ([[subSubview layer] isEqual:targetLayer]) {
						foundItem = aItem;
						DBLog(@"%@ foundItemOnscreen ", [self class]);
						break;
					}
				}
			}
		}
	}
	@catch (NSException * e) {
		DBLog(@"---ERROR");
		
	}
	
	
	return foundItem;
}

- (void) moveCarousel:(CGFloat) angleOffset{
	   
    [self logCarouselItems];
    
	if (fabs(angleOffset) == 0.0f) return;
    
    DBLog(@"moving carousel: %f", angleOffset);
    
    
    CGFloat itemsMoved = fabs(angleOffset / separationAngle);
    
    
    DBLog(@"items Moved: %f", itemsMoved);
    
	for (int i=0; i<[carouselItems count]; i++) {
		CarouselItem *aItem = (CarouselItem *)[carouselItems circularObjectAtIndex:i];
		[aItem setAngle:(aItem.angle + angleOffset)];


        [UIView animateWithDuration:(0.2 * itemsMoved) delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState animations:^{
            aItem.layer.transform = CATransform3DConcat( CATransform3DMakeRotation (angleOffset, 0, 1, 0), aItem.layer.transform);
            
            if (aItem.angle > M_PI/2 && aItem.angle < (1.5 * M_PI)) {
                aItem.alpha = backItemAlpha;
            } else {
                aItem.alpha = 1;
            }

        } completion:^(BOOL finished){
            // reorder angles.
            while (aItem.angle>(2*M_PI)) {
             aItem.angle = aItem.angle - (2*M_PI);
             }
             
             while (aItem.angle < 0) {
             aItem.angle = aItem.angle + (2*M_PI);
             }
            
            [self logCarouselItems];
        }];
	}
}

/// return selected item
- (CarouselItem *) getSelectedItem {
	DBLog(@"%@ getSelectedItem", [self class]);

	if(!carouselItems)
    {
        return nil;
    }
	
	float minimumAngle=M_PI;
	CarouselItem *selected = nil;
	
	for (int i=0; i<[carouselItems count]; i++) {
		CarouselItem *aItem = (CarouselItem *)[carouselItems circularObjectAtIndex:i];
		float angle= aItem.angle;
		angle=abs(angle);
		
		while (angle>(2*M_PI) ) {
			angle=angle-(2*M_PI);
		}
		
		if (angle<minimumAngle) {
			minimumAngle = angle;
			selected = aItem;
		}
	}
	
	return selected;
}

#pragma mark - set constants methods
- (void) setCarouselInclination: (CGFloat) angle{
    inclinationAngle = angle;
}

- (void) setBackItemAlpha: (CGFloat) alpha{
    if (alpha>=0 && alpha<=1) {
        backItemAlpha = alpha;
    } else {
        DBLog(@"---ERROR: alpha value should be between 0 and 1");
    }
}

- (void) shouldCenterSelectedItem: (BOOL)center {
    centerSelectedItem = center;
}

#pragma mark - log methods
- (void) logCarouselItems {
    return;
    
    DBLog(@"------------------");
    for (CarouselItem *item in carouselItems ) {
        DBLog(@"item %@: %f", item.titleLabel.text, item.angle);
    }
    DBLog(@"------------------");
}

@end
