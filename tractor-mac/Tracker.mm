//
//  Tracker.m
//  tractor-mac
//
//  Created by Michael Bass on 1/16/12.
//  Copyright 2012 Macadamian. All rights reserved.
//

#import "Tracker.h"
#import "SpaceScene.h"

@implementation Tracker

-(id) initWithLayer:(CCLayer *)layer andWorld:(b2World *)world atPoint:(CGPoint)p{
    if (self == [super initWithLayer:layer andWorld:world]) {
        // Define the dynamic body.
        //Set up a 1m squared box in the physics world
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        
        bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
        
        body = world->CreateBody(&bodyDef);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box

        CCParticleSystem *emitter = [[CCParticleSystemQuad alloc] initWithTotalParticles:400];
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;	
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 0.3f;
        fixtureDef.restitution = 0.7f;
        fixtureDef.userData = emitter;
        
        body->CreateFixture(&fixtureDef);
        body->SetUserData(self);
        
        
        emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
        
        // duration
        //	emitter.duration = -1; //continuous effect
        emitter.duration = -1;
        
        // gravity
        emitter.gravity = CGPointZero;
        
        
        // angle
        emitter.angle = 357;
        emitter.angleVar = 190;
        
        // speed of particles
        emitter.speed = 0;
        emitter.speedVar = 19.3;
        
        // radial
        emitter.radialAccel = 300;
        emitter.radialAccelVar = 0;
        
        // tagential
        emitter.tangentialAccel = 300;
        emitter.tangentialAccelVar = 0;
        
        // life of particles
        emitter.life = 0;
        emitter.lifeVar = 0.75;
        
        // spin of particles
        emitter.startSpin = 0;
        emitter.startSpinVar = 0;
        emitter.endSpin = 0;
        emitter.endSpinVar = 0;
        
        // color of particles
        ccColor4F startColor = {0.32, 0.39, 0.58f, 0.7f};
        emitter.startColor = startColor;
        ccColor4F startColorVar = {0.3f, 0.3f, 0.3f, 0.0f};
        emitter.startColorVar = startColorVar;
        ccColor4F endColor = {0.99f, 0.99f, 1.0f, 0.99f};
        emitter.endColor = endColor;
        ccColor4F endColorVar = {0.0f, 0.00f, 0.0f, 0.00f};
        emitter.endColorVar = endColorVar;
        
        // size, in pixels
        emitter.startSize = 0.0f;
        emitter.startSizeVar = 10.0f;
        emitter.endSize = 11;
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

-(id) track:(Box2DSprite *)object {
    
    b2Body *g = object.body;
    b2Body *b = self.body;
    
    
   
    b2Vec2 center = g->GetPosition();
    
    b2Vec2 position = b->GetPosition();
    
    b2Vec2 d = center - position;
    float32 gf = 10.0f * b->GetMass();
    

    
    d.Normalize();
    b2Vec2 F = gf * d;
    b->ApplyForce(F, position);
    
    return self;
}

@end
