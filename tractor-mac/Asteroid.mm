//
//  Asteroid.m
//  tractor-mac
//
//  Created by Michael Bass on 12/20/11.
//  Copyright (c) 2011 Macadamian. All rights reserved.
//

#import "SpaceScene.h"
#import "Asteroid.h"

@implementation Asteroid

@synthesize scale = _scale;

-(id) initWithLayer:(CCLayer *)layer andWorld:(b2World *)world withScale:(int)scale {
    
    const float32 sizes[] = { 0.5f,1.0f,3.0f,5.0f };
    
    if (self = [super initWithLayer:layer andWorld:world]) {
        
        _scale = scale;
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CGPoint p;
        
        p.x = CCRANDOM_0_1()*screenSize.width;
        p.y = CCRANDOM_0_1()*screenSize.height;
        
        bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
        
        
        
        body = world->CreateBody(&bodyDef);    
        body->SetUserData(self);
        
        b2CircleShape circle;
        circle.m_radius = sizes[scale];
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &circle;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.3f;
        fixtureDef.restitution = 0.7f;
        fixtureDef.isSensor = NO;
        
        body->CreateFixture(&fixtureDef);
        body->ApplyTorque(CCRANDOM_MINUS1_1()*50000.0f);
        
        b2Vec2 force;
        force.x = CCRANDOM_MINUS1_1();
        force.y = CCRANDOM_MINUS1_1();
        force = (CCRANDOM_0_1() * 10000.0f) * force;
        body->ApplyForceToCenter(force);
        
        
    }
    
    return self;
}


-(NSArray *) split {
    NSMutableArray *children = [[[NSMutableArray alloc] init] autorelease];
    if (_scale > 0) {
        int numChildren = CCRANDOM_0_1()*3 + 1;
        for (int i = 0; i < numChildren; i++) {
            Asteroid *a = [[[Asteroid alloc] initWithLayer:layer andWorld:body->GetWorld() withScale:_scale-1] autorelease];
            a.body->SetTransform(body->GetPosition(), 0);
            [children addObject:a];
        }
    }
    
    return children;
}


@end
