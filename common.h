#import <UIKit/UIKit.h>

@interface Alarm : NSObject
-(NSString *)alarmID;
@end

@interface EditAlarmViewController : UIViewController
- (void)loadView;
- (void)_doneButtonClicked:(id)arg1;
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
