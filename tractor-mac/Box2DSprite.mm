//
//  Box2DSprite.m
//  tractor-mac
//
//  Created by Michael Bass on 12/19/11.
//  Copyright (c) 2011 Macadamian. All rights reserved.
//

#import "Box2DSprite.h"

@implementation Box2DSprite

@synthesize sprite,body,layer;

-(id) initWithLayer:(CCLayer *) inputLayer andWorld:(b2World *) world {
    
    if (self = [super init]) {
        layer = inputLayer;
        
        sprite = nil;
        
        body = nil;
    }
    return self;
}


@end
