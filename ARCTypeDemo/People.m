//
//  People.m
//  ARCTypeDemo
//
//  Created by MengLong Wu on 16/8/26.
//  Copyright © 2016年 MengLong Wu. All rights reserved.
//

#import "People.h"

@implementation People
- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.name = name;
        NSLog(@"%@ : 初始化",self.name);
    }
    return self;
}

- (void)setName:(NSString *)name
{
//    self.name = name;
//    [self setName:name];
    _name = [name copy];
}

- (void)dealloc
{
    NSLog(@"%@:释放",self.name);
    
#if !__has_feature(objc_arc)
    self.name = nil;
    [super dealloc];
#endif
    
}
//重写描述对象的方法
- (NSString *)description
{
    NSInteger retainCount = 0;
//    [self retainCount];
//    id rtCnt = [self performSelector:@selector(retainCount)];
#if  __has_feature(objc_arc)
    id rtCnt = [self valueForKey:@"retainCount"];
    retainCount = [rtCnt integerValue];
#else
//    在MRC下进行编译的
    retainCount = [self retainCount];
#endif
    
    return [NSString stringWithFormat:@"<%@ 引用计数:%ld 内存地址:%p>",self.name,retainCount,self];
}











@end
