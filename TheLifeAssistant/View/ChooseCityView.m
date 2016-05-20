//
//  ChooseCityView.m
//  PRESCHOOL
//
//  Created by tztddong on 16/5/12.
//  Copyright © 2016年 INFORGENCE. All rights reserved.
//

#import "ChooseCityView.h"

@interface ChooseCityView ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)CityBlock cityBlock;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UITableView *cityTableView;
@property(nonatomic,strong)NSMutableArray *cityArrayM;
@property(nonatomic,strong)NSMutableArray *cityFirstL;
@property(nonatomic,strong)NSMutableArray *cityList;
@property(nonatomic,strong)NSArray *allCityArray;

@end

@implementation ChooseCityView
{
    BOOL isSearching;
}
+ (ChooseCityView *)getChooseCityViewWithFrame:(CGRect)frame cityBlock:(CityBlock)cityBlock{

    return [[[self class]alloc]initWithFrame:frame cityBlock:cityBlock];
}

- (instancetype)initWithFrame:(CGRect)frame cityBlock:(CityBlock)cityBlock{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = frame;
        self.cityBlock = cityBlock;
        [self configView];
        [self setTopView];
        [self getAllCity];
    }
    return self;
}

- (NSArray *)allCityArray{
    if (!_allCityArray) {
        
        _allCityArray = [[NSArray alloc]init];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ([ud objectForKey:@"unformedCityArr"]) {
            _allCityArray =[ud objectForKey:@"unformedCityArr"];
        }else{
            NSString *filePath=[[NSBundle mainBundle]pathForResource:@"cities" ofType:@"json"];
            NSData *cityData = [NSData dataWithContentsOfFile:filePath];
            //所有城市信息的数组
            _allCityArray = [NSJSONSerialization JSONObjectWithData:cityData options:NSJSONReadingAllowFragments error:nil];
            [ud setObject:_allCityArray forKey:@"unformedCityArr"];
        }
     }
    return _allCityArray;
}

- (NSMutableArray *)cityArrayM{
    if (!_cityArrayM) {
        _cityArrayM = [NSMutableArray array];
    }
    return _cityArrayM;
}

- (NSMutableArray *)cityFirstL{
    if (!_cityFirstL) {
        _cityFirstL = [NSMutableArray array];
    }
    return _cityFirstL;
}

- (NSMutableArray *)cityList{
    if (!_cityList) {
        _cityList = [NSMutableArray array];
    }
    return _cityList;
}

- (void)setTopView{

    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH, NAVHEIGHT)];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"6ecd29"];
    [self addSubview:self.topView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.x = 8;
    backBtn.size = CGSizeMake(36, 34);
    backBtn.y = NAVHEIGHT/2+10-backBtn.size.height/2;
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:backBtn];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, KWIDTH-80, 44)];
    lab.text = @"城市选择";
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont boldSystemFontOfSize:17];
    [self.topView addSubview:lab];
}

- (void)backBtnClick{
    if (self.cityBlock) {
        self.cityBlock(nil);
    }
    [self.searchBar resignFirstResponder];
}

- (void)configView{

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, self.width, 44)];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"输入城市名称"];
    [self addSubview:self.searchBar];
    
    self.cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), self.width, self.height-CGRectGetMaxY(self.searchBar.frame) ) style:UITableViewStylePlain];
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    self.cityTableView.sectionFooterHeight = 0;
    self.cityTableView.backgroundColor = [UIColor whiteColor];
    [self.cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"citycell"];
    [self addSubview:self.cityTableView];
}

- (void)getAllCity{
    
    //获取数组第一个城市的首字母
    NSString *firstLetter = [[[self.allCityArray firstObject] objectForKey:@"aliasname"] substringToIndex:1];
    NSMutableArray *sectionCity = [NSMutableArray array];
    //比较各个城市的首字母 一样的分到一个组内
    for (NSDictionary *dict in self.allCityArray) {
        if ([[[dict objectForKey:@"aliasname"] substringToIndex:1] isEqualToString:firstLetter]) {
            [sectionCity addObject:dict];
        }else{
            [self.cityArrayM addObject:[sectionCity copy]];
            [sectionCity removeAllObjects];
            [sectionCity addObject:dict];
            firstLetter = [[dict objectForKey:@"aliasname"] substringToIndex:1];
        }
        //查询数组中元素所对应的位置
        if ([self.allCityArray indexOfObject:dict] == self.allCityArray.count-1) {
            [self.cityArrayM addObject:[sectionCity copy]];
        }
    }
    for (NSArray *cityArr in self.cityArrayM) {
        [self.cityFirstL addObject:[[[cityArr firstObject] objectForKey:@"aliasname"] substringToIndex:1]];
    }
    NSLog(@"%@",self.cityFirstL[0]);
}

#pragma mark numberOfSectionsInTableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (isSearching) {
        return 1;
    }else{
        return self.cityArrayM.count;
    }
}
#pragma mark numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isSearching) {
        return self.cityList.count;
    }else{
        return [self.cityArrayM[section] count];
    }
}
#pragma mark cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"citycell"];
    NSDictionary *dict = nil;
    if (isSearching) {
        dict = self.cityList[indexPath.row];
    }else{
        NSArray *nameArr = self.cityArrayM[indexPath.section];
        dict = nameArr[indexPath.row];
    }
    cell.textLabel.text = [dict objectForKey:@"areaname"];
    return cell;
}

#pragma mark heightForHeaderInSection
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (isSearching) {
        return 0;
    }else{
        return 30;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (isSearching) {
        return nil;
    }else{
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH, 30)];
        headView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, KWIDTH, 30)];
        [label setFont:FONTSIZE(17)];
        label.text = self.cityFirstL[section];
        [headView addSubview:label];
        return headView;
    }
}
#pragma mark didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchBar resignFirstResponder];
    NSDictionary *dict = nil;
    if (isSearching) {
        dict = self.cityList[indexPath.row];
    }else{
        NSArray *nameArr = self.cityArrayM[indexPath.section];
        dict = nameArr[indexPath.row];
    }
    if (self.cityBlock) {
        self.cityBlock([dict objectForKey:@"areaname"]);
    }
}
#pragma mark 返回每组标题索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *indexs=[[NSMutableArray alloc]init];
    for(NSString *name in self.cityFirstL){
        [indexs addObject:name];
    }
    return indexs;
}

#pragma mark - searchBar delegaete
// return NO to not become first responder
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
// called when text starts editing
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}
// return NO to not resign first responder
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (![searchText length]) {
        isSearching = NO;
        [self.searchBar resignFirstResponder];
        [self.cityTableView reloadData];
        return;
    }
    isSearching = YES;
    self.cityList = [self citySearchWithsearchText:searchText FromSource:self.allCityArray];
    [self.cityTableView reloadData];
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    isSearching = NO;
    [self.cityTableView reloadData];
}

//匹配字符串
- (NSMutableArray *)citySearchWithsearchText:(NSString*)text FromSource:(NSArray*)cityArr{
    
    NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (NSDictionary *dic in cityArr) {
        
        //名称匹配
        NSRange range1 = [[dic objectForKey:@"areaname"] rangeOfString:text];
        //拼音大写匹配
        NSRange range2 = [[dic objectForKey:@"aliasname"] rangeOfString:text];
        //拼音小写匹配
        NSRange range3 = [[[dic objectForKey:@"aliasname"] lowercaseString] rangeOfString:text];
        if (range1.location != NSNotFound|range2.location != NSNotFound|range3.location != NSNotFound) {
            [resultArr addObject:dic];
        }
    }
    
    return resultArr;
}
@end
