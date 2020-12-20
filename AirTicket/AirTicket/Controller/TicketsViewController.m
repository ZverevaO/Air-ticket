//
//  TicketsViewController.m
//  AirTicket
//
//  Created by Оксана Зверева on 22.11.2020.
//

#import "TicketsViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataManager.h"
#import "Ticket.h"
#import "NotificationCenter.h"
#define TicketCellReuseIdentifier @"TicketCellIdentifier"



@interface TicketsViewController ()

@property (nonatomic, assign) BOOL isFavorites;
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;
@property (nonatomic, weak) TicketTableViewCell *notificationCell;

@end

@implementation TicketsViewController


- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self)
    {
        self.tickets = tickets;
        //        self.title = @"Tickets";
        //        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:[TicketTableViewCell identifier]];
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.minimumDate = [NSDate date];
        
        self.dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
        self.dateTextField.hidden = YES;
        self.dateTextField.inputView = _datePicker;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
        keyboardToolbar.items = @[flexBarButton, doneBarButton];
        
        self.dateTextField.inputAccessoryView = keyboardToolbar;
        [self.view addSubview: self.dateTextField];
    }
    return self;
}

- (instancetype)initAsFavoriteTickets {
    self = [self initWithTickets:@[]];
    self.isFavorites = YES;
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.isFavorites ? @"Favorites" : @"Tickets";
    self.navigationController.navigationBar.prefersLargeTitles = self.isFavorites;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:[TicketTableViewCell identifier]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFavorites) {
        self.tickets = [[CoreDataManager sharedInstance] favorites];
        [self.tableView reloadData];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tickets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TicketTableViewCell identifier] forIndexPath:indexPath];
    if (self.isFavorites) {
        cell.favorite = self.tickets[indexPath.row];
    } else {
        cell.ticket = self.tickets[indexPath.row];
    }
    
    return cell;
}

#pragma mark - TableViwe Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isFavorites) {
        return;
    }
    
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Ticket actions" message:@"What do you want to do with the ticket?" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:nil];
    Ticket *ticket = self.tickets[indexPath.row];
    CoreDataManager *manager = [CoreDataManager sharedInstance];
    if ([manager isFavorite:ticket]) {
        action = [UIAlertAction actionWithTitle:@"Remove from favorites" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            [manager removeFromFavorite:ticket];
        }];
    } else
    {
        action = [UIAlertAction actionWithTitle:@"Add to favorites" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [manager addToFavorite:ticket];
        }];
    }
    
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"Напомнить" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        self.notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [self.dateTextField becomeFirstResponder];
    }];
    
    
    [sheet addAction:action];
    [sheet addAction:notificationAction];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];
}


- (void)doneButtonDidTap:(UIBarButtonItem *)sender
{
    if (self.datePicker.date && self.notificationCell) {
        NSString *message = [NSString stringWithFormat:@"%@ - %@ за %@ руб.", self.notificationCell.ticket.from, self.notificationCell.ticket.to, self.notificationCell.ticket.price];
        
        NSURL *imageURL;
        if (self.notificationCell.airlineLogoView.image) {
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", self.notificationCell.ticket.airline]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *logo = self.notificationCell.airlineLogoView.image;
                NSData *pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:YES];
                
            }
            imageURL = [NSURL fileURLWithPath:path];
        }
        
        Notification notification = NotificationMake(@"Напоминание о билете", message, self.datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification:notification];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Успешно" message:[NSString stringWithFormat:@"Уведомление будет отправлено - %@", self.datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    self.datePicker.date = [NSDate date];
    self.notificationCell = nil;
    [self.view endEditing:YES];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
