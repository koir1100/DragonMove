//
//  GameOverLayer.m
//
//  Created by Sander Vispoel on 5/4/13.
//  Revised by Yonggu Choi on 16/6/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
//#import "GameBoard.h"
#import "GameScene.h"
#import "InterfaceLayer.h"


@implementation GameOverLayer

+(CCScene *)sceneGameOver:(InterfaceLayer *)interface
{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initGameOver:interface] autorelease];
    
    [scene addChild:layer];
    
    return scene;
}

-(id) initGameOver:(InterfaceLayer *)interface
{
    if ((self = [super init]))
    {
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"bg_game.png"];
        backgroundImage.anchorPoint = ccp(0, 0);
        
        [self addChild:backgroundImage z:-1];
            
        CGFloat posX = [[CCDirector sharedDirector] winSize].width*0.4;
        CGFloat posY = [[CCDirector sharedDirector] winSize].height/2;
        
        CCSprite *label = [CCSprite spriteWithFile:@"title_gameend.png"];
        
        label.position = ccp(posX, posY);
        [self addChild:label];
        
        CCLabelTTF *score = [interface getPlayerScoreTxt];
        score.position = ccp(posX + 150, posY - 40);
        [self addChild:score];
        
        character = [CCSprite spriteWithFile:@"symbol_babysnake.png"];
        character.position = ccp(posX + 150, posY + 15);
        [self addChild:character];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCMenuItem *closeMenuItem = [CCMenuItemImage itemWithNormalImage:@"btn_back1.png" selectedImage:@"btn_back2.png" target:self selector:@selector(closeMenuCallback:)];
        
        CCMenu *menu = [CCMenu menuWithItems: closeMenuItem, nil];
        
		menu.position = ccp(size.width*4/5, size.height*1/15);
        
        // 만들어진 메뉴를 배경 sprite 위에 표시합니다.
        [self addChild:menu z:200 tag:100];
    }
    
    return self;
}

- (void) closeMenuCallback: (id) sender
{
    // 더 이상 사용되지않는 그래픽 캐시를 지웁니다.
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [SceneManager goMenu];
}

@end
