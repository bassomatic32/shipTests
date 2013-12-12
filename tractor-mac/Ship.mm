//
//  Ship.m
//  tractor-mac
//
//  Created by Michael Bass on 12/17/11.
//  Copyright (c) 2011 Macadamian. All rights reserved.
//

#import "Ship.h"
#import "SpaceScene.h"


@implementation Ship



-(id) initWithLayer:(CCLayer *)inputLayer andWorld:(b2World *)world {
    
    if (self = [super initWithLayer:inputLayer andWorld:world]) {
        
 
        
        // create triangle ship
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        
        bodyDef.position.Set(10, 10);
        bodyDef.angularDamping = 5.8f;
        bodyDef.linearDamping = 0.0f;
        
        
        body = world->CreateBody(&bodyDef);
        
        
        b2Vec2 vertices[3];
        
        vertices[0].Set(1.0f,0);        
        vertices[1].Set(-0.5f, 0.5f);
        vertices[2].Set(-0.5f, -0.5f);
        
        int32 count = 3;
        b2PolygonShape polygon;
        
        polygon.Set(vertices, count);
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &polygon;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.3f;
        fixtureDef.restitution = 0.7f;
        
        body->CreateFixture(&fixtureDef);
        body->SetUserData(self);
        
 
        
        
    }
    
    return self;
}

-(id) rotateCW {
    NSLog(@"rotate cw");
    body->ApplyAngularImpulse(-0.1f);
    
    return self;
}

-(id) rotateCCW {
    
    body->ApplyAngularImpulse(0.1f);
    return self;
}

-(id) thrust {
    b2Vec2 impulse;
    float32 thrustPower = 0.2f;
    float ix = cosf(body->GetAngle())*thrustPower;
    float iy = sinf(body->GetAngle())*thrustPower;
    impulse.Set(ix,iy);
    body->ApplyLinearImpulse(impulse, body->GetWorldCenter());
    
    thrust.angle = CC_RADIANS_TO_DEGREES(body->GetAngle())-180;
    
    thrust.position = CGPointMake( body->GetPosition().x * PTM_RATIO, body->GetPosition().y * PTM_RATIO);

    return self;
}

-(id) beginThrust {
    CCParticleSystem *emitter = [[CCParticleSystemQuad alloc] initWithTotalParticles:400];
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
    
    // duration
    //	emitter.duration = -1; //continuous effect
    emitter.duration = -1;
    
    // gravity
    emitter.gravity = CGPointZero;
    
    
    // angle
    emitter.angleVar = 5;
    
    // speed of particles
    emitter.speed = 500;
    emitter.speedVar = 30;
    
    // radial
    emitter.radialAccel = 0;
    emitter.radialAccelVar = 0;
    
    // tagential
    emitter.tangentialAccel = 0;
    emitter.tangentialAccelVar = 0;
    
    // life of particles
    emitter.life = 0;
    emitter.lifeVar = 0.675;
    
    // spin of particles
    emitter.startSpin = 0;
    emitter.startSpinVar = 0;
    emitter.endSpin = 0;
    emitter.endSpinVar = 0;
    
    // color of particles
    ccColor4F startColor = {0.31f, 0.09f, 0.0f, 1.0f};
    emitter.startColor = startColor;
    ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    emitter.startColorVar = startColorVar;
    ccColor4F endColor = {0.04f, 0.14f, 0.18f, 0.52f};
    emitter.endColor = endColor;
    ccColor4F endColorVar = {0.0f, 0.14f, 0.38f, 0.0f};
    emitter.endColorVar = endColorVar;
    
    // size, in pixels
    emitter.startSize = 15.0f;
    emitter.startSizeVar = 15.0f;
    emitter.endSize = 0;
    // emits per second
    emitter.emissionRate = emitter.totalParticles/emitter.life;
    // additive
    emitter.blendAdditive = YES;
    
    emitter.autoRemoveOnFinish = YES;
    emitter.position = CGPointMake( body->GetPosition().x * PTM_RATIO, body->GetPosition().y * PTM_RATIO);
    emitter.angle = CC_RADIANS_TO_DEGREES(body->GetAngle())-180;

    
    [layer addChild:emitter];
    
    [emitter release];
    
    thrust = emitter;    
    return self;
}

-(id) endThrust {
    thrust.duration = 0.0;
}


@end
