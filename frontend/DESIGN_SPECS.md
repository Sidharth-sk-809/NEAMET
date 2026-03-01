# NEAMET - UI/UX Design Specifications

## Design System Overview

The NEAMET app uses a modern, clean design language inspired by premium grocery delivery apps like Blinkit and Zepto. The design focuses on clarity, efficiency, and delightful interactions.

## Color Palette

```
Primary Green       #22C55E    (Main actions, highlights)
Dark Green          #16A34A    (Secondary highlights)
Light Green         #F0FDF4    (Backgrounds, badges)
White               #FFFFFF    (Main background)
Gray Light          #FAFAFA    (Secondary background)
Gray Medium         #E5E7EB    (Borders)
Gray Dark           #6B7280    (Secondary text)
Text Primary        #1F2937    (Main text)
Error Red           #EF4444    (Error states)
```

## Typography

```
Heading Large       28px Bold     (Titles, section headers)
Heading Medium      24px Bold     (Page headers)
Heading Small       20px Semibold (Card titles)
Title Large         18px Semibold (AppBar titles)
Title Medium        16px Semibold (Subheadings)
Body Large          16px Regular  (Primary text)
Body Medium         14px Regular  (Secondary text)
Body Small          12px Regular  (Labels, hints)
```

## Spacing Scale (Vertical Rhythm)

```
4px    - XSmall (minimal spacing)
8px    - Small  (component padding)
12px   - Medium (card padding)
16px   - Large  (section spacing)
20px   - XLarge (major spacing)
24px   - XXLarge(vertical sections)
```

## Border Radius

```
8px    - Small items, subtle corners
12px   - Medium components
16px   - Large cards, inputs
20px   - Extra large containers
22px   - Product cards, modals
```

## Shadows

### Soft Shadow (Cards)
```
Blur: 8px
Offset: 0, 2px
Color: rgba(0,0,0, 6%)
```

### Medium Shadow (Floating)
```
Blur: 12px
Offset: 0, 4px
Color: rgba(0,0,0, 8%)
```

## Screen-by-Screen Design

### 1. LOGIN SCREEN

**Layout**
- Centered logo badge with green background
- Form section with email/password fields
- Login button (full-width, green)
- Demo credentials helper box

**Components**
- Logo: "NEAMET" text in green
- Text Fields: 
  - Border radius: 16px
  - Background: Light gray
  - Padding: 16px all
  - Focus: Green border, 2px width
- Button:
  - Background: Green
  - Text: White, Semibold
  - Padding: Vertical 16px
  - Border Radius: 16px

**States**
- Error: Red background box with error message
- Loading: Spinner in button
- Demo box: Light gray border, rounded

### 2. CUSTOMER HOME SCREEN

**Layout**
- AppBar with logo and logout
- Greeting message (dynamic)
- Search bar with clear button
- Distance filter chips (horizontal scroll)
- Product grid (2 columns)

**Product Card** (Individual item)
- Image placeholder: 160px height
- Product name (2 lines max)
- Shop name (1 line)
- Shop category (grayed, 1 line)
- Bottom row:
  - Left: Price (green, bold) + Distance badge (green background)
  - Right: Add button (compact)

**Distance Chips**
- Size: 2km, 5km, 10km
- Selected: Green background, white text
- Unselected: Gray border, gray text
- Spacing: 8px horizontal gap

**FAB (Floating Action Button)**
- Green background
- Shows when cart has items
- Text: "Cart (n items)"
- Icon: Shopping bag

### 3. CART SCREEN

**Layout**
- AppBar with "Your Cart" title
- Items grouped by shop sections
- Summary card (floating style)
- "Buy Now" button (sticky bottom)
- "Continue Shopping" button

**Shop Section**
- Header: Light green background, shop name and category
- Items: List of CartItem widgets
- Dividers: Light gray between items
- Border Radius: 16px with separate top/bottom corners

**Cart Item Widget**
- Layout: Image left (100x100), content right
- Image: Rounded 16px
- Text: Product name, shop name
- Controls: Quantity +/- with border
- Price: Right aligned, green

**Summary Card**
- Background: Light gray with border
- Sections: Product Total, Distance, Delivery Cost (with divider), Grand Total
- Grand Total: Green text, bold
- Border Radius: 20px

### 4. ORDER STATUS SCREEN

**Layout**
- Status header (light green box, centered)
- Delivery partner info card (if assigned)
- Order details card
- Order items list
- Back button at bottom

**Status Header**
- Icon: Check/truck in green circle
- Status text: "Out for Delivery" / "Waiting..."
- Order ID: Gray text
- Colors: Light green background
- Emoji/icon: Centered, large

**Info Cards**
- Background: Light gray surface
- Border: Light gray 1px
- Padding: 16px all
- Border Radius: 20px

**Items List**
- Each item in separate card
- Image left, details right OR text left, price right
- Dividers between items

### 5. EMPLOYEE DASHBOARD

**Layout**
- Greeting header
- "Available Orders" label
- Order cards list
- Pull-to-refresh enabled

**Order Card** (For employees)
- Order ID with badge (item count)
- Shops list: Chip list (gray background)
- Distance + Earnings in columns
- Accept button: Green, full-width
- Border Radius: 20px shadows

**Logo Header**
- "NEAMET" text in green (same as customer)
- Logout icon top right

### 6. DELIVERY SCREEN

**Layout**
- Status header (Out for Delivery)
- Customer info card
- Delivery details card
- Items list
- Back to dashboard button

**Similar to Order Status** but:
- Focus on delivery metrics (distance, earnings)
- Customer ID highlighted
- Background: Light green sections

## Interactive States

### Buttons
- **Default**: Full color background
- **Pressed**: Darker shade (10% darker)
- **Disabled**: Grayed out with 50% opacity
- **Loading**: Spinner animation inside

### Text Fields
- **Default**: Gray border, light gray background
- **Focused**: Green border (2px), light gray background
- **Error**: Red border, light gray background
- **Disabled**: Gray background, gray text

### Cards
- **Default**: Soft shadow
- **Hover**: Slightly darker shadow on mobile (press effect)

### Chips
- **Default**: Gray border, gray text
- **Selected**: Green background, white text

## Animations

### Transitions
- Page transitions: Fade + Slide (200ms)
- Button presses: Ripple effect
- Loading: Smooth shimmer placeholders

### Micro-interactions
- Cart add: Toast confirmation
- Quantity change: Instant UI update
- Search: Debounced (300ms)

## Responsive Design

### Breakpoints
- Mobile: < 600px (default)
- Tablet: 600px - 1200px
- Grid adjusts for larger screens

### Assets
- Product images: Responsive sizing
- Text: Scaled appropriately
- Spacing: Proportional scaling

## Dark Mode (Future)

When implemented:
- Inverses colors appropriately
- Maintains contrast ratios (WCAG AA)
- Uses dark gray for primary dark color

## Accessibility

- Text contrast: Minimum 4.5:1 for readability
- Touch targets: Minimum 48x48dp
- Icons: Always paired with text or labels
- Form labels: Clear and associated properly
- Error messages: Color + text description

## Loading States

### Skeleton Loaders (Shimmer)
- Card-shaped placeholders
- Animated gray gradient
- Match final card dimensions

### Progress Indicators
- Circular progress in buttons
- Linear progress for pages (future)

### Empty States
- Large icon (80px)
- Centered layout
- Centered text with explanation
- Optional retry button

## Design Tokens Summary

```dart
// Colors
primaryGreen: #22C55E
darkGreen: #16A34A
lightGreen: #F0FDF4
// + grays and neutrals

// Spacing
12px / 16px / 20px / 24px

// Border Radius
16px / 20px / 22px

// Shadows
soft: blur 8, offset 0,2, 6% opacity
```

## Implementation Notes

1. All rounded corners use BorderRadius.circular() 
2. All shadows use BoxShadow definitions from theme.dart
3. All spacing uses AppTheme constants
4. All colors from AppTheme class
5. Text styles from Material textTheme
6. Reuse widgets for consistency

This design system ensures visual consistency, excellent UX, and adherence to modern mobile design principles.
