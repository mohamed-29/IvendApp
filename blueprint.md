# Vending Machine Monitoring App - Blueprint

## 1. Overview
A Flutter mobile application for monitoring vending machines. The app features a secure login, a real-time dashboard displaying machine statuses and statistics, and detailed views for individual machines and product stock levels.

## 2. Core Features & Design
*   **Authentication:** Secure user login using a token-based system.
*   **Dashboard:** A central screen providing an at-a-glance overview of the entire vending machine network, including:
    *   Total number of machines.
    *   Count of online vs. offline machines.
    *   A summary of products that need restocking.
*   **Machine Details:** An expandable list of all machines, showing:
    *   Real-time status (Online/Offline).
    *   Current temperature.
    *   Last update time, displayed in a human-readable format (e.g., "5 minutes ago").
    *   A "View Products" button to navigate to the product inventory screen.
*   **Product Inventory:** A detailed view for each machine, listing all its products, their stock levels, and prices.
*   **Styling:** A modern and clean user interface inspired by the provided web dashboard, with a professional color scheme, clear typography, and intuitive icons.

## 3. Current Task: Modern UI/UX Redesign
This phase involved a complete overhaul of the application's design to create a modern, user-friendly, and visually appealing experience.

*   **Step 1: Add `google_fonts` Package** - (Complete) Added `google_fonts` for improved typography.
*   **Step 2: Redefine the App's Theme** - (Complete) Updated `main.dart` with a new, vibrant theme, custom fonts, and styled components.
*   **Step 3: Redesign the Dashboard** - (Complete) Updated `dashboard_screen.dart` with intuitive stat cards, improved machine list, and better use of iconography and shadows.
*   **Step 4: Redesign the Login Screen** - (Complete) Updated `login_screen.dart` to be more welcoming with a modern layout and improved styling.
*   **Step 5: Redesign the Products Screen** - (Complete) Enhanced `products_screen.dart` to be more scannable and visually organized, with larger product images and clearer information hierarchy.
