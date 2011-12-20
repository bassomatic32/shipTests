//
//  Box2DSprite.h
//  tractor-mac
//
//  Created by Michael Bass on 12/19/11.
//  Copyright (c) 2011 Macadamian. All rights reserved.
//


#import "cocos2d.h"
#import "Box2D.h"

@interface Box2DSprite : NSObject {
    CCSprite *sprite;
    b2Body *body;
    
    CCLayer *layer;
}

-(id) initWithLayer:(CCLayer *) layer andWorld:(b2World *) world;


@property (readonly) CCSprite *sprite;
@property (readonly) b2Body *body;
@property (readonly) CCLayer *layer;

@end
