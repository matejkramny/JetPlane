//
//  GameScene.m
//  JetPlane
//
//  Created by Matej Kramny on 10/02/2013.
//  Copyright 2013 Matej Kramny. All rights reserved.
//

#import "GameScene.h"

@interface GameScene () {
	CCSprite *ship;
	CCTMXTiledMap *map;
	CCTMXLayer *mapTiles;
	NSMutableArray *worldCubes; // contains many CCSprite *
	NSArray *pauseMenu;
	bool touching;
	bool playing;
	int shipXOffset;
}

- (void)nextFrame:(ccTime)dt;
- (void)startGame:(id)sender;
- (CGPoint)tileCoordForPosition:(CGPoint)position;
- (void)setShipPosition:(CGPoint)position;
- (NSArray *)getSurroundingTileGID:(CGPoint)position; // Returns (4) tile gid's that are around position

@end

@implementation GameScene

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	
	GameScene *layer = [GameScene node];
	
	[scene addChild:layer];
	
	return scene;
}

- (id)init {
	self = [super init];
	
	if (self) {
		// Init
		touching = false;
		playing = false;
		
		CGSize wsize = [[CCDirector sharedDirector] winSize];
		
		// I am ready menu
		CCMenuItem *startMenuItem = [CCMenuItemFont itemWithString:@"I am ready!" target:self selector:@selector(startGame:)];
		CCMenu *startMenu = [CCMenu menuWithItems:startMenuItem, nil];
		[startMenu alignItemsHorizontally];
		startMenu.position = ccp(wsize.width/2, wsize.height/2);
		[self addChild:startMenu];
		
		// How to play..
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Press I am ready,\ntouch anywhere on screen to lift the ship." fontName:@"Helvetica Neue" fontSize:16];
		label.position =  ccp(wsize.width/2 , wsize.height/2 - label.contentSize.height);
		[self addChild: label];
		
		pauseMenu = [[NSArray alloc] initWithObjects:startMenu, label, nil];
		
		// TMX map
		map = [CCTMXTiledMap tiledMapWithTMXFile:@"map.tmx"];
		map.position = ccp(0.0, wsize.height - map.contentSize.height);
		mapTiles = [map layerNamed:@"Map"];
		
		CCTMXObjectGroup *spawnObjectGroup = [map objectGroupNamed:@"Spawn"];
		NSMutableDictionary *spawnPoint = [[spawnObjectGroup objects] objectAtIndex:0];
		int x = [[spawnPoint valueForKey:@"x"] intValue];
		int y = [[spawnPoint valueForKey:@"y"] intValue];
		shipXOffset = x - map.tileSize.width/2;
		
		ship = [CCSprite spriteWithFile:@"ship.png"];
		ship.position = ccp(shipXOffset, y - map.tileSize.height/2); //old//ccp(ship.contentSize.width/2 + 25, wsize.height/2);
		[self addChild:ship];
		
		[self addChild:map z:-1];
		
		// Design the level.. For now make the cubes move opposite direction of the ship, and make ship move up when toching
		[self schedule:@selector(nextFrame:)];
		self.touchEnabled = YES;
	}
	
	return self;
}

- (void)nextFrame:(ccTime)dt {
	if (!playing) {
		return;
	}
	
	CGPoint newPosition;
	if (touching) {
		newPosition = ccp(ship.position.x, ship.position.y + 100 * dt);
	} else {
		newPosition = ccp(ship.position.x, ship.position.y - 100 * dt);
	}

	newPosition = ccp(ship.position.x + 100 * dt, newPosition.y);
	
	[self setShipPosition:newPosition];
	
	self.position = ccp((-newPosition.x) + shipXOffset, self.position.y);
}

- (void)setShipPosition:(CGPoint)position {
	NSArray *tiles = [self getSurroundingTileGID:position];
	
	bool collides = false;
	for (NSNumber *gid in tiles) {
		int gidInt = [gid intValue];
		if (gidInt) {
			NSDictionary *properties = [map propertiesForGID:gidInt];
			if (properties) {
				NSString *collide = [properties valueForKey:@"Collidable"];
				if (collide && [collide compare:@"True"] == NSOrderedSame) {
					collides = true;
					break;
				}
			}
		} else {
			collides = true;
			break;
		}
	}
	//collides = false;
	if (!collides)
		ship.position = position;
	else {
		ship.position = ccp(shipXOffset, [CCDirector sharedDirector].winSize.height/2 - ship.contentSize.height/2);
		self.position = ccp(0.0, 0.0);
	}
}

- (void)startGame:(id)sender {
	playing = YES;
	
	for (CCNode *item in pauseMenu) {
		[self removeChild:item];
	}
	
	pauseMenu = nil;
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
	CGFloat scale = [[UIScreen mainScreen] scale];
	
	int x = (position.x * scale) / map.tileSize.width;
	int y = ((map.mapSize.height * map.tileSize.height) - (position.y * scale)) / map.tileSize.height; // TMX coord 0,0 is top-left but open-gl and cocos2d has 0,0 as bottom-left
	
	return ccp(x, y);
}

- (NSArray *)getSurroundingTileGID:(CGPoint)position {
	CGSize size = ship.contentSize;
	NSArray *positions = [[NSArray alloc] initWithObjects:
						  [NSValue valueWithCGPoint:ccp(position.x - size.width/2, position.y - size.height/2)], // bottom-left corner point
						  [NSValue valueWithCGPoint:ccp(position.x - size.width/2, position.y + size.height/2)], // top-left
						  [NSValue valueWithCGPoint:ccp(position.x + size.width/2, position.y - size.height/2)], // bottom-right
						  [NSValue valueWithCGPoint:ccp(position.x + size.width/2, position.y + size.height/2)], // top-right
						  nil];
	NSMutableArray *gids = [[NSMutableArray alloc] initWithCapacity:4];
	
	for (int i = 0; i < 4; i++) {
		CGPoint position = [[positions objectAtIndex:i] CGPointValue];
		CGPoint coord = [self tileCoordForPosition:position];
		int gid = [mapTiles tileGIDAt:coord];
		
		[gids addObject:[NSNumber numberWithInt:gid]];
	}
	
	return gids;
}

# pragma mark - Touches

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	touching = YES;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	touching = NO;
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	touching = NO;
}

@end
