//
//  EMViewController.m
//  EMCarousel
//
//  Created by Eva Madrazo on 2/10/14.
//  Copyright (c) 2014 Eva Madrazo. All rights reserved.
//

#import "DemoViewController.h"
#import "CarouselView.h"
#import "DemoCarouselItem.h"

@interface DemoViewController ()<EMCarouselSelectionProtocol>
{
    CarouselView *carouselView;
}
@end

@implementation DemoViewController

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
    [carouselView addItem:[UIImage imageNamed:@"castle.jpg"] withTitle:@"TWO"];
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"THREE"];
    [carouselView addItem:[UIImage imageNamed:@"fageda.jpg"] withTitle:@"FOUR"];
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"FIVE"];
    [carouselView addItem:[UIImage imageNamed:@"lily.jpg"] withTitle:@"SIX"];
    [carouselView addItem:[UIImage imageNamed:@"sample.png"] withTitle:@"SEVEN"];

    
    /*DemoCarouselItem *item =[[NSBundle mainBundle] loadNibNamed:@"DemoCarouselItem" owner:self options:nil][0];
    item.titleLabel.text = @"EIGHT";
    [carouselView addItem:item];
      */
    [carouselView setSelectionDelegate:self];
    //[carouselView setOpaque:NO];
    

    [self.view addSubview:carouselView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10.0, self.view.frame.size.height- 60.0, self.view.frame.size.width - 20.0, 50.0);
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"Add item" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addNewRandomItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
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


#pragma mark - test action
- (IBAction)addNewRandomItem:(id)sender{
    if (carouselView) {
        [carouselView addItem:[UIImage imageNamed:@"lily.jpg"] withTitle:@"SIX"];
    }
    
}

@end
