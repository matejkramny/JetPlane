//
//  MainMenuScene.m
//  JetPlane
//
//  Created by Matej Kramny on 10/02/2013.
//  Copyright 2013 Matej Kramny. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameScene.h"
#import "OptionsScene.h"

@interface MainMenuScene () {
}

- (void)startGame:(id)sender;
- (void)showOptions:(id)sender;

@end

@implementation MainMenuScene

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	
	MainMenuScene *layer = [MainMenuScene node];
	
	[scene addChild:layer];
	
	return scene;
}

- (id)init {
	self = [super init];
	
	if (self) {
		// Initialise
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"JetPlane" fontName:@"Marker Felt" fontSize:64];
		label.position =  ccp(size.width/2 , size.height - label.contentSize.height);
		[self addChild: label];
		
		[CCMenuItemFont setFontSize:28.0];
		[CCMenuItemFont setFontName:@"Helvetica Neue"];
		
		CCMenuItem *startMenuItem = [CCMenuItemFont itemWithString:@"Start Game" target:self selector:@selector(startGame:)];
		CCMenuItem *showOptionsItem = [CCMenuItemFont itemWithString:@"Options" target:self selector:@selector(showOptions:)];
		
		CCMenu *menu = [CCMenu menuWithItems:startMenuItem, showOptionsItem, nil];
		[menu alignItemsVertically];
		[menu setPosition:ccp(size.width/2, size.height/2)]; // 50 point offset to bottom.
		
		[self addChild:menu];
	}
	
	return self;
}

- (void)startGame:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:1.0f scene:[GameScene scene]]];
}

- (void)showOptions:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipAngular transitionWithDuration:1.0f scene:[OptionsScene scene]]];
}

@end
