//
//  Shot.m
//  tractor-mac
//
//  Created by Michael Bass on 12/20/11.
//  Copyright (c) 2011 Macadamian. All rights reserved.
//

#import "Shot.h"

#define SHOT_LIFESPAN_SEC  3

@implementation Shot

-(id) initWithLayer:(CCLayer *)layer andWorld:(b2World *)world fromShip:(Ship *)ship {
    
    if (self = [super initWithLayer:layer andWorld:world]) {
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        
        
        CGPoint p;
        
        p.x = ship.body->GetPosition().x;
        p.y = ship.body->GetPosition().y;
        
        bodyDef.position.Set(p.x, p.y);
        bodyDef.bullet = YES;
        bodyDef.linearVelocity = ship.body->GetLinearVelocityFromLocalPoint(ship.body->GetLocalCenter());
        
        
        
        body = world->CreateBody(&bodyDef);    
        body->SetUserData(self);
        
        b2CircleShape circle;
        circle.m_radius = 0.1f;
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &circle;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.3f;
        fixtureDef.restitution = 0.7f;
        fixtureDef.isSensor = NO;
        
        body->CreateFixture(&fixtureDef);
        
        
        float32 shipsAngle = ship.body->GetAngle();
        
        b2Vec2 shotVector;
        shotVector.x = cosf(shipsAngle);
        shotVector.y = sinf(shipsAngle);
        shotVector.Normalize();
        shotVector = 2.0 * shotVector;
        
        
        
        body->ApplyLinearImpulse(shotVector, body->GetWorldCenter());
        
        startTime = time(NULL);
    }
    return self;
    
}

-(BOOL) dead {
    if ((time(NULL) - startTime) > SHOT_LIFESPAN_SEC) 
        return YES;
    return NO;
}




@end
