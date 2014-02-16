//
//  HFViewController.m
//  HFLogoAnimation
//
//  Created by Klein, Greg on 2/12/14.
//  Copyright (c) 2014 HardFlip. All rights reserved.
//

@import QuartzCore;
#import "HFViewController.h"

@interface HFViewController ()
@property (strong, nonatomic) NSArray *hardFlipLetters;
@property (strong, nonatomic) CALayer *letterContainerLayer;
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
   [self drawPath];
}

#pragma mark - Helper Methods
- (void)setupTextLayers
{
   self.letterContainerLayer = [CALayer layer];
   CGPoint previousPosition = CGPointZero;
   for (NSString *letter in self.hardFlipLetters)
   {

      CATextLayer *letterLayer = [self textLayerWithBounds:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)
                                                    string:letter];
      letterLayer.anchorPoint = CGPointZero;
      letterLayer.position = previousPosition;

      previousPosition = CGPointMake(letterLayer.position.x + CGRectGetWidth(letterLayer.bounds),
                                     letterLayer.position.y);

      [self.letterContainerLayer addSublayer:letterLayer];
      self.letterContainerLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.letterContainerLayer.bounds) +
                                          CGRectGetWidth(letterLayer.bounds),
                                          CGRectGetHeight(letterLayer.bounds));

      if ([letter isEqualToString:@"d"])
         self.dLayer = letterLayer;
      else if ([letter isEqualToString:@"p"])
         self.pLayer = letterLayer;
   }

   self.letterContainerLayer.backgroundColor = [UIColor colorWithRed:1 green:0 blue:.2 alpha:.5].CGColor;
   self.letterContainerLayer.position = CGPointMake(CGRectGetMidY(self.view.frame),
                                          CGRectGetMidX(self.view.frame));

   [self.view.layer addSublayer:self.letterContainerLayer];
}

- (CATextLayer *)textLayerWithBounds:(CGRect)bounds string:(NSString *)string
{
   CATextLayer *textLayer = [CATextLayer layer];
   textLayer.bounds = bounds;
   textLayer.foregroundColor = [UIColor blackColor].CGColor;
   textLayer.font = (__bridge CFTypeRef)([UIFont boldSystemFontOfSize:14].fontName);
   textLayer.alignmentMode = @"center";
   textLayer.string = string;

   return textLayer;
}

#pragma mark - Drawing Methods
- (void)drawPath
{
   CGPoint dLayerPosition = CGPointMake(self.letterContainerLayer.position.x - 25,
                                        self.letterContainerLayer.position.y);
   CGPoint pLayerPosition = CGPointMake(self.letterContainerLayer.position.x + (CGRectGetWidth(self.dLayer.bounds) * 4 - 25),
                                        self.letterContainerLayer.position.y);

   CGFloat controlX = pLayerPosition.x - (dLayerPosition.x * .5);
   CGFloat controlY = pLayerPosition.y - 100;
   CGPoint controlPoint = CGPointMake(controlX, controlY);

   UIBezierPath *flipArc = [UIBezierPath bezierPath];
   [flipArc moveToPoint:dLayerPosition];
   [flipArc addQuadCurveToPoint:pLayerPosition controlPoint:controlPoint];

   CAShapeLayer *layer = [CAShapeLayer layer];
   layer.path = flipArc.CGPath;
   layer.strokeColor = [UIColor blackColor].CGColor;
   layer.fillColor = nil;
   layer.lineWidth = 1.0;

   [self.view.layer addSublayer:layer];
}

#pragma mark - IBActions
- (IBAction)animate:(id)sender
{
}

@end
