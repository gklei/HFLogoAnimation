//
//  HFTextLayer.h
//  HFLogoAnimation
//
//  Created by Klein, Greg on 2/12/14.
//  Copyright (c) 2014 HardFlip. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface HFTextLayer : CALayer

+ (instancetype)textLayerWithLetter:(NSString *)letter;

@end
