//
//  PlaceViewController.m
//  AirTicket
//
//  Created by Оксана Зверева on 21.11.2020.
//

#import "PlaceViewController.h"
#import "City.h"
#import "Airport.h"

#define kReuseIdentifier @"CellIdentifier"

@interface PlaceViewController ()

@property (nonatomic, assign) PlaceType placeType;
@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (nonatomic, copy) NSArray *currentArray;

@end

@implementation PlaceViewController

-(instancetype)initWithType:(PlaceType)type {
    self = [super init];
    if (self) {
     
        self.placeType = type;
    
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kReuseIdentifier];
    
    UISegmentedControl *segments = [[UISegmentedControl alloc] initWithItems:@[ @"Cities", @"Airports"]];
    [segments addTarget:self action: @selector(changeSource:) forControlEvents:UIControlEventValueChanged];
    segments.selectedSegmentIndex = 0;
    segments.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = segments;
    self.segmentedControl = segments;
    [self changeSource: segments];
    
    switch (self.placeType) {
        case PlaceTypeArrival:
            self.title = @"Arrival";
            break;
            
        case PlaceTypeDeparture:
            self.title = @"Departure";
            break;
    }

}

- (void)changeSource: (UISegmentedControl *) sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.currentArray = [[DataManager sharedInstance] cities];
            break;
        case 1:
            self.  currentArray = [[DataManager sharedInstance] airports];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.currentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        City *city = self.currentArray[indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    } else {
        Airport *airport = self.currentArray[indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = ((int)self.segmentedControl.selectedSegmentIndex +1);
    [self.delegate selectPlace:self.currentArray[indexPath.row] withType:self.placeType andDataType:dataType];
    [self.navigationController popViewControllerAnimated:YES];
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
