#import <UIKit/UIKit.h>

@interface Alarm : NSObject
-(NSString *)alarmID;
-(void)setTitle:(NSString *)arg1;
-(NSString *)title;
@end

@interface EditAlarmViewController : UIViewController
- (void)loadView;
- (void)_doneButtonClicked:(id)arg1;
- (void)_cancelButtonClicked:(id)arg1;
@end

static UITableView *tableView;
extern NSString *alarmID;
extern BOOL handleAlarm;

/* stuff for implementing custom UI toggles in alarm app edit screen    */
@interface MySpotifyView : UIView {

    UISwitch *toggleSwitch;
    UILabel *toggleLabel;
}
-(void)addToView:(NSString *)name :(BOOL)switchState;
-(void)toggleSpotify:(id)sender;
@end


/*  peek into notifications, their requests and actions */
@interface UNNotificationRequest : NSObject
@end

@interface UNNotification : NSObject
-(UNNotificationRequest *)request;
@end

@interface NCNotificationRequest : NSObject
{
    NSString* _sectionIdentifier;
    NSString* _notificationIdentifier;
    NSString* _threadIdentifier;
    NSString* _categoryIdentifier;
}
@end

@interface NCNotificationAction : NSObject 
{

    NSString* _identifier;
    NSString* _title;
    unsigned long long _activationMode;
    BOOL _requiresAuthentication;
    NSURL* _launchURL;
    NSString* _launchBundleID;
    unsigned long long _behavior;
    NSDictionary* _behaviorParameters;
    BOOL _destructiveAction;
    BOOL _shouldDismissNotification;

}
@end


/*  useful for dismissing lockscreen alarm event    */
@interface SBDashBoardFullscreenNotificationViewController 
{

    NCNotificationRequest* _request;
    NCNotificationAction* _primaryAction;
    NCNotificationAction* _secondaryAction;
    NCNotificationAction* _silenceAction;
    NCNotificationAction* _dismissAction;

}
@property (copy,readonly) NSString * description; 
-(void)_handleSecondaryAction;
-(NCNotificationRequest *)notificationRequest;
@end


/*  intercept alarms    */
@interface AlarmManager
+ (id)sharedManager;
- (BOOL)isAlarmNotification:(id)arg1;
@property(readonly, retain, nonatomic) NSArray *alarms;
@end

/*  launch applications from springboard    */
@interface UIApplication (SpotifyAlarm)
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
+(id)sharedApplication;
@end


/*  unlock lock screen for launching and viewing spotify    */
@interface SBLockScreenManager : NSObject
+(id)sharedInstance;
-(void)attemptUnlockWithPasscode:(id)arg1;
-(BOOL) isUILocked;
-(void)_lockUI;
@end


/*  lock and home button use    */
@interface SpringBoard
-(void)_simulateLockButtonPress;
-(void)_simulateHomeButtonPress;
@end


/*  explore how spotify actions are assembled   */
@interface SPAction : NSObject
- (id)initWithOrder:(long long)arg1 logContext:(id)arg2;
@end


/*  this is used for detecting the alarm being fired    */
@interface SBClockDataProvider : NSObject
+(id)sharedInstance;
-(BOOL)_isAlarmNotification:(id)arg1;
-(id)_alarmIDFromNotificationRequest:(id)arg1;
@end
