//
//  EMViewController.m
//  EMCarousel
//
//  Created by Eva Madrazo on 2/10/14.
//  Copyright (c) 2014 Eva Madrazo. All rights reserved.
//

#import "EMViewController.h"
#import "CarouselView.h"

@interface EMViewController ()<EMCarouselSelectionProtocol>
{
    CarouselView *carouselView;
}
@end

@implementation EMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //create an fill carousel
    carouselView = [[CarouselView alloc] initWithFrame:self.view.frame];
    [carouselView setCarouselInclination:-0.15];    //optional
    [carouselView setBackItemAlpha:0.8];            //optional
    [carouselView shouldCenterSelectedItem:YES];    //optional
    
        
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"ONE"];
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"TWO"];
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"THREE"];
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"FOUR"];
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"FIVE"];
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"SIX"];
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"SEVEN"];
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"EIGHT"];
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"NINE"];
        
    [carouselView setSelectionDelegate:self];
    //[carouselView setOpaque:NO];
    

    [self.view addSubview:carouselView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - @protocol EMCarouselSelectionProtocol <NSObject>
-(void)carousel:(CarouselView *)carousel itemSelected:(CarouselItem *)item{
    //item has been selected
}

@end
