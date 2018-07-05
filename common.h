#import <UIKit/UIKit.h>


// stuff for implementing custom UI toggles in alarm app edit screen
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

@interface MySpotifyView : UIView {
    
    UISwitch *toggleSwitch;
    UILabel *toggleLabel;
}
-(void)addToView:(NSString *)name :(BOOL)switchState;
-(void)toggleSpotify:(id)sender;
@end


// stuff for deciphering and intercepting alarm notifications on lockscreen
@interface NCNotificationContent : NSObject
{
    
    NSString* _header;
    NSString* _title;
    NSString* _subtitle;
    NSString* _message;
    NSString* _topic;
    //UIImage* _icon;
    //UIImage* _attachmentImage;
    //NSDate* _date;
    //BOOL _dateAllDay;
    //NSTimeZone* _timeZone;

}

@property (nonatomic,copy,readonly) NSString * header;
//@synthesize header=_header - In the implementation block
@property (nonatomic,copy,readonly) NSString * title;
//@synthesize title=_title - In the implementation block
@property (nonatomic,copy,readonly) NSString * subtitle;
//@synthesize subtitle=_subtitle - In the implementation block
@property (nonatomic,copy,readonly) NSString * message;
//@synthesize message=_message - In the implementation block
@property (nonatomic,copy,readonly) NSString * topic;
//@synthesize topic=_topic - In the implementation block
// @property (nonatomic,readonly) UIImage * icon;
//@synthesize icon=_icon - In the implementation block
// @property (nonatomic,readonly) UIImage * attachmentImage;
//@synthesize attachmentImage=_attachmentImage - In the implementation block
// @property (nonatomic,readonly) NSDate * date;
//@synthesize date=_date - In the implementation block
// @property (getter=isDateAllDay,nonatomic,readonly) BOOL dateAllDay;
//@synthesize dateAllDay=_dateAllDay - In the implementation block
// @property (nonatomic,readonly) NSTimeZone * timeZone;
//@synthesize timeZone=_timeZone - In the implementation block
// @property (readonly) unsigned long long hash; 
// @property (readonly) Class superclass; 
//   @property (copy,readonly) NSString * description; 
//   @property (copy,readonly) NSString * debugDescription; 
// -(BOOL)isEqual:(id)arg1 ;
// -(unsigned long long)hash;
-(NSString *)description;
-(NSString *)debugDescription;
-(NSString *)title;
// -(NSDate *)date;
// -(id)copyWithZone:(NSZone*)arg1 ;
-(NSString *)subtitle;
-(NSString *)message;
// -(NSTimeZone *)timeZone;
// -(id)mutableCopyWithZone:(NSZone*)arg1 ;
// -(UIImage *)icon;
-(NSString *)header;
-(NSString *)topic;
// -(id)descriptionWithMultilinePrefix:(id)arg1 ;
// -(id)succinctDescription;
// -(id)succinctDescriptionBuilder;
// -(id)descriptionBuilderWithMultilinePrefix:(id)arg1 ;
// -(BOOL)isDateAllDay;
// -(UIImage *)attachmentImage;
// -(id)initWithNotificationContent:(id)arg1 ;
@end



@interface NCNotificationRequest : NSObject
{
	NSString* _sectionIdentifier;
	NSString* _notificationIdentifier;
	NSString* _threadIdentifier;
	NSString* _categoryIdentifier;
/*
	NSSet* _subSectionIdentifiers;
	NSArray* _peopleIdentifiers;
	NSString* _parentSectionIdentifier;
	NSDate* _timestamp;
	NSSet* _requestDestinations;
    */
	NCNotificationContent* _content;
/*
	NCNotificationOptions* _options;
	NSDictionary* _context;
	NSSet* _settingsSections;
	NCNotificationSound* _sound;
	NCNotificationAction* _clearAction;
	NCNotificationAction* _closeAction;
	NCNotificationAction* _defaultAction;
	NCNotificationAction* _silenceAction;
	NSDictionary* _supplementaryActions;
	UNNotification* _userNotification;
	BOOL _isCollapsedNotification;
	unsigned long long _collapsedNotificationsCount;
	NSDictionary* _sourceInfo;
*/

}
@end

@interface NCNotificationAction : NSObject 
{	

	NSString* _identifier;
	NSString* _title;
	unsigned long long _activationMode;
	BOOL _requiresAuthentication;
	// NSURL* _launchURL;
	NSString* _launchBundleID;
	unsigned long long _behavior;
	NSDictionary* _behaviorParameters;
	BOOL _destructiveAction;
	BOOL _shouldDismissNotification;

}
@end


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
@end


/*  intercept alarms    */
@interface AlarmManager
+ (id)sharedManager;
- (BOOL)isAlarmNotification:(id)arg1;
@property(readonly, retain, nonatomic) NSArray *alarms;
@end
