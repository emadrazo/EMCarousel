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
    btn.frame = CGRectMake(0.0, self.view.frame.size.height- 105.0, self.view.frame.size.width, 30.0);
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"Add Item" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addNewRandomItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btnRemove = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnRemove.frame = CGRectMake(0.0, self.view.frame.size.height- 70.0, self.view.frame.size.width, 30.0);
    btnRemove.backgroundColor = [UIColor blackColor];
    [btnRemove setTitle:@"Remove Item" forState:UIControlStateNormal];
    [btnRemove setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRemove addTarget:self action:@selector(removeRandomItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRemove];
    
    UIButton *btnChange = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnChange.frame = CGRectMake(0.0, self.view.frame.size.height- 35.0, self.view.frame.size.width, 30.0);
    btnChange.backgroundColor = [UIColor blackColor];
    [btnChange setTitle:@"Select Random Item" forState:UIControlStateNormal];
    [btnChange setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChange addTarget:self action:@selector(changeToRandomItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnChange];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - @protocol EMCarouselSelectionProtocol <NSObject>
-(void)carousel:(CarouselView *)carousel itemSelected:(CarouselItem *)item{
    //item has been selected
    
    NSLog(@"item selected %@", item);
}


#pragma mark - test action
- (IBAction)addNewRandomItem:(id)sender{
    if (carouselView) {
        NSInteger randomIndex = (arc4random() %[[carouselView getItems] count]);
        [carouselView addItem:[UIImage imageNamed:@"lily.jpg"] withTitle:[NSString stringWithFormat:@"RANDOM - %d",randomIndex]];
    }
}

- (IBAction)removeRandomItem:(id)sender{
    if (carouselView) {
        NSInteger randomIndex = (arc4random() %[[carouselView getItems] count]);
        [carouselView  removeItem:[carouselView getItemAtIndex:randomIndex]];
    }
    
}

- (IBAction)changeToRandomItem:(id)sender{
    if (carouselView) {
        NSInteger randomIndex = (arc4random() %[[carouselView getItems] count]);
        [carouselView setSelectedItemAndCenter:[carouselView getItemAtIndex:randomIndex]];
    }
}

@end
