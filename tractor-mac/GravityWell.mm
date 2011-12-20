//
//  GravityWell.m
//  tractor-mac
//
//  Created by Michael Bass on 12/19/11.
//  Copyright (c) 2011 Macadamian. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Box2DSprite.h"
#import "GravityWell.h"
#import "SpaceScene.h"

@implementation GravityWell 

-(id) initWithLayer:(CCLayer *)layer andWorld:(b2World *)world atPos:(CGPoint) p {
    if (self = [super initWithLayer:layer andWorld:world]) {
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;
    
        bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
        body = world->CreateBody(&bodyDef);    
        
        b2CircleShape circle;
        circle.m_radius = 1.0f;
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &circle;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.3f;
        fixtureDef.restitution = 0.7f;
        fixtureDef.isSensor = YES;
        
        body->CreateFixture(&fixtureDef);
        
        // setup emitter
        
        CCParticleSystem *emitter = [[CCParticleSystemQuad alloc] initWithTotalParticles:400];
        emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
        
        // duration
        //	emitter.duration = -1; //continuous effect
        emitter.duration = -1;
        
        // gravity
        emitter.gravity = CGPointZero;
        
        
        // angle
        emitter.angle = 11;
        emitter.angleVar = 12;
        
        // speed of particles
        emitter.speed = 83;
        emitter.speedVar = 157;
        
        // radial
        emitter.radialAccel = -380;
        emitter.radialAccelVar = 0;
        
        // tagential
        emitter.tangentialAccel = -144;
        emitter.tangentialAccelVar = 0;
        
        // life of particles
        emitter.life = 0;
        emitter.lifeVar = 2;
        
        // spin of particles
        emitter.startSpin = 0;
        emitter.startSpinVar = 0;
        emitter.endSpin = 0;
        emitter.endSpinVar = 0;
        
        // color of particles
        ccColor4F startColor = {0.0, 0.14, 1.0f, 0.7f};
        emitter.startColor = startColor;
        ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.57f};
        emitter.startColorVar = startColorVar;
        ccColor4F endColor = {0.34f, 0.5f, 1.0f, 0.38f};
        emitter.endColor = endColor;
        ccColor4F endColorVar = {0.1f, 0.02f, 0.3f, 0.01f};
        emitter.endColorVar = endColorVar;
        
        // size, in pixels
        emitter.startSize = 35.0f;
        emitter.startSizeVar = 29.0f;
        emitter.endSize = 0;
        // emits per second
        emitter.emissionRate = emitter.totalParticles/emitter.life;
        // additive
        emitter.blendAdditive = YES;
        
        emitter.autoRemoveOnFinish = YES;
        emitter.position = CGPointMake( body->GetPosition().x * PTM_RATIO, body->GetPosition().y * PTM_RATIO);
        emitter.angle = 11.0f;
        
        
        [layer addChild:emitter];


    }
    return self;
}

@end
