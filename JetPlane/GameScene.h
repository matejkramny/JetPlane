//
//  GameScene.h
//  JetPlane
//
//  Created by Matej Kramny on 10/02/2013.
//  Copyright 2013 Matej Kramny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCTouchDelegateProtocol.h"

@interface GameScene : CCLayer <CCTouchAllAtOnceDelegate> {
    
}

+ (CCScene *)scene;

@end
