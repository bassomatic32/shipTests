//
//  Tracker.h
//  tractor-mac
//
//  Created by Michael Bass on 1/16/12.
//  Copyright 2012 Macadamian. All rights reserved.
//

#import "Box2DSprite.h"

@interface Tracker : Box2DSprite

-(id) initWithLayer:(CCLayer *)layer andWorld:(b2World *)world atPoint:(CGPoint) p;

-(id) track:(Box2DSprite *) object;

@end
