//
//  CarouselView.h
//  Carousel
//
//  Created by Eva Madrazo on 6/12/10.
//  Copyright 2014 Eva Madrazo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class CarouselItem;
@class CarouselView;


@protocol EMCarouselSelectionProtocol <NSObject>

@required
/** This method is called when an item is selected in carousel
 
 @param carousel the carousel in which item has been selected
 @param item the item selected in carousel
 */
-(void)carousel:(CarouselView *)carousel itemSelected:(CarouselItem *)item;
@end


@interface CarouselView :  UIView 

@property (nonatomic, unsafe_unretained) id <EMCarouselSelectionProtocol> selectionDelegate;

/** Call this method to select programatically one item and visually center it

 @tparam item the item to select in carousel
 */
- (void) setSelectedItemAndCenter:(CarouselItem *)item;

/** Quickly add a new item in carousel
 @param image the background image for item
 @param title the title for item
 @return item added
 */
- (CarouselItem *) addItem:(UIImage *)image withTitle:(NSString *)title;

/** Add a new item in carousel. CarouselItem can be extended in order to change the look&feel of the items
 
 @param item an object extending CarouselItem to add in carousel

 */
- (void) addItem:(CarouselItem *)item;

/** Remove item from carousel.
 
 @param item an object extending CarouselItem to remove from carousel
 
 */
- (void) removeItem:(CarouselItem *)item;


/** Set carousel inclination. This allows the user see the back of the carousel.
 
 @param angle angle in radians for inclination
 @default default value is -0.1
 */
- (void) setCarouselInclination: (CGFloat) angle;

/** Set alpha value for carousel back items.
 
 @param alpha alpha value for back items. Value should be between 0 and 1.
 @default default value is 0.7
 */
- (void) setBackItemAlpha: (CGFloat) alpha;

/** When set, carousel will center the selected item in screen.
 
 @param shouldCenter boolean value
 @default default value is YES
 */
- (void) shouldCenterSelectedItem: (BOOL)shouldCenter;

/** returns item at position index
 @param index
 */
- (CarouselItem *)getItemAtIndex:(NSInteger)index;

/** returns current items
 */
- (NSArray *) getItems;

@end
