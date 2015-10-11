//
// VTDAppDependencies.m
//
// Copyright (c) 2014 Mutual Mobile (http://www.mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "VTDAppDependencies.h"

#import "VTDRootWireframe.h"

#import "VTDCoreDataStore.h"
#import "VTDDeviceClock.h"

#import "VTDListDataManager.h"
#import "VTDListInteractor.h"
#import "VTDListPresenter.h"
#import "VTDListWireframe.h"

#import "VTDAddDataManager.h"
#import "VTDAddInteractor.h"
#import "VTDAddPresenter.h"
#import "VTDAddWireframe.h"

@interface VTDAppDependencies ()

@property (nonatomic, strong) VTDListWireframe *listWireframe;

@end


@implementation VTDAppDependencies

- (id)init
{
    if ((self = [super init]))
    {
        [self configureDependencies];
    }
    
    return self;
}


- (void)installRootViewControllerIntoWindow:(UIWindow *)window
{
    [self.listWireframe presentListInterfaceFromWindow:window];
}

//初始化依赖
- (void)configureDependencies
{
    // Root Level Classes
    //数据存储初始化
    VTDCoreDataStore *dataStore = [[VTDCoreDataStore alloc] init];
    id<VTDClock> clock = [[VTDDeviceClock alloc] init];
    //根视图的线框
    VTDRootWireframe *rootWireframe = [[VTDRootWireframe alloc] init];
    
    // List Modules Classes
    //初始化列表线框
    VTDListWireframe *listWireframe = [[VTDListWireframe alloc] init];
    //初始化列表展示器
    VTDListPresenter *listPresenter = [[VTDListPresenter alloc] init];
    //初始化列表数据管理器
    VTDListDataManager *listDataManager = [[VTDListDataManager alloc] init];
    //初始化列表交互器
    VTDListInteractor *listInteractor = [[VTDListInteractor alloc] initWithDataManager:listDataManager clock:clock];
    
    // Add Module Classes
    //初始化增加的线框
    VTDAddWireframe *addWireframe = [[VTDAddWireframe alloc] init];
    //初始化增加的交互器
    VTDAddInteractor *addInteractor = [[VTDAddInteractor alloc] init];
    //初始化增加的展示器
    VTDAddPresenter *addPresenter = [[VTDAddPresenter alloc] init];
    //初始化增加的数据管理
    VTDAddDataManager *addDataManager = [[VTDAddDataManager alloc] init];
    
    // List Module Classes
    //列表交互器的输出是列表展示器，outPut是代理,所以对列表展示器是弱引用
    listInteractor.output = listPresenter;
    
    //列表展示器的交互器是列表交互器
    listPresenter.listInteractor = listInteractor;
    //列表展示器的列表线框
    listPresenter.listWireframe = listWireframe;
    //给列表线框赋值增加线框
    listWireframe.addWireframe = addWireframe;
    listWireframe.listPresenter = listPresenter;
    listWireframe.rootWireframe = rootWireframe;
    self.listWireframe = listWireframe;
    
    listDataManager.dataStore = dataStore;
    
    // Add Module Classes
    addInteractor.addDataManager = addDataManager;
    
    addPresenter.addInteractor = addInteractor;
    
    addWireframe.addPresenter = addPresenter;
    
    addPresenter.addWireframe = addWireframe;
    addPresenter.addModuleDelegate = listPresenter;
    
    addDataManager.dataStore = dataStore;
}

@end
