//
//  HFViewController.m
//  HFLogoAnimation
//
//  Created by Klein, Greg on 2/12/14.
//  Copyright (c) 2014 HardFlip. All rights reserved.
//

#import "HFViewController.h"
#import "HFTextLayer.h"

@interface HFViewController ()
@property (strong, nonatomic) HFTextLayer *hLayer;
@end

@implementation HFViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
   [self setupTextLayers];
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods
- (void)setupTextLayers
{
   self.hLayer = [HFTextLayer textLayerWithLetter:@"H"];
   self.hLayer.bounds = CGRectMake(0, 0, 50, 50);
   self.hLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds),
                                CGRectGetMidY(self.view.bounds));
   
   self.hLayer.backgroundColor = [UIColor colorWithRed:.9 green:0 blue:.8 alpha:.5].CGColor;
   
   
   [self.view.layer addSublayer:self.hLayer];
   [self.hLayer setNeedsDisplay];
}

- (IBAction)animate:(id)sender
{
   self.hLayer.position = CGPointMake(self.hLayer.position.x + 10,
                                      self.hLayer.position.y);
}

@end
