//
//  CarouselItem.h
//  Carousel
//
//  Created by Eva Madrazo on 6/12/10.
//  Copyright 2014 Eva Madrazo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CarouselItem :  UIView 

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property CGFloat angle;


@end
