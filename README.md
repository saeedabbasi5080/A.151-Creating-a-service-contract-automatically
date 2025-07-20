# ALProject4 - Service Management Automation

## Overview
ALProject4 is a Microsoft Dynamics 365 Business Central extension that provides automated service contract management and warranty date synchronization functionality. This project enhances the standard service management capabilities by adding automation features for creating service contracts and managing warranty dates.

## Features

### 🔧 Service Contract Automation
- **Automatic Service Contract Creation**: Automatically creates service contracts when sales orders are posted
- **Service Item Integration**: Links service items to sales shipment lines
- **Configurable Automation**: Enable/disable automation through setup

### 📅 Warranty Date Management
- **Automatic Date Synchronization**: Syncs warranty dates between service contracts and service items
- **Date Locking**: Prevents manual changes to warranty dates when enabled
- **Real-time Validation**: Validates warranty date changes immediately

### ⚙️ Setup and Configuration
- **Service Management Setup Extension**: Adds new configuration options
- **Flexible Settings**: Control automation behavior through setup fields

## Technical Architecture

### Codeunits
1. **AutoServiceContractCunit (50101)**
   - Handles automatic service contract creation
   - Integrates with sales posting process
   - Manages service item validation and contract generation

2. **SalesServicePeriodValidationCunit (50102)**
   - Validates service periods during sales document release
   - Ensures proper warranty duration configuration
   - Prevents release of documents with invalid service settings

3. **ServiceContractDateSyncCunit (50103)**
   - Manages warranty date synchronization
   - Prevents manual warranty date changes when locked
   - Handles date validation and error messages

### Tables and Pages
- **Sales&ReceivablesSetupTableExt (50100)**: Extends Service Management Setup table
- **ServiceMgtSetupPageExt (50101)**: Extends Service Management Setup page

## Setup Configuration

### Service Management Setup Fields
- **Service contract automation**: Enable/disable automatic contract creation
- **Auto Service Item Date Update**: Enable/disable automatic date synchronization
- **Locked Service Item**: Enable/disable warranty date locking

## Installation

1. **Prerequisites**
   - Microsoft Dynamics 365 Business Central 12.0 or later
   - AL Development Environment

2. **Installation Steps**
   - Download the `.app` file
   - Install through Business Central Extension Management
   - Configure Service Management Setup

3. **Configuration**
   - Navigate to **Service Management Setup**
   - Configure the new automation fields
   - Set up Service Contract Number Series

## Usage

### Automatic Service Contract Creation
1. Create a sales order with items that have Service Item Groups
2. Ensure Service Item Group has "Create Service Item" enabled
3. Post the sales order
4. Service contracts will be automatically created

### Warranty Date Management
1. Enable "Auto Service Item Date Update" in setup
2. Modify service contract dates
3. Service item warranty dates will be automatically updated

### Date Locking
1. Enable "Locked Service Item" in setup
2. Attempt to modify warranty dates in service items
3. System will prevent changes and show error messages

## Development

### ID Ranges
- **50100-50149**: Reserved for this project

### Platform Requirements
- **Platform**: 12.0.0.0
- **Application**: 12.0.0.0
- **Runtime**: 8.1

### Dependencies
- No external dependencies
- Uses standard Business Central service management functionality

## Version History

### Version 1.0.0.24
- Initial release
- Service contract automation
- Warranty date synchronization
- Setup extensions

## Support

For technical support or questions, please refer to the project documentation or contact the development team.

## License

This project is proprietary software. All rights reserved. 