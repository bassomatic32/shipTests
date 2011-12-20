//
//  Ship.h
//  tractor-mac
//
//  Created by Michael Bass on 12/17/11.
//  Copyright (c) 2011 Macadamian. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Box2DSprite.h"

@interface Ship : Box2DSprite {


    CCParticleSystem *thrust;
    
}

-(id) initWithLayer:(CCLayer *) layer andWorld:(b2World *) world;

-(id) rotateCW;

-(id) rotateCCW;

-(id) thrust;

-(id) beginThrust;

-(id) endThrust;


@end
