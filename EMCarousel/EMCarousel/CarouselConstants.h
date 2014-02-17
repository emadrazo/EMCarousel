//
//  CarouselConstants.h
//  Carousel
//
//  Created by Eva Madrazo on 6/12/10.
//  Copyright 2014 Eva Madrazo. All rights reserved.
//


//Logs
#define DBCarousel 1
#if DBCarousel
#define DBLog( s, ... ) NSLog( @"[%@ (%d) %@] %@", NSStringFromClass([self class]), __LINE__, NSStringFromSelector(_cmd), [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DBLog( s, ... )
#endif







