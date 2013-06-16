//
//  GameOverLayer.h
//
//  Created by Sander Vispoel on 5/4/13.
//  Revised by Yonggu Choi on 6/16/13.
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
