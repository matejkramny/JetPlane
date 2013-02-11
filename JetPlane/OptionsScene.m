//
//  OptionsScene.m
//  JetPlane
//
//  Created by Matej Kramny on 10/02/2013.
//  Copyright 2013 Matej Kramny. All rights reserved.
//

#import "OptionsScene.h"
#import "GameScene.h"

@interface OptionsScene () {
	
}

- (void)goBack:(id)sender;

@end

@implementation OptionsScene

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	
	OptionsScene *layer = [OptionsScene node];
	
	[scene addChild:layer];
	
	return scene;
}

- (id)init {
	self = [super init];
	
	if (self) {
		// Init
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Options" fontName:@"Marker Felt" fontSize:64];
		label.position =  ccp(size.width/2 , size.height - label.contentSize.height);
		[self addChild: label];
		
		[CCMenuItemFont setFontSize:28.0];
		[CCMenuItemFont setFontName:@"Helvetica Neue"];
		
		CCMenuItem *backItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
		
		CCMenu *menu = [CCMenu menuWithItems:backItem, nil];
		[menu alignItemsVertically];
		[menu setPosition:ccp(size.width/2, size.height/2)]; // 50 point offset to bottom.
		
		[self addChild:menu];
	}
	
	return self;
}

- (void)goBack:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:1.0f scene:[GameScene scene]]];
}

@end
