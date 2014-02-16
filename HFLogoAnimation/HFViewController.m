//
//  HFViewController.m
//  HFLogoAnimation
//
//  Created by Klein, Greg on 2/12/14.
//  Copyright (c) 2014 HardFlip. All rights reserved.
//

#import "HFViewController.h"

@interface HFViewController ()
@property (strong, nonatomic) NSArray *hardFlipLetters;
@property (strong, nonatomic) CATextLayer *dLayer;
@property (strong, nonatomic) CATextLayer *pLayer;
@end

@implementation HFViewController

#pragma mark - Overridden Methods
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
      CATextLayer *letterLayer = [CATextLayer layer];
      letterLayer.bounds = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
      letterLayer.string = letter;
      letterLayer.font = (__bridge CFTypeRef)([UIFont boldSystemFontOfSize:14].fontName);
      letterLayer.foregroundColor = [UIColor blackColor].CGColor;
      letterLayer.wrapped = NO;
      letterLayer.position = previousPosition;
      letterLayer.anchorPoint = CGPointZero;
      letterLayer.alignmentMode = @"center";

      [letterContainer addSublayer:letterLayer];
      letterContainer.bounds = CGRectMake(0, 0, CGRectGetWidth(letterContainer.bounds) +
                                          CGRectGetWidth(letterLayer.bounds),
                                          CGRectGetHeight(letterLayer.bounds));

      previousPosition = CGPointMake(letterLayer.position.x + CGRectGetWidth(letterLayer.bounds),
                                     letterLayer.position.y);

      if ([letter isEqualToString:@"d"])
         self.dLayer = letterLayer;
      else if ([letter isEqualToString:@"p"])
         self.pLayer = letterLayer;
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
