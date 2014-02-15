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
@property (strong, nonatomic) NSArray *hardFlipLetters;
@end

@implementation HFViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
   self.hardFlipLetters = @[@"H", @"a", @"r", @"d", @"F", @"l", @"i", @"p"];
   [self setupTextLayers];
}

#pragma mark - Helper Methods
- (void)setupTextLayers
{
   CALayer *letterContainer = [CALayer layer];
   CGPoint previousPosition = CGPointZero;
   for (NSString *letter in self.hardFlipLetters)
   {
      CALayer *letterLayer = [HFTextLayer textLayerWithLetter:letter];
      letterLayer.bounds = CGRectMake(0, 0, 50, 50);
      letterLayer.position = previousPosition;
      letterLayer.anchorPoint = CGPointZero;
      letterLayer.name = letter;
      letterContainer.bounds = CGRectMake(0, 0, CGRectGetWidth(letterContainer.bounds) +
                                          CGRectGetWidth(letterLayer.bounds),
                                          CGRectGetHeight(letterLayer.bounds));

      [letterContainer addSublayer:letterLayer];
      [letterLayer setNeedsDisplay];

      previousPosition = CGPointMake(letterLayer.position.x + CGRectGetWidth(letterLayer.bounds),
                                     letterLayer.position.y);
   }

   letterContainer.backgroundColor = [UIColor colorWithRed:1 green:0 blue:.2 alpha:.5].CGColor;
   letterContainer.position = CGPointMake(CGRectGetMidY(self.view.frame),
                                          CGRectGetMidX(self.view.frame));
   
   [self.view.layer addSublayer:letterContainer];
}

- (IBAction)animate:(id)sender
{
}

@end
