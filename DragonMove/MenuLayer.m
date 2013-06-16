//
//  MenuLayer.m
//  DragonMove
//
//  Created by Apple on 13. 5. 21..
//  Copyright __MyCompanyName__ 2013년. All rights reserved.
//


#import "MenuLayer.h"
#import "AppDelegate.h"

#pragma mark - MenuLayer

@implementation MenuLayer

-(id) init
{
	if( (self=[super init]) )
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *bgimage = [CCSprite spriteWithFile:@"bg_blank.png"];
        bgimage.position = ccp(size.width/2, size.height/2);
        [self addChild:bgimage z:0];
        
        CCSprite *title = [CCSprite spriteWithFile:@"title_dm.png"];
        
        title.position = ccp(size.width*2.25/7, size.height*1/2);
        
        [self addChild:title z:10];
        
        CCMenuItem *item1 = [CCMenuItemImage itemWithNormalImage:@"btn_play.png" selectedImage:@"btn_play_s.png" target:self selector:@selector(newGameMenuCallback:)];
        
        CCMenuItem *item2 = [CCMenuItemImage itemWithNormalImage:@"btn_howto.png" selectedImage:@"btn_howto_s.png" target:self selector:@selector(howtoMenuCallback:)];
        
        CCMenuItem *item3 = [CCMenuItemImage itemWithNormalImage:@"btn_info.png" selectedImage:@"btn_info_s.png" target:self selector:@selector(goInfoScene:)];
        
        CCMenuItem *item4 = [CCMenuItemImage itemWithNormalImage:@"btn_intro.png" selectedImage:@"btn_intro_s.png" target:self selector:@selector(goIntroScene:)];
        
        item1.tag = 1440; // tag은 유일해야 한다!!
        item2.tag = 1441;
        item3.tag = 1442;
        item4.tag = 1443;
        
        CCMenu *menu1 = [CCMenu menuWithItems:item1, item2, nil];
        CCMenu *menu2 = [CCMenu menuWithItems:item3, item4, nil];
        menu1.position = ccp(size.width*5.5/7, size.height*4/6);
        menu2.position = ccp(size.width*5.5/7, size.height*2/6);
        
        [menu1 alignItemsHorizontallyWithPadding:10];
        [menu2 alignItemsHorizontallyWithPadding:10];
        [self addChild:menu1];
        [self addChild:menu2];
	}
    
	return self;
}

// IntroduceScene로 이동
- (void) goIntroScene: (id) sender {
    [SceneManager goIntro];
}

// InfoScene으로 이동
- (void) goInfoScene: (id) sender {
    [SceneManager goInfo];
}

// Howto로 이동
- (void) howtoMenuCallback: (id) sender {
    [SceneManager goHowto];
}

// 게임 시작.
- (void) newGameMenuCallback: (id) sender {
    [SceneManager goGame];
}

- (void) dealloc
{
	[super dealloc];
}

@end