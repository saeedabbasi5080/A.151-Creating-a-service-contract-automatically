# ALProject4 - Service Management Automation

## خلاصه
ALProject4 یک افزونه Microsoft Dynamics 365 Business Central است که قابلیت‌های اتوماسیون مدیریت قراردادهای خدمات و همگام‌سازی تاریخ‌های گارانتی را فراهم می‌کند. این پروژه قابلیت‌های استاندارد Service Management را با افزودن ویژگی‌های اتوماسیون برای ایجاد Service Contract و مدیریت تاریخ‌های گارانتی بهبود می‌دهد.

## ویژگی‌ها

### 🔧 Service Contract Automation
- **Automatic Service Contract Creation**: به طور خودکار Service Contract را هنگام ثبت Sales Order ایجاد می‌کند
- **Service Item Integration**: Service Item را با Sales Shipment Line مرتبط می‌کند
- **Configurable Automation**: فعال/غیرفعال کردن اتوماسیون از طریق Setup

### 📅 Warranty Date Management
- **Automatic Date Synchronization**: تاریخ‌های گارانتی را بین Service Contract و Service Item همگام می‌کند
- **Date Locking**: از تغییرات دستی تاریخ‌های گارانتی جلوگیری می‌کند
- **Real-time Validation**: تغییرات تاریخ گارانتی را فوراً اعتبارسنجی می‌کند

### ⚙️ Setup and Configuration
- **Service Management Setup Extension**: گزینه‌های پیکربندی جدید اضافه می‌کند
- **Flexible Settings**: کنترل رفتار اتوماسیون از طریق Setup Fields

## Technical Architecture

### Codeunits
1. **AutoServiceContractCunit (50101)**
   - مدیریت ایجاد خودکار Service Contract
   - ادغام با فرآیند Sales Posting
   - مدیریت اعتبارسنجی Service Item و تولید Contract

2. **SalesServicePeriodValidationCunit (50102)**
   - اعتبارسنجی Service Period در حین Release Sales Document
   - اطمینان از پیکربندی صحیح Default Warranty Duration
   - جلوگیری از Release اسناد با تنظیمات Service نامعتبر

3. **ServiceContractDateSyncCunit (50103)**
   - مدیریت همگام‌سازی تاریخ گارانتی
   - جلوگیری از تغییرات دستی تاریخ گارانتی هنگام Locked Service Item
   - مدیریت اعتبارسنجی تاریخ و پیام‌های خطا

### Tables and Pages
- **Sales&ReceivablesSetupTableExt (50100)**: گسترش جدول Service Management Setup
- **ServiceMgtSetupPageExt (50101)**: گسترش صفحه Service Management Setup

## Setup Configuration

### Service Management Setup Fields
- **Service contract automation**: فعال/غیرفعال کردن ایجاد خودکار Service Contract
- **Auto Service Item Date Update**: فعال/غیرفعال کردن همگام‌سازی خودکار تاریخ
- **Locked Service Item**: فعال/غیرفعال کردن قفل تاریخ گارانتی

## Installation

1. **Prerequisites**
   - Microsoft Dynamics 365 Business Central 12.0 یا بالاتر
   - AL Development Environment

2. **Installation Steps**
   - دانلود فایل `.app`
   - نصب از طریق Business Central Extension Management
   - پیکربندی Service Management Setup

3. **Configuration**
   - مراجعه به **Service Management Setup**
   - پیکربندی فیلدهای اتوماسیون جدید
   - تنظیم Service Contract Number Series

## Usage

### Automatic Service Contract Creation
1. ایجاد Sales Order با آیتم‌هایی که Service Item Group دارند
2. اطمینان از فعال بودن "Create Service Item" در Service Item Group
3. ثبت Sales Order
4. Service Contract به طور خودکار ایجاد می‌شود

### Warranty Date Management
1. فعال کردن "Auto Service Item Date Update" در Setup
2. تغییر تاریخ‌های Service Contract
3. تاریخ‌های گارانتی Service Item به طور خودکار به‌روزرسانی می‌شوند

### Date Locking
1. فعال کردن "Locked Service Item" در Setup
2. تلاش برای تغییر تاریخ‌های گارانتی در Service Item
3. سیستم از تغییرات جلوگیری کرده و پیام خطا نمایش می‌دهد

## Development

### ID Ranges
- **50100-50149**: رزرو شده برای این پروژه

### Platform Requirements
- **Platform**: 12.0.0.0
- **Application**: 12.0.0.0
- **Runtime**: 8.1

### Dependencies
- بدون وابستگی خارجی
- از قابلیت‌های استاندارد Service Management Business Central استفاده می‌کند

## Version History

### Version 1.0.0.24
- انتشار اولیه
- Service Contract Automation
- Warranty Date Synchronization
- Setup Extensions

## Support

برای پشتیبانی فنی یا سوالات، لطفاً به مستندات پروژه مراجعه کنید یا با تیم توسعه تماس بگیرید.

## License

این پروژه نرم‌افزار اختصاصی است. تمام حقوق محفوظ است. 