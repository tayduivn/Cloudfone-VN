//
//  MoreViewController.m
//  linphone
//
//  Created by user on 1/7/14.
//
//

#import "MoreViewController.h"
#import "MenuCell.h"
#import "EditProfileViewController.h"
#import "AccountSettingsViewController.h"
#import "KSettingViewController.h"
#import "PolicyViewController.h"
#import "IntroduceViewController.h"
#import "TabBarView.h"
#import "StatusBarView.h"
#import "NSData+Base64.h"
#import "JSONKit.h"

@interface MoreViewController () {
    float hInfo;
    
    NSArray *listTitle;
    NSArray *listIcon;
    
    UIFont *textFont;
    
    int logoutState;
}

@end

@implementation MoreViewController
@synthesize _viewHeader, bgHeader, _imgAvatar, _lbName, lbPBXAccount, icEdit, _tbContent, lbVersion;

#pragma mark - UICompositeViewDelegate Functions
static UICompositeViewDescription *compositeDescription = nil;
+ (UICompositeViewDescription *)compositeViewDescription {
    if (compositeDescription == nil) {
        compositeDescription = [[UICompositeViewDescription alloc] init:self.class
                                                              statusBar:nil
                                                                 tabBar:TabBarView.class
                                                               sideMenu:nil
                                                             fullscreen:FALSE
                                                         isLeftFragment:YES
                                                           fragmentWith:0];
//        compositeDescription.darkBackground = true;
    }
    return compositeDescription;
}

- (UICompositeViewDescription *)compositeViewDescription {
    return self.class.compositeViewDescription;
}

#pragma mark - my controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataForMenuView];
    [self autoLayoutForMainView];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Tắt màn hình cảm biến
    UIDevice *device = [UIDevice currentDevice];
    [device setProximityMonitoringEnabled: NO];
    
    [self showContentWithCurrentLanguage];
    
    [self updateInformationOfUser];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)_btnSignOutPressed:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:text_alert_logout_title] message:[[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:text_alert_logout_content] delegate:self cancelButtonTitle:[[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:text_no] otherButtonTitles:[[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:text_yes], nil];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - my functions

- (void)showContentWithCurrentLanguage {
    [self createDataForMenuView];
    [_tbContent reloadData];
    
    lbVersion.attributedText = [AppUtils getVersionStringForApp];
}

- (void)updateInformationOfUser
{
    LinphoneProxyConfig *defaultConfig = linphone_core_get_default_proxy_config(LC);
    if (defaultConfig == NULL) {
        _lbName.text = [[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:@"No account"];
        lbPBXAccount.text = @"-.-";
        icEdit.hidden = YES;
    }else{
        const char *proxyUsername = linphone_address_get_username(linphone_proxy_config_get_identity_address(defaultConfig));
        NSString* defaultUsername = [NSString stringWithFormat:@"%s" , proxyUsername];
        if (defaultUsername != nil) {
            NSString *pbxKeyName = [NSString stringWithFormat:@"%@_%@", @"pbxName", defaultUsername];
            NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey: pbxKeyName];
            if (name != nil){
                _lbName.text = name;
                lbPBXAccount.text = defaultUsername;
            }else{
                _lbName.text = [[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:@"Not set"];
                lbPBXAccount.text = defaultUsername;
            }
            
            NSString *pbxKeyAvatar = [NSString stringWithFormat:@"%@_%@", @"pbxAvatar", defaultUsername];
            NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey: pbxKeyAvatar];
            if (avatar != nil && ![avatar isEqualToString:@""]){
                _imgAvatar.image = [UIImage imageWithData: [NSData dataFromBase64String: avatar]];
            }else{
                _imgAvatar.image = [UIImage imageNamed:@"no_avatar.png"];
            }
            icEdit.hidden = NO;
        }else{
            icEdit.hidden = YES;
        }
    }
}

//  Cập nhật vị trí cho view
- (void)autoLayoutForMainView {
    if (SCREEN_WIDTH > 320) {
        textFont = [UIFont fontWithName:MYRIADPRO_REGULAR size:18.0];
    }else{
        textFont = [UIFont fontWithName:MYRIADPRO_REGULAR size:16.0];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:(230/255.0) green:(230/255.0)
                                                 blue:(230/255.0) alpha:1.0];
    hInfo = [LinphoneAppDelegate sharedInstance]._hRegistrationState + 50;
    
    //  Header view
    [_viewHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(hInfo);
    }];
    
    [bgHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(_viewHeader);
    }];
    
    [_imgAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_viewHeader).offset(10);
        make.centerY.equalTo(_viewHeader.mas_centerY).offset([LinphoneAppDelegate sharedInstance]._hStatus/2);
        make.width.height.mas_equalTo(55.0);
    }];
    _imgAvatar.clipsToBounds = YES;
    _imgAvatar.layer.cornerRadius = 55.0/2;
    
    //  Edit icon
    [icEdit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgAvatar);
        make.right.equalTo(_viewHeader).offset(-10);
        make.width.height.mas_equalTo(35.0);
    }];
    
    _lbName.textColor = UIColor.whiteColor;
    [_lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgAvatar);
        make.left.equalTo(_imgAvatar.mas_right).offset(5);
        make.right.equalTo(icEdit.mas_left).offset(-5);
        make.bottom.equalTo(_imgAvatar.mas_centerY);
    }];
    
    lbPBXAccount.textColor = UIColor.whiteColor;
    [lbPBXAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lbName.mas_bottom);
        make.left.right.equalTo(_lbName);
        make.bottom.equalTo(_imgAvatar.mas_bottom);
    }];
    
    //  label version
    lbVersion.backgroundColor = UIColor.clearColor;
    lbVersion.textColor = [UIColor colorWithRed:(50/255.0) green:(50/255.0)
                                           blue:(50/255.0) alpha:1.0];
    [lbVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(45.0);
    }];
    
    _tbContent.backgroundColor = UIColor.clearColor;
    [_tbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewHeader.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(lbVersion.mas_top);
    }];
    _tbContent.delegate = self;
    _tbContent.dataSource = self;
    _tbContent.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbContent.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  Khoi tao du lieu cho view
- (void)createDataForMenuView {
    listTitle = [[NSArray alloc] initWithObjects: [[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:@"Account settings"], [[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:@"Settings"], [[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:@"Feedback"], [[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:@"Privacy Policy"], [[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:@"Introduction"], [[LinphoneAppDelegate sharedInstance].localization localizedStringForKey:@"Send report"], nil];
    
    listIcon = [[NSArray alloc] initWithObjects: @"ic_setup.png", @"ic_setting.png", @"ic_support.png", @"ic_term.png", @"ic_introduce.png", @"ic_introduce.png", nil];
}

#pragma mark - uitableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return listTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
        cell = topLevelObjects[0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell._iconImage.image = [UIImage imageNamed:[listIcon objectAtIndex: indexPath.row]];
    cell._lbTitle.text = [listTitle objectAtIndex:indexPath.row];
    cell._iconImage.hidden = NO;
    cell._lbTitle.textAlignment = NSTextAlignmentLeft;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case eSettingsAccount:{
            [[PhoneMainView instance] changeCurrentView:[AccountSettingsViewController compositeViewDescription] push:true];
            break;
        }
        case eSettings:{
            [[PhoneMainView instance] changeCurrentView:[KSettingViewController compositeViewDescription] push:true];
            break;
        }
        case eFeedback:{
            NSURL *linkCloudfoneOnAppStore = [NSURL URLWithString:@"https://itunes.apple.com/vn/app/cloudfone/id1275900068?mt=8"];
            [[UIApplication sharedApplication] openURL: linkCloudfoneOnAppStore];
            
            break;
        }
        case ePolicy:{
            [[PhoneMainView instance] changeCurrentView:[PolicyViewController compositeViewDescription]
                                                   push:true];
            break;
        }
        case eIntroduce:{
            [[PhoneMainView instance] changeCurrentView:[IntroduceViewController compositeViewDescription]
                                                   push:true];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (IBAction)icEditClicked:(UIButton *)sender {
    [[PhoneMainView instance] changeCurrentView:[EditProfileViewController compositeViewDescription]
                                           push:YES];
}

@end
