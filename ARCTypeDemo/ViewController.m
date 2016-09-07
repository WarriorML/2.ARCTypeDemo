//
//  ViewController.m
//  ARCTypeDemo
//
//  Created by MengLong Wu on 16/8/26.
//  Copyright © 2016年 MengLong Wu. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
@interface ViewController ()
{
    People *_strongP1;
    People *_strongP2;
    People *_strongP3;
    void   *_voidP4;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
    
    //    局部强指针指向一个对象，是对象在方法的内部不会被释放掉
    People *p = [[People alloc]initWithName:@"局部变量"];
    NSLog(@"对象 = %@",p);
    //    弱指针不会影响引用计数
    __weak People *weakP = p;
    NSLog(@"对象 = %@",p);
    
    //    强指针指向对象，会使对象引用计数加1
    //    局部变量，方法里面的代码执行完之后，strongP才会被释放
    __strong People *strongP = p;
    NSLog(@"对象 = %@",p);
    
    //    强指针指向对象，会使对象引用计数加1
    //    ViewController类的成员变量，方法执行完是不影响成员变量的
    //    ViewController类的实例对象释放的时候，_strongP1才会跟着释放
    _strongP1 = p;
    _strongP2 = p;
    _strongP3 = p;
    _voidP4 = (__bridge  void *)p;
    NSLog(@"对象 = %@",p);
    
    NSLog(@"对象_strongP1 = %@",_strongP1);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 200, 100);
    [button setTitle:@"查看变量引用计数" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
//    [button addTarget:self action:@selector(printObject) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(testTypeCastBridgeTransfer) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    
//    [self testTypeCastNormal];
    
//    [self testTypeCastBridge];
    
//    [self testTypeCastBridgeRetain];
}


- (void)printObject
{
    NSLog(@"对象_strongP1 = %@",_strongP1);
}

//测试基本的指针类型转换
- (void)testTypeCastNormal
{
    //    *&
    //    声明一个int类型的变量，并且赋值为1000
    int num = 1000;
    NSLog(@"num === %d",num);
    
    //    指针类型，需要先取变量的地址，进行赋值
    int *numPtr = &num;
    NSLog(@"numPtr === %p",numPtr);
    NSLog(@"numPtr's value === %d", *numPtr);
    //    取指针地址里面的值*numPtr
    int num2 = *numPtr;
    NSLog(@"num2 === %d",num2);
    
    //    void *不限类型的指针，也就是说它可以指向任意类型的变量
    //    可以用不限类型的指针，接收int
    void *numVoidPtr = &num;
    NSLog(@"numVoidPtr == %p",numVoidPtr);
    
    //    NSLog(@"numVoidPtr's value == %d",*(int *)numVoidPtr);
    
    int *numVoidPtrTonumPtr = numVoidPtr;
    
    NSLog(@"numVoidPtr's value == %d",*numVoidPtrTonumPtr);
    
    //    &a为取数组名的地址，即为整个数组的地址，它的类型为数组类型，(int*)(&a+1)将其强制转换成整型指针赋值给*ptr，并指向了数组界外,最后用*(ptr-1)又指向了界内的最后一个元素5
    //    int a[5] = {1,2,3,4,5};
    //    int *ptr = (int *)(&a + 1);
    //    printf("\n内存中的值 %d, %d \n", *(a + 1), *(ptr - 1));
}
//C和OC的普通类型转换
- (void)testTypeCastBridge
{
//    OC里面的People类型的指针
    People *p = [[People alloc]initWithName:@"测试bridge用的对象"];
//    C里面不限类型的指针（双击左边的报错可自己提示）
    void *pPtr = (__bridge void *)(p);
    
    __weak People *p2 = (__bridge People *)(pPtr);
    
    __weak People *p3 = p;
    
    NSLog(@"p1 === %@",p);
    
//    这里__weak类型的指针，会被NSLog暂时retain
//    在NSLog执行的时候 p2的引用计数暂时加1
//    防止NSLog使用对象的过程中，对象释放掉
    
    NSLog(@"p2 === %@",p2);
    NSLog(@"p3 = %@ p2 = %@ p = %@",p3,p2,p);
    
//    总结:
//    __bridge 可以转换变量的类型 OC->C,C->OC
//    __bridge 不会影响对象的引用计数
}
- (void)testTypeCastBridgeRetain
{
//    OC里面的People类型的指针
    People *p = [[People alloc]initWithName:@"测试bridge_retained用的对象"];
//    会有对象的管理权，类似于全局的__strong People *
//    这样C的指针就可以管理OC的对象，并且方法中的局部变量也需要手动释放
    void *ownP = (void *)CFBridgingRetain(p);
    
//    使用完需要手动释放
    CFBridgingRelease(ownP);
    
    void *ownPtr = (__bridge_retained void *)(p);
    
    CFBridgingRelease(ownPtr);
    
//    不能把C的指针转化为OC的指针
//    People *p2 = (__bridge_retained People *)(ownPtr);
    
    /**总结
     *__bridge_retained：只可以把OC的指针转换为C的指针
     *并且转换过程中会retain，对象的引用计数会加1
     *内存管理也要注意，C的类型指针需要自己手动释放
     */
}
- (void)testTypeCastBridgeTransfer
{
    NSLog(@"对象_strongP1 == %@",_strongP1);
//    局部变量，强指针
//    在方法内部，对象的管理权转交给局部变量，引用计数不变
//    方法执行完毕之后，局部变量会被清理（release一次）
//    每次执行完这个方法，对象的引用计数都会减一
    __strong People *p = (__bridge_transfer People *)(_voidP4);
    NSLog(@"对象_strongP1 = %@",_strongP1);
    
    //总结
    //__bridge_transfer：只能从C的指针转换成OC的指针
    //转换的过程中，把对象的管理权转交给新的接收的OC的指针
}






@end
