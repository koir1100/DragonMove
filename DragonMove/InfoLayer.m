//
//  InfoLayer.m
//  Report7
//
//  Created by Apple on 13. 5. 22..
//  Copyright 2013년 __MyCompanyName__. All rights reserved.
//

#import "InfoLayer.h"

@implementation InfoLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	InfoLayer *layer = [InfoLayer node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
    if ( (self = [super init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
		CCSprite *bgSprite = [CCSprite spriteWithFile:@"bg_info.png"];
        CCSprite *info_content = [CCSprite spriteWithFile:@"bg_info_content.png"];
		[bgSprite setAnchorPoint:CGPointZero];
		[bgSprite setPosition:CGPointZero];
        info_content.position = ccp(size.width/2, size.height/2);
		[self addChild:bgSprite z:0 tag:3];
        [self addChild:info_content z:1];
        // infoLayer에 필요한 이미지 삽입
        
		CCMenuItem *closeMenuItem = [CCMenuItemImage itemWithNormalImage:@"btn_b1.png" selectedImage:@"btn_b2.png" target:self selector:@selector(closeMenuCallback:)];
		CCMenu *menu = [CCMenu menuWithItems:closeMenuItem, nil];
		menu.position = ccp(size.width*8/9, size.height*8/9);
        [menu alignItemsVertically];
		[self addChild:menu z:3 tag:10];
        // 돌아가기 버튼
    }
    return self;
}

- (void) closeMenuCallback: (id) sender
{
	[SceneManager goMenu];
    // SceneManager의 goMenu 객체를 생성.
}

@end
