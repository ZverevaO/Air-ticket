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
#define TicketCellReuseIdentifier @"TicketCellIdentifier"



@interface TicketsViewController ()

@property (nonatomic, assign) BOOL isFavorites;
@property (nonatomic, strong) NSArray *tickets;
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
    
    [sheet addAction:action];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];
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
