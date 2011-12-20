//
//  GravityWell.h
//  tractor-mac
//
//  Created by Michael Bass on 12/19/11.
//  Copyright (c) 2011 Macadamian. All rights reserved.
//

#import "Box2DSprite.h"

@interface GravityWell : Box2DSprite

-(id) initWithLayer:(CCLayer *)layer andWorld:(b2World *)world atPos:(CGPoint) p;

@end
