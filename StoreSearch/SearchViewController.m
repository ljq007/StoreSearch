//
//  SearchViewController.m
//  StoreSearch
//
//  Created by Jack Lee on 13-9-28.
//  Copyright (c) 2013年 ljq007@gmail.com. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchResult.h"

#import "SearchResultCell.h"

static NSString *const SearchResultCellIdentifier = @"SearchResultCell";
static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";

@interface SearchViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController
{
    NSMutableArray *searchResults;
}

@synthesize searchBar = _searchBar;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *cellNib = [UINib nibWithNibName:SearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SearchResultCellIdentifier];
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
    self.tableView.rowHeight = 80;
    
    [self.searchBar becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchResults == nil) {
        return 0;
    } else if ([searchResults count] == 0) {
        return 1;
    } else {
        return [searchResults count];
    }
}

- (NSString *)kindForDisplay:(NSString *)kind
{
    if ([kind isEqualToString:@"album"])
    {
        return @"Album";
    } else if ([kind isEqualToString:@"audiobook"]) {
        return @"Audio Book";
    } else if ([kind isEqualToString:@"book"]) {
        return @"Book";
    } else if ([kind isEqualToString:@"ebook"]) {
        return @"E-Book";
    } else if ([kind isEqualToString:@"feature-movie"]) {
        return @"Movie";
    } else if ([kind isEqualToString:@"music-video"]) {
        return @"Music Video";
    } else if ([kind isEqualToString:@"podcast"]) {
        return @"Podcast";
    } else if ([kind isEqualToString:@"software"]) {
        return @"App";
    } else if ([kind isEqualToString:@"song"]) {
        return @"Song";
    } else if ([kind isEqualToString:@"tv-episode"]) {
        return @"TV Episode";
    } else {
        return kind;
    } }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"SearchResultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    */
    
    
    //SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier];
    
    if ([searchResults count] == 0) {
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier];
        //cell.nameLabel.text = @"(Nothing found)";
        //cell.artistNameLabel.text = @"无";
    } else {
        SearchResultCell *cell = (SearchResultCell *)[tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier];
        
        SearchResult *searchResult = [searchResults objectAtIndex:indexPath.row];
        //SearchResult *searchResult = searchResults[indexPath.row];
        cell.nameLabel.text = searchResult.name;
        //cell.artistNameLabel.text = searchResult.artistName;
        
        NSString *artistName = searchResult.artistName;
        if (artistName == nil) {
            artistName = @"Unknown";
        }
        
        //NSString *kind = searchResult.kind;
        NSString *kind = [self kindForDisplay:searchResult.kind];
        cell.artistNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", artistName, kind];
        
        return cell;
    }
    
    //return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([searchResults count] == 0) {
        return nil;
    } else {
        return indexPath;
    }
}

#pragma mark - parse

- (void)showNetworkError
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Whoops..."
                              message:@"There was an error reading from the iTunes Store. Please try again."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];

    [alertView show];
}

- (SearchResult *)parseTrack:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    
    //searchResult.name = [dictionary objectForKey:@"trackName"];
    searchResult.name = dictionary[@"trackName"];
    
    searchResult.artistName = [dictionary objectForKey:@"artistName"];
    searchResult.artworkURL60 = [dictionary objectForKey:@"artworkUrl60"];
    searchResult.artworkURL100 = [dictionary objectForKey:@"artworkUrl100"];
    searchResult.storeURL = [dictionary objectForKey:@"trackViewUrl"];
    searchResult.kind = [dictionary objectForKey:@"kind"]; searchResult.price = [dictionary objectForKey:@"trackPrice"];
    searchResult.currency = [dictionary objectForKey:@"currency"];
    searchResult.genre = [dictionary objectForKey:@"primaryGenreName"];
    
    return searchResult;
}

- (SearchResult *)parseAudioBook:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    
    searchResult.name = [dictionary objectForKey:@"collectionName"];
    searchResult.artistName = [dictionary objectForKey:@"artistName"];
    searchResult.artworkURL60 = [dictionary objectForKey:@"artworkUrl60"];
    searchResult.artworkURL100 = [dictionary objectForKey:@"artworkUrl100"];
    searchResult.storeURL = [dictionary objectForKey:@"collectionViewUrl"];
    searchResult.kind = @"audiobook";
    searchResult.price = [dictionary objectForKey:@"collectionPrice"];
    searchResult.currency = [dictionary objectForKey:@"currency"];
    searchResult.genre = [dictionary objectForKey:@"primaryGenreName"];
    
    return searchResult;
}

- (SearchResult *)parseSoftware:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    
    searchResult.name = [dictionary objectForKey:@"trackName"];
    searchResult.artistName = [dictionary objectForKey:@"artistName"];
    searchResult.artworkURL60 = [dictionary objectForKey:@"artworkUrl60"];
    searchResult.artworkURL100 = [dictionary objectForKey:@"artworkUrl100"];
    searchResult.storeURL = [dictionary objectForKey:@"trackViewUrl"];
    searchResult.kind = [dictionary objectForKey:@"kind"];
    searchResult.price = [dictionary objectForKey:@"price"];
    searchResult.currency = [dictionary objectForKey:@"currency"];
    searchResult.genre = [dictionary objectForKey:@"primaryGenreName"];
    
    return searchResult;
}

- (SearchResult *)parseEBook:(NSDictionary *)dictionary
{
    SearchResult *searchResult = [[SearchResult alloc] init];
    
    searchResult.name = [dictionary objectForKey:@"trackName"];
    searchResult.artistName = [dictionary objectForKey:@"artistName"];
    searchResult.artworkURL60 = [dictionary objectForKey:@"artworkUrl60"];
    searchResult.artworkURL100 = [dictionary objectForKey:@"artworkUrl100"];
    searchResult.storeURL = [dictionary objectForKey:@"trackViewUrl"];
    searchResult.kind = [dictionary objectForKey:@"kind"];
    searchResult.price = [dictionary objectForKey:@"price"];
    searchResult.currency = [dictionary objectForKey:@"currency"];
    searchResult.genre = [(NSArray *)[dictionary objectForKey:@"genres"] componentsJoinedByString:@", "];
    
    return searchResult;
}

- (void)parseDictionary:(NSDictionary *)dictionary
{
    NSArray *array = [dictionary objectForKey:@"results"];
    if (array == nil) {
        NSLog(@"Expected 'results' array");
        return;
    }
    
    for (NSDictionary *resultDict in array)
    {
        //NSLog(@"wrapperType: %@, kind: %@", [resultDict objectForKey:@"wrapperType"], [resultDict objectForKey:@"kind"]);
        
        SearchResult *searchResult;
        
        NSString *wrapperType = [resultDict objectForKey:@"wrapperType"];
        NSString *kind = [resultDict objectForKey:@"kind"];
        
        if ([wrapperType isEqualToString:@"track"]) {
            searchResult = [self parseTrack:resultDict];
        } else if ([wrapperType isEqualToString:@"audiobook"]) {
            searchResult = [self parseAudioBook:resultDict];
        } else if ([wrapperType isEqualToString:@"software"]) {
            searchResult = [self parseSoftware:resultDict];
        } else if ([kind isEqualToString:@"ebook"]) {
            searchResult = [self parseEBook:resultDict];
        }
        
        if (searchResult != nil) {
            [searchResults addObject:searchResult];
        }
    }
}

- (NSDictionary *)parseJSON:(NSString *)jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (resultObject == nil) {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    if (![resultObject isKindOfClass:[NSDictionary class]]) {
        NSLog(@"JSON Error: Expected dictionary");
        return nil;
    }
    return resultObject;
}

#pragma mark - UISearchBarDelegate

- (NSURL *)urlWithSearchText:(NSString *)searchText
{
    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@", escapedSearchText];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

- (NSString *)performStoreRequestWithURL:(NSURL *)url
{
    NSError *error;
    NSString *resultString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (resultString == nil) {
        NSLog(@"Download Error: %@", error);
        return nil;
    }
    return resultString;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    /*
    [searchBar resignFirstResponder];
    
    searchResults = [NSMutableArray arrayWithCapacity:10];
    
    if (![searchBar.text isEqualToString:@"justin bieber"]) {
        for (int i = 0; i < 3; i++) {
        SearchResult *searchResult = [[SearchResult alloc] init];
        searchResult.name = [NSString stringWithFormat:@"Fake Result %d for", i];
        searchResult.artistName = searchBar.text;
            
        [searchResults addObject:searchResult];
    } }
    
    [self.tableView reloadData];
    */
    
    if ([searchBar.text length] > 0) {
        [searchBar resignFirstResponder];
        searchResults = [NSMutableArray arrayWithCapacity:10];
        NSURL *url = [self urlWithSearchText:searchBar.text];
        //NSLog(@"URL '%@'", url);
        
        NSString *jsonString = [self performStoreRequestWithURL:url];
        if (jsonString == nil) {
            [self showNetworkError];
            return;
        }
        //NSLog(@"Received JSON string '%@'", jsonString);
        
        NSDictionary *dictionary = [self parseJSON:jsonString];
        if (dictionary == nil) {
            [self showNetworkError];
            return;
        }
        //NSLog(@"Dictionary '%@'", dictionary);
        
        [self parseDictionary:dictionary];
        [searchResults sortUsingSelector:@selector(compareName:)];
        
        [self.tableView reloadData];
    }
    
}

@end
