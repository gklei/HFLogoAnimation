//
//  HFTextLayer.m
//  HFLogoAnimation
//
//  Created by Klein, Greg on 2/12/14.
//  Copyright (c) 2014 HardFlip. All rights reserved.
//

#import "HFTextLayer.h"

static const CGFloat kTextFontSize = 50;

@interface HFTextLayer ()
@property (strong, nonatomic) NSString *letter;
@property (assign, nonatomic) CGFloat fontSize;
@end

@implementation HFTextLayer

+ (instancetype)textLayerWithLetter:(NSString *)letter
{
   HFTextLayer *textLayer = [HFTextLayer layer];
   textLayer.letter = letter;
   textLayer.fontSize = kTextFontSize;
   return textLayer;
}

- (void)drawInContext:(CGContextRef)ctx
{
   UIGraphicsPushContext(ctx);
   CGContextSetFillColorWithColor(ctx, [UIColor darkTextColor].CGColor);
   
   UIFont *font = [UIFont fontWithName:@"Courier" size:self.fontSize];
   
   NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
   paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
   paragraphStyle.alignment = NSTextAlignmentCenter;
   
   NSDictionary *attributes = @{NSFontAttributeName:font,
                                NSParagraphStyleAttributeName:paragraphStyle};
   
   [self.letter drawInRect:self.bounds withAttributes:attributes];
   UIGraphicsPopContext();
}

@end
