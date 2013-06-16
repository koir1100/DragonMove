//
//  GameOverLayer.h
//
//  Created by Sander Vispoel on 5/4/13.
//  Reviesed by Yonggu Choi on 16/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SceneManager.h"

@class InterfaceLayer;

@interface GameOverLayer : CCLayer {
    CCSprite *character;
}

+(CCScene *)sceneGameOver:(InterfaceLayer *)interface;
-(id)initGameOver:(InterfaceLayer *)interface;

@end
