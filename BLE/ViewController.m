//
//  ViewController.m
//  BLE
//
//  Created by Ai on 2/22/17.
//  Copyright © 2017 headsup. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *_manager;

@end

@implementation ViewController {
    CBMutableService        *_service;
    CBMutableCharacteristic *_controlChar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupANCS];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupANCS
{
    self._manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_queue_create("com.headsup.BLE", DISPATCH_QUEUE_SERIAL) options:@{CBPeripheralManagerOptionRestoreIdentifierKey: @"com.headsup.BLE"}];
}

- (void)prepareService
{
    _controlChar = [[CBMutableCharacteristic alloc]initWithType:[CBUUID UUIDWithString:@"629B4394-7040-49C5-B0D0-218AB5FC92CD"] properties:(CBCharacteristicPropertyRead|CBCharacteristicPropertyWrite|CBCharacteristicPropertyNotifyEncryptionRequired) value:nil permissions:(CBAttributePermissionsReadEncryptionRequired|CBAttributePermissionsWriteEncryptionRequired)];
    
    _service = [[CBMutableService alloc]initWithType:[CBUUID UUIDWithString:@"C70CB8F3-BB87-4412-B2D4-A90702ABDA0F"] primary:YES];
    
    _service.characteristics = @[_controlChar];
    
    [self._manager addService:_service];
}

- (void)startAdv
{
    NSDictionary *advData = @{CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:@"C70CB8F3-BB87-4412-B2D4-A90702ABDA0F"]]};
    [self._manager startAdvertising:advData];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary *)dict
{
    NSLog(@"RestoreWithDict:%@",dict);
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBManagerStatePoweredOn) {
        [self prepareService];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    if (!error) {
        NSLog(@"StartAdv");
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error
{
    if (!error) {
        [self startAdv];
    }
}


@end
