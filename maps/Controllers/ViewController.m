//
//  ViewController.m
//  maps
//
//  Created by Treinamento Mobile on 10/24/15.
//  Copyright © 2015 Treinamento Mobile. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, weak) IBOutlet UITextField *addressField;
@property (nonatomic, weak) IBOutlet UITextField *latField;
@property (nonatomic, weak) IBOutlet UITextField *lonField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = @"MASP";
    annotation.subtitle = @"São Paulo";
    annotation.coordinate = CLLocationCoordinate2DMake(-23.56136640838073, -46.6562633199172);
    [self.mapView showAnnotations:@[annotation] animated:YES];
    [self.mapView selectAnnotation:annotation animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    NSString *identifier = @"MyPin";
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.layer.cornerRadius = 15.0f;
    imageView.layer.masksToBounds = YES;
    imageView.image = [UIImage imageNamed:@"masp"];
    annotationView.rightCalloutAccessoryView = imageView;
    return annotationView;
}

# pragma mark - Actions
- (IBAction)searchAdress:(id)sender {
    NSLog(@"%@", self.addressField.text);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSString *address = self.addressField.text;
    
    
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                     CLPlacemark *placemark = [placemarks firstObject];
                     NSLog(@"%@", placemark);
                     if(placemarks.count > 0)
                     {
                         CLPlacemark *placemark = [placemarks objectAtIndex:0];
                         //self.outputLabel.text = placemark.location.description;
                         
                         [self setInMap:placemark.location.coordinate.latitude
                              longitude:placemark.location.coordinate.longitude];
                     }
                 }];
    
}

- (IBAction)searchLatLon:(id)sender {
    NSLog(@"%@", self.latField.text);
    NSLog(@"%@", self.lonField.text);
    
    float latitude = [self.latField.text floatValue];
    float longitude = [self.lonField.text floatValue];
    
    [self setInMap:latitude longitude:longitude];
}

- (void)setInMap:(float) latitude longitude:(float) longitude {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.title = @"Resultado da Busca";
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [self.mapView showAnnotations:@[annotation] animated:YES];
    [self.mapView selectAnnotation:annotation animated:YES];
}

@end
