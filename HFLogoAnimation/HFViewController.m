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
   self.dLayer.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3].CGColor;
   self.pLayer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:.3].CGColor;

   [self drawPath:[self hardFlipDrawingPath]];
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

   self.letterContainerLayer.position = CGPointMake(CGRectGetMidY(self.view.frame) + 25,
                                          CGRectGetMidX(self.view.frame) + 25);

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
- (UIBezierPath *)hardFlipDrawingPath
{
   CGFloat letterWidth = CGRectGetWidth(self.dLayer.bounds);
   CGPoint dLayerPosition = CGPointMake(self.letterContainerLayer.position.x - letterWidth,
                                        self.letterContainerLayer.position.y - 25);
   CGPoint pLayerPosition = CGPointMake(self.letterContainerLayer.position.x +
                                        (CGRectGetWidth(self.dLayer.bounds) * 4 - letterWidth),
                                        self.letterContainerLayer.position.y - 25);

   CGFloat controlX = pLayerPosition.x - (dLayerPosition.x * .5);
   CGFloat controlY = pLayerPosition.y - 100;
   CGPoint controlPoint = CGPointMake(controlX, controlY);

   UIBezierPath *flipArc = [UIBezierPath bezierPath];
   [flipArc moveToPoint:dLayerPosition];
   [flipArc addQuadCurveToPoint:pLayerPosition controlPoint:controlPoint];

   return flipArc;
}

- (UIBezierPath *)hardFlipAnimationPath
{
   CGFloat letterWidth = CGRectGetWidth(self.dLayer.bounds);
   CGPoint dLayerPosition = CGPointMake(self.letterContainerLayer.position.x - (letterWidth * .5) - 134,
                                        self.letterContainerLayer.position.y - 184);
   CGPoint pLayerPosition = CGPointMake(self.letterContainerLayer.position.x +
                                        (CGRectGetWidth(self.dLayer.bounds) * 4 - (letterWidth * .5)) - 134,
                                        self.letterContainerLayer.position.y - 184);

   CGFloat controlX = pLayerPosition.x - (dLayerPosition.x * .5);
   CGFloat controlY = pLayerPosition.y - 100;
   CGPoint controlPoint = CGPointMake(controlX, controlY);

   UIBezierPath *flipArc = [UIBezierPath bezierPath];
   [flipArc moveToPoint:dLayerPosition];
   [flipArc addQuadCurveToPoint:pLayerPosition controlPoint:controlPoint];

   return flipArc;
}

- (void)drawPath:(UIBezierPath *)path
{
   // Still need to figure out how to work with the desired coordinate space in landscape mode,
   // and how to utilize the convertToPoint to/from layer methods that CALayer provides

   CAShapeLayer *layer = [CAShapeLayer layer];
   layer.path = path.CGPath;
   layer.strokeColor = [UIColor blackColor].CGColor;
   layer.fillColor = nil;
   layer.lineWidth = 1.0;

   [self.view.layer addSublayer:layer];
}

#pragma mark - IBActions
- (IBAction)animate:(id)sender
{
   CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
   pathAnimation.calculationMode = kCAAnimationPaced;
   pathAnimation.fillMode = kCAFillModeForwards;
   pathAnimation.removedOnCompletion = NO;
   pathAnimation.duration = 3;
   pathAnimation.path = [self hardFlipAnimationPath].CGPath;

   CABasicAnimation *spin =
   [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
   spin.toValue = @(M_PI);
   spin.duration = 1.0;
   spin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
   spin.removedOnCompletion = NO;

   CAAnimationGroup *group = [CAAnimationGroup animation];
   group.fillMode = kCAFillModeForwards;
   group.removedOnCompletion = NO;
   group.animations = @[pathAnimation, spin];
   group.duration = 3;

   [self.dLayer addAnimation:group forKey:@"groupAnimation"];

   CATransform3D current = self.dLayer.transform;
   self.dLayer.transform = CATransform3DRotate(current, M_PI, 0, 0, 1);
}

@end
