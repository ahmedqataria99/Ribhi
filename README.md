# 🛒 Ribhi — Store Management App

**Ribhi** is a cross-platform store management application built with **Flutter**. It helps shop owners manage their products, sales, expenses, inventory, and view detailed financial reports — all powered by a local SQLite database, with no internet connection required.

---

## ✨ Features

| Feature | Description |
|---|---|
| 📊 **Dashboard** | Overview of key stats: total revenue, profit, expenses, and low-stock alerts |
| 📦 **Products** | Add, edit, delete products with cost/sell prices, categories, and stock levels |
| 🧾 **Sales** | Record product sales and automatically track profits |
| 💸 **Expenses** | Log business expenses with categories, dates, and notes |
| 📈 **Reports** | Visual charts (bar, line, pie) for sales trends and financial summaries |
| 🗃️ **Inventory** | Adjust stock quantities and track discrepancies |
| ⚙️ **Settings** | Configure store name, initial capital, and currency |

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) — BLoC / Cubit pattern
- **Database**: [sqflite](https://pub.dev/packages/sqflite) + [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi_web) (Desktop/Web support)
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Fonts**: [google_fonts](https://pub.dev/packages/google_fonts)
- **Icons**: [flutter_svg](https://pub.dev/packages/flutter_svg)
- **Architecture**: Clean Architecture (Data → Domain → Presentation layers)

---

## 🗄️ Database Schema

The app uses a local SQLite database (`origo_store.db`) with the following tables and relationships:

```
┌─────────────────────────────────────────────────────────────────────┐
│                        DATABASE SCHEMA                               │
└─────────────────────────────────────────────────────────────────────┘

┌──────────────┐          ┌───────────────────────────────────────────┐
│  categories  │          │                 products                   │
├──────────────┤          ├───────────────────────────────────────────┤
│ id PK        │          │ id            PK                           │
│ name UNIQUE  │          │ name          TEXT NOT NULL                │
│ type         │          │ cost_price    REAL DEFAULT 0               │
│ created_at   │          │ sell_price    REAL DEFAULT 0               │
└──────────────┘          │ quantity      INTEGER DEFAULT 0            │
                          │ category      TEXT                         │
                          │ category_type TEXT                         │
                          │ min_stock_level INTEGER DEFAULT 0          │
┌──────────────┐          │ created_at    TEXT                         │
│   settings   │          │ updated_at    TEXT                         │
├──────────────┤          └──────────────────┬────────────────────────┘
│ id PK        │                             │ (1 product → many)
│ store_name   │              ┌──────────────┴──────────────┐
│ initial_cap  │              │                             │
│ currency     │              ▼                             ▼
│ is_activated │   ┌──────────────────┐     ┌──────────────────────────┐
│ license_key  │   │      sales       │     │  inventory_adjustments   │
│ created_at   │   ├──────────────────┤     ├──────────────────────────┤
│ updated_at   │   │ id PK            │     │ id PK                    │
└──────────────┘   │ product_id FK ───┘     │ product_id FK ───────────┘
                   │ quantity         │     │ system_quantity           │
                   │ sell_price_snap  │     │ actual_quantity           │
                   │ cost_price_snap  │     │ difference                │
                   │ profit           │     │ date                      │
                   │ amount           │     └──────────────────────────┘
                   │ created_at       │
                   └──────────────────┘

┌──────────────────────────┐
│         expenses         │
├──────────────────────────┤
│ id PK                    │
│ title     TEXT NOT NULL  │
│ amount    REAL DEFAULT 0 │
│ category  TEXT           │
│ date      TEXT           │
│ notes     TEXT           │
└──────────────────────────┘
```

### Table Relationships

```
products ──< sales                  (one-to-many, CASCADE DELETE)
products ──< inventory_adjustments  (one-to-many, CASCADE DELETE)
```

### Database Indexes

| Index | Table | Column |
|---|---|---|
| `idx_products_name` | products | name |
| `idx_products_category` | products | category |
| `idx_sales_product_id` | sales | product_id |
| `idx_sales_created_at` | sales | created_at |
| `idx_expenses_date` | expenses | date |

---

## 📁 Project Structure

```
lib/
├── main.dart                         # App entry point, DI setup
├── core/
│   ├── AppColor/                     # App color constants
│   ├── constant/                     # Shared constants
│   ├── database/
│   │   ├── Appdatabase.dart          # Abstract DB interface
│   │   ├── databaseHelper.dart       # Singleton DB helper
│   │   └── databaseSqlite.dart       # Table creation SQL
│   ├── errors/                       # Error/failure classes
│   ├── theme/                        # Light/dark theme config
│   └── utils/                        # Utility helpers
└── features/
    ├── Dashboard/                    # Home screen with stats & charts
    ├── products/                     # Product CRUD management
    ├── sales/                        # Sales recording
    ├── Expenses/                     # Expense tracking
    ├── reports/                      # Financial reports & charts
    ├── Inventory/                    # Inventory adjustment
    └── Initialization/               # First-run store setup
```

Each feature follows **Clean Architecture**:
```
feature/
├── data/
│   ├── datasource/   # SQLite queries
│   ├── models/       # Data models
│   └── repo/         # Repository implementations
├── domain/
│   ├── entities/     # Business entities
│   ├── repo/         # Abstract repository interfaces
│   └── usecases/     # Business logic use cases
└── presentation/
    ├── cubit/        # BLoC Cubit state management
    └── ui/
        ├── screens/  # Full page screens
        └── widgets/  # Reusable UI components
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `^3.10.4`
- Dart SDK `^3.10.4`

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/ahmedqataria99/Ribhi.git
cd ribhi

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Supported Platforms

| Platform | Status |
|---|---|
| 🪟 Windows | ✅ Supported |
| 🐧 Linux | ✅ Supported |
| 🍎 macOS | ✅ Supported |
| 📱 Android | ✅ Supported |
| 🍏 iOS | ✅ Supported |
| 🌐 Web | ✅ Supported (via sqflite_common_ffi_web) |

---

## 📦 Key Dependencies

```yaml
flutter_bloc: ^8.1.3       # State management
sqflite: ^2.4.2            # Local SQLite database
sqflite_common_ffi_web: ^0.4.5+1  # Desktop/Web SQLite
fl_chart: ^0.66.0          # Charts and graphs
google_fonts: ^6.1.0       # Typography
flutter_svg: ^2.0.10+1     # SVG icon support
gap: ^3.0.1                # Spacing utility
modal_progress_hud_nsn: ^0.5.1  # Loading overlay
```

---

## 📄 License

This project is private and not published to pub.dev.

---

> Built with Origo using Flutter
