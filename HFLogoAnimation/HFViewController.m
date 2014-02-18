//
//  HFViewController.m
//  HFLogoAnimation
//
//  Created by Klein, Greg on 2/12/14.
//  Copyright (c) 2014 HardFlip. All rights reserved.
//

@import QuartzCore;
#import "HFViewController.h"

static const CGFloat s_arcHeight = 110.f;

@interface HFViewController ()
@property (strong, nonatomic) NSArray *hardFlipLetters;
@property (strong, nonatomic) CALayer *letterContainer;
@property (strong, nonatomic) CATextLayer *dLayer;
@property (strong, nonatomic) CATextLayer *dLayerCopy;
@property (strong, nonatomic) CATextLayer *pLayer;
@property (assign, nonatomic) BOOL animating;
@end

@implementation HFViewController

#pragma mark - Overridden Methods
- (void)viewDidLoad
{
   [super viewDidLoad];
   self.hardFlipLetters = @[@"H", @"a", @"r", @"d", @"F", @"l", @"i", @"p"];
}

- (void)viewDidLayoutSubviews
{
   [self setupTextLayersWithLetterWidth:50.f];
}

#pragma mark - Helper Methods
- (void)setupTextLayersWithLetterWidth:(CGFloat)width
{
   self.letterContainer = [CALayer layer];
   CGPoint previousPosition = CGPointZero;
   for (NSString *letter in self.hardFlipLetters)
   {

      CATextLayer *letterLayer = [self textLayerWithBounds:CGRectMake(0.0f, 0.0f, width, width)
                                                    string:letter];
      letterLayer.position = previousPosition;
      previousPosition = CGPointMake(letterLayer.position.x + CGRectGetWidth(letterLayer.bounds),
                                     letterLayer.position.y);

      [self.letterContainer addSublayer:letterLayer];
      self.letterContainer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.letterContainer.bounds) +
                                          CGRectGetWidth(letterLayer.bounds),
                                          CGRectGetHeight(letterLayer.bounds));

      if ([letter isEqualToString:@"d"])
         self.dLayer = letterLayer;
      else if ([letter isEqualToString:@"p"])
         self.pLayer = letterLayer;
   }

   self.letterContainer.position = CGPointMake(CGRectGetMidX(self.view.bounds) + 25,
                                               CGRectGetMidY(self.view.bounds) + 25);

   [self.view.layer addSublayer:self.letterContainer];
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
- (UIBezierPath *)hardflipDrawingPathWithArcHeight:(CGFloat)arcHeight
{
   CGPoint dLayerPosition = [self.view.layer convertPoint:self.dLayer.position
                                                fromLayer:self.letterContainer];
   CGPoint pLayerPosition = [self.view.layer convertPoint:self.pLayer.position
                                                fromLayer:self.letterContainer];

   CGFloat controlX = pLayerPosition.x - (dLayerPosition.x * .5);
   CGFloat controlY = pLayerPosition.y - arcHeight;
   CGPoint controlPoint = CGPointMake(controlX, controlY);

   UIBezierPath *flipArc = [UIBezierPath bezierPath];
   [flipArc moveToPoint:dLayerPosition];
   [flipArc addQuadCurveToPoint:pLayerPosition controlPoint:controlPoint];

   return flipArc;
}

- (UIBezierPath *)hardflipAnimationPathWithArcHeight:(CGFloat)arcHeight
{
   CGPoint dLayerPosition = [self.view.layer convertPoint:self.dLayer.position toLayer:self.view.layer];
   CGPoint pLayerPosition = [self.view.layer convertPoint:self.pLayer.position toLayer:self.view.layer];

   // hack to make the animation a little smoother:
   pLayerPosition = CGPointMake(pLayerPosition.x, pLayerPosition.y + 1);

   CGFloat controlX = pLayerPosition.x - (dLayerPosition.x * .5);
   CGFloat controlY = pLayerPosition.y - arcHeight;
   CGPoint controlPoint = CGPointMake(controlX, controlY);

   UIBezierPath *flipArc = [UIBezierPath bezierPath];
   [flipArc moveToPoint:dLayerPosition];
   [flipArc addQuadCurveToPoint:pLayerPosition controlPoint:controlPoint];

   return flipArc;
}

- (void)drawPath:(UIBezierPath *)path
{
   CAShapeLayer *layer = [CAShapeLayer layer];
   layer.path = path.CGPath;
   layer.strokeColor = [UIColor lightGrayColor].CGColor;
   layer.fillColor = nil;
   layer.lineWidth = 1.0;

   [self.view.layer insertSublayer:layer below:self.letterContainer];
}

- (CAAnimationGroup *)hardflipAnimationGroupWithDuration:(CFTimeInterval)duration
{
   CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
   pathAnimation.calculationMode = kCAAnimationPaced;
   pathAnimation.duration = duration;
   pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
   pathAnimation.path = [self hardflipAnimationPathWithArcHeight:s_arcHeight].CGPath;

   CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
   spin.toValue = @(M_PI);
   spin.duration = duration;
   spin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

   CABasicAnimation *spin2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
   spin2.toValue = @(M_PI * 2);
   spin2.duration = duration;
   spin2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

   CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
   scale.values = @[@(1), @(1.5), @(1)];
   scale.duration = duration;
   scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

   CAAnimationGroup *group = [CAAnimationGroup animation];
   group.fillMode = kCAFillModeForwards;
   group.animations = @[pathAnimation, spin, spin2, scale];
   group.duration = duration;

   return group;
}

- (void)runFadeInAnimationOnTextLayer:(CATextLayer *)textLayer
{
   CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
   fadeIn.fromValue = @(-.1);
   fadeIn.toValue = @(1);
   fadeIn.duration = 1.5;
   fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
   [textLayer addAnimation:fadeIn forKey:@"fadeIn"];
}

#pragma mark - IBActions
- (IBAction)animate:(id)sender
{
   if (self.animating)
      return;

   self.animating = YES;

   CAAnimationGroup *hardflipAnimation = [self hardflipAnimationGroupWithDuration:1.5];
   hardflipAnimation.delegate = self;

   self.dLayerCopy = [self textLayerWithBounds:CGRectMake(0, 0, 50, 50) string:@"d"];
   self.dLayerCopy.position = self.dLayer.position;

   [self.letterContainer addSublayer:self.dLayerCopy];
   [self.dLayerCopy addAnimation:hardflipAnimation forKey:@"hardflipAnimation"];

   [self runFadeInAnimationOnTextLayer:self.dLayer];
}

#pragma mark - Animation Callbacks
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
   [self.dLayerCopy removeFromSuperlayer];
   self.animating = NO;
}

@end
