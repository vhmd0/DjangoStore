# DESIGN.md — Shopify-School Design Blueprint

> **Stack:** Django · Tailwind CSS · Flowbite · Alpine.js · HTMX
> **Philosophy:** Shopify Polaris — clarity, calm, confidence.
> **Audience:** Solo developer. No team overhead. Copy-paste ready.

---

## Table of Contents

1. [Design Principles](#1-design-principles)
2. [Tailwind Configuration](#2-tailwind-configuration)
3. [Color System](#3-color-system)
4. [Typography](#4-typography)
5. [Spacing & Layout Grid](#5-spacing--layout-grid)
6. [Buttons](#6-buttons)
7. [Form Controls](#7-form-controls)
8. [Badges & Status Indicators](#8-badges--status-indicators)
9. [Cards](#9-cards)
10. [Smart Components](#10-smart-components)
    - [Product Card](#product-card)
    - [Cart Drawer](#cart-drawer)
    - [Fraud Alert Banner](#gemini-ai-fraud-alert-banner)
    - [Toast Notifications](#toast-notifications)
    - [Confirmation Dialog](#confirmation-dialog)
11. [HTMX Patterns](#11-htmx-patterns)
12. [Alpine.js Patterns](#12-alpinejs-patterns)
13. [Django Template Conventions](#13-django-template-conventions)
14. [Accessibility Checklist](#14-accessibility-checklist)
15. [Solo Developer Best Practices](#15-solo-developer-best-practices)

---

## 1. Design Principles

These five rules govern every pixel in the application. When in doubt, apply them in order.

| # | Principle | What It Means |
|---|-----------|---------------|
| 1 | **Clarity over cleverness** | Every element must communicate its purpose instantly. No decorative-only elements. |
| 2 | **Content is the interface** | Products, prices, and actions lead. Chrome recedes. |
| 3 | **Calm confidence** | Neutral surfaces, restrained color, generous whitespace. Color appears only to signify *meaning*. |
| 4 | **Progressive disclosure** | Show the minimum first. Reveal details on demand (drawers, collapses, modals). |
| 5 | **Speed is a feature** | Partial swaps via HTMX. No full-page reloads. Skeleton loaders over blank screens. |

---

## 2. Tailwind Configuration

Drop this into your `tailwind.config.js`. This is the **single source of truth** for the design system.

```js
// tailwind.config.js
const defaultTheme = require('tailwindcss/defaultTheme');

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './templates/**/*.html',
    './apps/**/templates/**/*.html',
    './static/js/**/*.js',
    './node_modules/flowbite/**/*.js',
  ],

  theme: {
    extend: {
      // ─── SHOPIFY POLARIS COLOR SYSTEM ───────────────────────
      colors: {
        shopify: {
          // Surface hierarchy (light backgrounds → borders → deeper chrome)
          'surface':       '#FFFFFF',
          'surface-alt':   '#F6F6F7',
          'surface-hover': '#F1F2F3',
          'surface-press': '#EDEEEF',
          'surface-sub':   '#FAFBFB',

          // Borders & dividers
          'border':        '#E1E3E5',
          'border-sub':    '#D2D5D8',
          'border-focus':  '#458FFF',

          // Interactive (Primary blue — the main CTA color)
          'interactive':       '#2C6ECB',
          'interactive-hover': '#1F5199',
          'interactive-press': '#103262',
          'interactive-sub':   '#BBD4F1',

          // Text hierarchy
          'text':          '#202223',
          'text-sub':      '#6D7175',
          'text-disabled': '#8C9196',
          'text-on-interactive': '#FFFFFF',

          // Critical (destructive actions, errors)
          'critical':       '#D72C0D',
          'critical-hover': '#BC2200',
          'critical-press': '#A21B00',
          'critical-sub':   '#FFF4F4',
          'critical-icon':  '#D72C0D',

          // Success (confirmations, positive states)
          'success':       '#008060',
          'success-hover': '#006E52',
          'success-sub':   '#F1F8F5',
          'success-icon':  '#007F5F',

          // Warning (caution states)
          'warning':       '#FFC453',
          'warning-hover': '#FFBA37',
          'warning-sub':   '#FFF5EA',
          'warning-icon':  '#B98900',

          // Highlight (informational)
          'highlight':     '#5BCDDA',
          'highlight-sub': '#EBF9FC',
          'highlight-icon':'#00A0AC',
        },
      },

      // ─── TYPOGRAPHY ─────────────────────────────────────────
      fontFamily: {
        sans: [
          '-apple-system',
          'BlinkMacSystemFont',
          'San Francisco',
          'Segoe UI',
          'Roboto',
          'Helvetica Neue',
          'sans-serif',
          ...defaultTheme.fontFamily.sans,
        ],
      },

      fontSize: {
        'display-lg': ['2.625rem', { lineHeight: '3rem',    fontWeight: '700', letterSpacing: '-0.02em' }],
        'display':    ['1.75rem',  { lineHeight: '2.25rem', fontWeight: '700', letterSpacing: '-0.01em' }],
        'heading':    ['1.25rem',  { lineHeight: '1.75rem', fontWeight: '600' }],
        'subheading': ['0.8125rem',{ lineHeight: '1.125rem',fontWeight: '700', letterSpacing: '0.04em', textTransform: 'uppercase' }],
        'body':       ['0.875rem', { lineHeight: '1.25rem', fontWeight: '400' }],
        'body-sm':    ['0.8125rem',{ lineHeight: '1.125rem',fontWeight: '400' }],
        'caption':    ['0.75rem',  { lineHeight: '1rem',    fontWeight: '400' }],
      },

      // ─── SHADOWS (Polaris depth tokens) ─────────────────────
      boxShadow: {
        'shopify-card':    '0 0 0 1px rgba(63,63,68,0.05), 0 1px 3px 0 rgba(63,63,68,0.15)',
        'shopify-dialog':  '0 26px 80px rgba(0,0,0,0.2), 0 0 1px rgba(0,0,0,0.2)',
        'shopify-popover': '0 3px 6px -3px rgba(23,24,24,0.08), 0 8px 20px -4px rgba(23,24,24,0.12)',
        'shopify-button':  '0 1px 0 rgba(0,0,0,0.05)',
        'shopify-inset':   'inset 0 1px 2px rgba(0,0,0,0.1)',
      },

      // ─── BORDER RADIUS ──────────────────────────────────────
      borderRadius: {
        'shopify':    '0.5rem',   // 8px — cards, modals, inputs
        'shopify-sm': '0.375rem', // 6px — buttons, badges
        'shopify-lg': '0.75rem',  // 12px — larger containers
        'shopify-xl': '1rem',     // 16px — prominent surfaces
      },

      // ─── TRANSITION ─────────────────────────────────────────
      transitionDuration: {
        'shopify': '200ms',
      },

      // ─── Z-INDEX SCALE ──────────────────────────────────────
      zIndex: {
        'navbar':  '40',
        'drawer':  '50',
        'modal':   '60',
        'popover': '70',
        'toast':   '80',
      },
    },
  },

  plugins: [
    require('flowbite/plugin'),
  ],
};
```

---

## 3. Color System

### When to Use Each Color

| Token | Tailwind Class | Use For |
|-------|----------------|---------|
| `shopify-surface` | `bg-shopify-surface` | Page background, card backgrounds |
| `shopify-surface-alt` | `bg-shopify-surface-alt` | Secondary backgrounds, table headers, sidebars |
| `shopify-border` | `border-shopify-border` | Card borders, dividers, input borders |
| `shopify-interactive` | `bg-shopify-interactive` | Primary buttons, active links, focus rings |
| `shopify-text` | `text-shopify-text` | Headings, body text, primary labels |
| `shopify-text-sub` | `text-shopify-text-sub` | Descriptions, helper text, timestamps |
| `shopify-critical` | `bg-shopify-critical` | Delete buttons, error messages, stock alerts |
| `shopify-success` | `bg-shopify-success` | In-stock badges, success toasts, payment confirmed |
| `shopify-warning` | `bg-shopify-warning-sub` | Low-stock warnings, pending statuses |

### Color Budget Rule

> **80% neutral** (surface, border, text) · **15% interactive blue** (CTAs, links) · **5% semantic** (red/green/yellow — only when something *means* danger/success/caution).

---

## 4. Typography

### Type Scale Reference

| Role | Tailwind Classes | Example Use |
|------|-----------------|-------------|
| Display Large | `text-display-lg text-shopify-text` | Hero section headline |
| Display | `text-display text-shopify-text` | Page title ("All Products") |
| Heading | `text-heading text-shopify-text` | Card headers, section titles |
| Subheading | `text-subheading text-shopify-text-sub uppercase tracking-wider` | Table column headers, meta labels |
| Body | `text-body text-shopify-text` | Product descriptions, form labels |
| Body Small | `text-body-sm text-shopify-text-sub` | Helper text, secondary info |
| Caption | `text-caption text-shopify-text-disabled` | Timestamps, footnotes |

### Copy-Paste: Page Title

```html
<div class="mb-6">
  <h1 class="text-display text-shopify-text">Products</h1>
  <p class="text-body text-shopify-text-sub mt-1">Manage your store inventory</p>
</div>
```

---

## 5. Spacing & Layout Grid

### The 4px Base Grid

All spacing uses multiples of 4px. Tailwind's default scale maps directly:

| Tailwind | Pixels | Use For |
|----------|--------|---------|
| `p-1` / `gap-1` | 4px | Icon padding, tight badge padding |
| `p-2` / `gap-2` | 8px | Inline element spacing |
| `p-3` / `gap-3` | 12px | Button padding, small card padding |
| `p-4` / `gap-4` | 16px | **Standard** — card padding, section spacing |
| `p-5` / `gap-5` | 20px | Card headers, form group spacing |
| `p-6` / `gap-6` | 24px | Section separations, page padding |
| `p-8` / `gap-8` | 32px | Major section breaks |

### Page Layout Shell

```html
{# shared/base.html — Main content area #}
<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
  {% block content %}{% endblock %}
</main>
```

### Responsive Grid Patterns

```html
{# 1-2-3-4 column product grid #}
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 lg:gap-6">
  {% for product in products %}
    {% include 'products/_card.html' %}
  {% endfor %}
</div>

{# Sidebar + Content (Profile, Filters) #}
<div class="flex flex-col lg:flex-row gap-6 lg:gap-8">
  <aside class="lg:w-1/4 xl:w-1/5">...</aside>
  <div class="lg:w-3/4 xl:w-4/5">...</div>
</div>
```

---

## 6. Buttons

### Button System

All buttons use border-radius `rounded-shopify-sm` and consistent padding. Never mix styles.

#### Primary Button

The **only** blue element on the page. Use for the single most important action.

```html
<button type="submit"
  class="inline-flex items-center justify-center px-4 py-2 text-sm font-semibold
         text-shopify-text-on-interactive bg-shopify-interactive
         border border-transparent rounded-shopify-sm
         shadow-shopify-button
         hover:bg-shopify-interactive-hover
         active:bg-shopify-interactive-press
         focus:outline-none focus:ring-2 focus:ring-shopify-border-focus focus:ring-offset-2
         transition-colors duration-shopify
         disabled:opacity-50 disabled:cursor-not-allowed">
  <i class="bi bi-plus-lg me-2 text-base"></i>
  Add product
</button>
```

#### Secondary Button (Outline)

For supplementary actions alongside a primary button.

```html
<button type="button"
  class="inline-flex items-center justify-center px-4 py-2 text-sm font-semibold
         text-shopify-text bg-shopify-surface
         border border-shopify-border-sub rounded-shopify-sm
         shadow-shopify-button
         hover:bg-shopify-surface-hover
         active:bg-shopify-surface-press
         focus:outline-none focus:ring-2 focus:ring-shopify-border-focus focus:ring-offset-2
         transition-colors duration-shopify">
  Cancel
</button>
```

#### Destructive Button

Only for irreversible actions (delete, cancel order).

```html
<button type="button"
  class="inline-flex items-center justify-center px-4 py-2 text-sm font-semibold
         text-white bg-shopify-critical
         border border-transparent rounded-shopify-sm
         shadow-shopify-button
         hover:bg-shopify-critical-hover
         active:bg-shopify-critical-press
         focus:outline-none focus:ring-2 focus:ring-shopify-critical focus:ring-offset-2
         transition-colors duration-shopify">
  <i class="bi bi-trash3 me-2"></i>
  Delete
</button>
```

#### Plain Button (Ghost/Link-style)

For tertiary actions like "View all", "Learn more".

```html
<button type="button"
  class="inline-flex items-center text-sm font-semibold
         text-shopify-interactive underline-offset-2
         hover:text-shopify-interactive-hover hover:underline
         active:text-shopify-interactive-press
         focus:outline-none focus:ring-2 focus:ring-shopify-border-focus rounded-sm
         transition-colors duration-shopify">
  View all products
  <i class="bi bi-arrow-right ms-1"></i>
</button>
```

### Button Group Pattern

```html
<div class="flex items-center gap-2 justify-end">
  <button class="...secondary...">Cancel</button>
  <button class="...primary...">Save</button>
</div>
```

> **Rule:** Primary on the right, secondary on the left. One primary per view.

---

## 7. Form Controls

### Text Input

```html
<div>
  <label for="product-name" class="block text-body-sm font-semibold text-shopify-text mb-1">
    Product name
  </label>
  <input type="text" id="product-name" name="name"
    class="block w-full px-3 py-2 text-body text-shopify-text
           bg-shopify-surface border border-shopify-border rounded-shopify
           placeholder:text-shopify-text-disabled
           focus:border-shopify-border-focus focus:ring-2 focus:ring-shopify-border-focus/20 focus:outline-none
           transition-colors duration-shopify"
    placeholder="e.g. Samsung Galaxy S24">
  <p class="mt-1 text-caption text-shopify-text-sub">Used in your storefront and admin.</p>
</div>
```

### Select

```html
<select name="status"
  class="block w-full px-3 py-2 pe-10 text-body text-shopify-text
         bg-shopify-surface border border-shopify-border rounded-shopify
         focus:border-shopify-border-focus focus:ring-2 focus:ring-shopify-border-focus/20 focus:outline-none
         transition-colors duration-shopify appearance-none">
  <option value="">Select status</option>
  <option value="active">Active</option>
  <option value="draft">Draft</option>
</select>
```

### Checkbox / Toggle

```html
<label class="flex items-start gap-3 cursor-pointer group">
  <input type="checkbox" name="email_marketing"
    class="mt-0.5 w-[18px] h-[18px] rounded
           border-shopify-border-sub text-shopify-interactive
           focus:ring-2 focus:ring-shopify-border-focus/20
           transition-colors duration-shopify cursor-pointer">
  <div>
    <span class="text-body font-semibold text-shopify-text block">Email promotions</span>
    <span class="text-body-sm text-shopify-text-sub">Receive deals and special offers via email</span>
  </div>
</label>
```

### Error State

```html
<div>
  <label class="block text-body-sm font-semibold text-shopify-text mb-1">Email</label>
  <input type="email"
    class="block w-full px-3 py-2 text-body text-shopify-text
           bg-shopify-critical-sub border-2 border-shopify-critical rounded-shopify
           focus:ring-2 focus:ring-shopify-critical/20 focus:outline-none">
  <p class="mt-1 text-caption text-shopify-critical font-medium flex items-center gap-1">
    <i class="bi bi-exclamation-circle-fill"></i>
    A valid email address is required.
  </p>
</div>
```

---

## 8. Badges & Status Indicators

### Badge Variants

```html
{# Default (neutral) #}
<span class="inline-flex items-center px-2 py-0.5 text-caption font-semibold
             bg-shopify-surface-alt text-shopify-text-sub
             rounded-full border border-shopify-border">
  Draft
</span>

{# Success #}
<span class="inline-flex items-center px-2 py-0.5 text-caption font-semibold
             bg-shopify-success-sub text-shopify-success
             rounded-full">
  <span class="w-1.5 h-1.5 bg-shopify-success rounded-full me-1.5"></span>
  In Stock
</span>

{# Warning #}
<span class="inline-flex items-center px-2 py-0.5 text-caption font-semibold
             bg-shopify-warning-sub text-shopify-warning-icon
             rounded-full">
  <span class="w-1.5 h-1.5 bg-shopify-warning-icon rounded-full me-1.5 animate-pulse"></span>
  Low Stock
</span>

{# Critical #}
<span class="inline-flex items-center px-2 py-0.5 text-caption font-semibold
             bg-shopify-critical-sub text-shopify-critical
             rounded-full">
  Out of Stock
</span>

{# Informational #}
<span class="inline-flex items-center px-2 py-0.5 text-caption font-semibold
             bg-shopify-highlight-sub text-shopify-highlight-icon
             rounded-full">
  New
</span>
```

### Order Status Badge (Django Template)

```html
{% if order.status == 'delivered' %}
  <span class="inline-flex items-center px-2 py-0.5 text-caption font-semibold bg-shopify-success-sub text-shopify-success rounded-full">
{% elif order.status == 'cancelled' or order.status == 'refunded' %}
  <span class="inline-flex items-center px-2 py-0.5 text-caption font-semibold bg-shopify-critical-sub text-shopify-critical rounded-full">
{% elif order.status == 'pending' %}
  <span class="inline-flex items-center px-2 py-0.5 text-caption font-semibold bg-shopify-warning-sub text-shopify-warning-icon rounded-full">
{% else %}
  <span class="inline-flex items-center px-2 py-0.5 text-caption font-semibold bg-shopify-highlight-sub text-shopify-highlight-icon rounded-full">
{% endif %}
    {{ order.get_status_display }}
  </span>
```

---

## 9. Cards

### Polaris-Style Card

The card is the fundamental container. Every card follows this anatomy:

```
┌─────────────────────────────────────────┐
│ Header (optional)         Action (opt)  │ ← border-b
├─────────────────────────────────────────┤
│                                         │
│  Content area                           │
│                                         │
├─────────────────────────────────────────┤
│ Footer (optional)                       │ ← border-t
└─────────────────────────────────────────┘
```

```html
<div class="bg-shopify-surface border border-shopify-border rounded-shopify-lg shadow-shopify-card overflow-hidden">
  {# Header #}
  <div class="px-5 py-4 border-b border-shopify-border flex items-center justify-between">
    <h2 class="text-heading text-shopify-text">Section Title</h2>
    <button class="...plain-button...">Manage</button>
  </div>

  {# Content #}
  <div class="p-5">
    <p class="text-body text-shopify-text-sub">Card content goes here.</p>
  </div>

  {# Footer (optional) #}
  <div class="px-5 py-3 border-t border-shopify-border bg-shopify-surface-sub flex justify-end gap-2">
    <button class="...secondary...">Cancel</button>
    <button class="...primary...">Save</button>
  </div>
</div>
```

---

## 10. Smart Components

### Product Card

A complete, copy-paste Flowbite card with HTMX "Add to Cart" and wishlist toggle.

```html
{# products/_card.html #}
{% load i18n humanize %}

<div class="bg-shopify-surface border border-shopify-border rounded-shopify-lg shadow-shopify-card
            overflow-hidden group transition-shadow duration-shopify hover:shadow-shopify-popover">

  {# Image #}
  <a href="{{ product.get_absolute_url }}" class="block relative aspect-square bg-shopify-surface-alt overflow-hidden">
    {% if product.on_sale %}
      <span class="absolute top-3 start-3 z-10 inline-flex items-center px-2 py-0.5 text-caption font-bold
                   text-white bg-shopify-critical rounded-shopify-sm">
        -{{ product.discount_percent }}%
      </span>
    {% endif %}

    {% if product.img %}
      <img src="{{ product.img.url }}" alt="{{ product.get_name }}"
           class="w-full h-full object-contain p-6 group-hover:scale-105 transition-transform duration-300"
           loading="lazy">
    {% elif product.img_link %}
      <img src="{{ product.img_link }}" alt="{{ product.get_name }}"
           class="w-full h-full object-contain p-6 group-hover:scale-105 transition-transform duration-300"
           loading="lazy">
    {% else %}
      <div class="w-full h-full flex items-center justify-center">
        <i class="bi bi-box text-5xl text-shopify-text-disabled"></i>
      </div>
    {% endif %}
  </a>

  {# Details #}
  <div class="p-4 flex flex-col gap-2">
    {# Brand #}
    <span class="text-subheading text-shopify-text-disabled">{{ product.brand.get_name }}</span>

    {# Title #}
    <a href="{{ product.get_absolute_url }}" class="text-body font-semibold text-shopify-text line-clamp-2 leading-snug
              hover:text-shopify-interactive transition-colors duration-shopify">
      {{ product.get_name }}
    </a>

    {# Price #}
    <div class="flex items-baseline gap-2 mt-1">
      {% if product.on_sale %}
        <span class="text-heading text-shopify-critical font-bold">
          EGP {{ product.discount_price|floatformat:2|intcomma }}
        </span>
        <span class="text-body-sm text-shopify-text-disabled line-through">
          EGP {{ product.price|floatformat:2|intcomma }}
        </span>
      {% else %}
        <span class="text-heading text-shopify-text font-bold">
          EGP {{ product.price|floatformat:2|intcomma }}
        </span>
      {% endif %}
    </div>

    {# Stock #}
    {% if product.stock == 0 %}
      <span class="text-caption text-shopify-critical font-medium">{% trans "Out of stock" %}</span>
    {% elif product.stock <= 5 %}
      <span class="text-caption text-shopify-warning-icon font-medium">{% trans "Only" %} {{ product.stock }} {% trans "left" %}</span>
    {% endif %}

    {# Actions #}
    <div class="flex items-center gap-2 mt-2 pt-3 border-t border-shopify-border">
      {% if user.is_authenticated %}
        {# HTMX Add to Cart #}
        <button
          hx-post="{% url 'cart:add' product.id %}"
          hx-headers='{"X-CSRFToken": "{{ csrf_token }}"}'
          hx-vals='{"quantity": 1}'
          hx-target="#cart-count"
          hx-swap="innerHTML"
          hx-indicator="#spinner-{{ product.id }}"
          hx-trigger="click"
          hx-on::after-request="htmx.trigger(document.body, 'refresh-cart')"
          class="flex-1 inline-flex items-center justify-center px-3 py-2 text-body-sm font-semibold
                 text-shopify-text-on-interactive bg-shopify-interactive
                 rounded-shopify-sm shadow-shopify-button
                 hover:bg-shopify-interactive-hover active:bg-shopify-interactive-press
                 transition-colors duration-shopify
                 disabled:opacity-50 disabled:cursor-not-allowed
                 {% if product.stock == 0 %}opacity-50 pointer-events-none{% endif %}">
          {# Spinner (hidden by default) #}
          <svg id="spinner-{{ product.id }}" class="htmx-indicator animate-spin -ms-1 me-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path>
          </svg>
          <i class="bi bi-bag-plus me-1.5"></i>
          {% trans "Add to Cart" %}
        </button>

        {# Wishlist Toggle #}
        <button
          hx-post="{% url 'products:toggle_wishlist' product.id %}"
          hx-headers='{"X-CSRFToken": "{{ csrf_token }}"}'
          hx-swap="outerHTML"
          class="inline-flex items-center justify-center w-10 h-10 rounded-shopify-sm
                 border border-shopify-border text-shopify-text-sub
                 hover:border-shopify-critical hover:text-shopify-critical hover:bg-shopify-critical-sub
                 transition-colors duration-shopify">
          <i class="bi {% if product.id in wishlist_ids %}bi-heart-fill text-shopify-critical{% else %}bi-heart{% endif %} text-lg"></i>
        </button>
      {% else %}
        <a href="{% url 'login' %}?next={{ request.path }}"
           class="flex-1 inline-flex items-center justify-center px-3 py-2 text-body-sm font-semibold
                  text-shopify-text bg-shopify-surface border border-shopify-border-sub
                  rounded-shopify-sm shadow-shopify-button
                  hover:bg-shopify-surface-hover transition-colors duration-shopify">
          <i class="bi bi-bag-plus me-1.5"></i>
          {% trans "Add to Cart" %}
        </a>
      {% endif %}
    </div>
  </div>
</div>
```

---

### Cart Drawer

Uses Alpine.js for open/close state. Uses HTMX to load cart contents from a Django partial.

```html
{# shared/partials/_cart_drawer.html — Include in base.html #}
<div x-data="{ open: false }"
     @open-cart.window="open = true"
     @keydown.escape.window="open = false"
     x-cloak>

  {# Backdrop #}
  <div x-show="open"
       x-transition:enter="transition ease-out duration-300"
       x-transition:enter-start="opacity-0"
       x-transition:enter-end="opacity-100"
       x-transition:leave="transition ease-in duration-200"
       x-transition:leave-start="opacity-100"
       x-transition:leave-end="opacity-0"
       @click="open = false"
       class="fixed inset-0 bg-black/40 z-drawer">
  </div>

  {# Drawer Panel #}
  <div x-show="open"
       x-transition:enter="transition ease-out duration-300"
       x-transition:enter-start="translate-x-full"
       x-transition:enter-end="translate-x-0"
       x-transition:leave="transition ease-in duration-200"
       x-transition:leave-start="translate-x-0"
       x-transition:leave-end="translate-x-full"
       class="fixed top-0 end-0 h-full w-full max-w-md z-drawer
              bg-shopify-surface shadow-shopify-dialog flex flex-col">

    {# Header #}
    <div class="flex items-center justify-between px-5 py-4 border-b border-shopify-border">
      <h2 class="text-heading text-shopify-text flex items-center gap-2">
        <i class="bi bi-bag text-lg"></i>
        {% trans "Your Cart" %}
        <span id="cart-count"
              class="inline-flex items-center justify-center px-2 py-0.5 text-caption font-bold
                     bg-shopify-interactive text-white rounded-full min-w-[20px]">
          {{ cart.items.count|default:0 }}
        </span>
      </h2>
      <button @click="open = false"
              class="inline-flex items-center justify-center w-9 h-9 rounded-shopify-sm
                     text-shopify-text-sub hover:bg-shopify-surface-hover hover:text-shopify-text
                     transition-colors duration-shopify">
        <i class="bi bi-x-lg text-lg"></i>
        <span class="sr-only">{% trans "Close cart" %}</span>
      </button>
    </div>

    {# Cart Content — Loaded via HTMX #}
    <div id="cart-drawer-content"
         class="flex-1 overflow-y-auto"
         hx-get="{% url 'cart:offcanvas_fragment' %}"
         hx-trigger="load, refresh-cart from:body"
         hx-swap="innerHTML"
         hx-indicator="#cart-loading">

      {# Initial loading skeleton #}
      <div id="cart-loading" class="htmx-indicator p-5 space-y-4">
        {% for i in "123" %}
        <div class="animate-pulse flex gap-4">
          <div class="w-16 h-16 bg-shopify-surface-alt rounded-shopify"></div>
          <div class="flex-1 space-y-2">
            <div class="h-4 bg-shopify-surface-alt rounded w-3/4"></div>
            <div class="h-3 bg-shopify-surface-alt rounded w-1/2"></div>
          </div>
        </div>
        {% endfor %}
      </div>
    </div>

    {# Footer #}
    <div class="border-t border-shopify-border px-5 py-4 bg-shopify-surface-sub space-y-3">
      <div class="flex justify-between text-body font-semibold text-shopify-text">
        <span>{% trans "Subtotal" %}</span>
        <span id="cart-subtotal">EGP 0.00</span>
      </div>
      <p class="text-caption text-shopify-text-sub">{% trans "Shipping and taxes calculated at checkout." %}</p>
      <a href="{% url 'orders:checkout' %}"
         class="flex items-center justify-center w-full px-4 py-3 text-body font-semibold
                text-shopify-text-on-interactive bg-shopify-interactive rounded-shopify-sm
                shadow-shopify-button hover:bg-shopify-interactive-hover
                transition-colors duration-shopify">
        <i class="bi bi-lock me-2"></i>
        {% trans "Checkout" %}
      </a>
      <a href="{% url 'cart:detail' %}"
         class="flex items-center justify-center w-full text-body-sm font-semibold
                text-shopify-interactive hover:text-shopify-interactive-hover hover:underline
                transition-colors duration-shopify py-1">
        {% trans "View full cart" %}
      </a>
    </div>
  </div>
</div>
```

**Trigger the drawer from any button:**

```html
<button @click="$dispatch('open-cart')" class="relative ...">
  <i class="bi bi-bag text-xl"></i>
  <span id="cart-count" class="absolute -top-1 -end-1 ...">{{ cart_count }}</span>
</button>
```

---

### Gemini AI Fraud Alert Banner

A collapsible Flowbite-style banner that shows AI-powered fraud risk analysis.

```html
{# orders/_fraud_alert.html #}
{% if order.fraud_risk_score and order.fraud_risk_score > 50 %}
<div x-data="{ expanded: false }"
     class="border rounded-shopify-lg overflow-hidden mb-4
            {% if order.fraud_risk_score > 80 %}
              border-shopify-critical bg-shopify-critical-sub
            {% else %}
              border-shopify-warning bg-shopify-warning-sub
            {% endif %}">

  {# Banner Header (always visible) #}
  <button @click="expanded = !expanded"
          class="w-full flex items-center justify-between px-5 py-4 text-start focus:outline-none group">
    <div class="flex items-center gap-3">
      <div class="flex-shrink-0">
        {% if order.fraud_risk_score > 80 %}
          <i class="bi bi-shield-exclamation text-2xl text-shopify-critical"></i>
        {% else %}
          <i class="bi bi-shield-check text-2xl text-shopify-warning-icon"></i>
        {% endif %}
      </div>
      <div>
        <h3 class="text-body font-semibold text-shopify-text flex items-center gap-2">
          <span class="inline-flex items-center px-1.5 py-0.5 text-[10px] font-bold
                       bg-shopify-interactive/10 text-shopify-interactive rounded uppercase tracking-wider">
            Gemini AI
          </span>
          {% trans "Fraud Risk Analysis" %}
        </h3>
        <p class="text-body-sm text-shopify-text-sub mt-0.5">
          {% trans "Risk Score:" %} <strong>{{ order.fraud_risk_score }}%</strong>
          —
          {% if order.fraud_risk_score > 80 %}
            {% trans "High risk — manual review recommended" %}
          {% else %}
            {% trans "Medium risk — proceed with caution" %}
          {% endif %}
        </p>
      </div>
    </div>
    <i class="bi text-shopify-text-sub transition-transform duration-200"
       :class="expanded ? 'bi-chevron-up' : 'bi-chevron-down'"></i>
  </button>

  {# Collapsible Details #}
  <div x-show="expanded"
       x-collapse
       x-cloak>
    <div class="px-5 pb-5 pt-0">
      <div class="bg-shopify-surface rounded-shopify p-4 border border-shopify-border space-y-3">

        {# Risk Factors #}
        <h4 class="text-subheading text-shopify-text-sub">{% trans "Risk Factors" %}</h4>
        <ul class="space-y-2">
          {% for factor in order.fraud_risk_factors %}
          <li class="flex items-start gap-2 text-body-sm text-shopify-text">
            <i class="bi bi-exclamation-triangle-fill text-shopify-warning-icon flex-shrink-0 mt-0.5"></i>
            {{ factor }}
          </li>
          {% endfor %}
        </ul>

        {# AI Recommendation #}
        <div class="pt-3 border-t border-shopify-border">
          <p class="text-body-sm text-shopify-text-sub">
            <strong class="text-shopify-text">{% trans "Recommendation:" %}</strong>
            {{ order.fraud_recommendation }}
          </p>
        </div>

        {# Actions #}
        <div class="flex gap-2 pt-2">
          <button class="...primary-button... text-body-sm px-3 py-1.5">
            <i class="bi bi-check-lg me-1"></i> {% trans "Approve Order" %}
          </button>
          <button class="...destructive-button... text-body-sm px-3 py-1.5">
            <i class="bi bi-x-lg me-1"></i> {% trans "Flag for Review" %}
          </button>
        </div>
      </div>
    </div>
  </div>
</div>
{% endif %}
```

---

### Toast Notifications

Uses Alpine.js with Django messages framework.

```html
{# shared/partials/_toasts.html — Include at bottom of base.html #}
<div x-data="{
  toasts: [],
  add(message, type = 'info') {
    const id = Date.now();
    this.toasts.push({ id, message, type });
    setTimeout(() => this.remove(id), 5000);
  },
  remove(id) {
    this.toasts = this.toasts.filter(t => t.id !== id);
  }
}"
@toast.window="add($event.detail.message, $event.detail.type)"
class="fixed bottom-4 end-4 z-toast flex flex-col gap-2 w-full max-w-sm pointer-events-none">

  {# Django messages on page load #}
  {% for msg in messages %}
  <div x-data="{ show: true }"
       x-init="setTimeout(() => show = false, 5000)"
       x-show="show"
       x-transition:enter="transition ease-out duration-300"
       x-transition:enter-start="opacity-0 translate-y-2"
       x-transition:enter-end="opacity-100 translate-y-0"
       x-transition:leave="transition ease-in duration-200"
       x-transition:leave-start="opacity-100 translate-y-0"
       x-transition:leave-end="opacity-0 translate-y-2"
       class="pointer-events-auto flex items-start gap-3 px-4 py-3 rounded-shopify-lg shadow-shopify-popover border
              {% if msg.tags == 'success' %}bg-shopify-success-sub border-shopify-success/20
              {% elif msg.tags == 'error' %}bg-shopify-critical-sub border-shopify-critical/20
              {% elif msg.tags == 'warning' %}bg-shopify-warning-sub border-shopify-warning/20
              {% else %}bg-shopify-surface border-shopify-border{% endif %}">
    <i class="bi flex-shrink-0 text-lg mt-0.5
       {% if msg.tags == 'success' %}bi-check-circle-fill text-shopify-success
       {% elif msg.tags == 'error' %}bi-exclamation-circle-fill text-shopify-critical
       {% elif msg.tags == 'warning' %}bi-exclamation-triangle-fill text-shopify-warning-icon
       {% else %}bi-info-circle-fill text-shopify-interactive{% endif %}"></i>
    <p class="text-body text-shopify-text flex-1">{{ msg.message }}</p>
    <button @click="show = false" class="text-shopify-text-disabled hover:text-shopify-text transition-colors flex-shrink-0">
      <i class="bi bi-x-lg text-sm"></i>
    </button>
  </div>
  {% endfor %}

  {# Dynamic toasts (triggered by Alpine events) #}
  <template x-for="toast in toasts" :key="toast.id">
    <div x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="opacity-0 translate-y-2"
         x-transition:enter-end="opacity-100 translate-y-0"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0 translate-y-2"
         class="pointer-events-auto flex items-start gap-3 px-4 py-3 rounded-shopify-lg shadow-shopify-popover border bg-shopify-surface border-shopify-border">
      <p class="text-body text-shopify-text flex-1" x-text="toast.message"></p>
      <button @click="remove(toast.id)" class="text-shopify-text-disabled hover:text-shopify-text">
        <i class="bi bi-x-lg text-sm"></i>
      </button>
    </div>
  </template>
</div>
```

---

### Confirmation Dialog

For destructive actions (delete product, cancel order).

```html
{# shared/partials/_confirm_dialog.html #}
<div x-data="{ open: false, action: '', message: '' }"
     @confirm-action.window="open = true; action = $event.detail.action; message = $event.detail.message"
     x-cloak>

  {# Backdrop #}
  <div x-show="open"
       x-transition.opacity
       class="fixed inset-0 bg-black/50 z-modal"
       @click="open = false">
  </div>

  {# Dialog #}
  <div x-show="open"
       x-transition:enter="transition ease-out duration-200"
       x-transition:enter-start="opacity-0 scale-95"
       x-transition:enter-end="opacity-100 scale-100"
       x-transition:leave="transition ease-in duration-150"
       x-transition:leave-start="opacity-100 scale-100"
       x-transition:leave-end="opacity-0 scale-95"
       class="fixed inset-0 z-modal flex items-center justify-center p-4">
    <div class="bg-shopify-surface rounded-shopify-lg shadow-shopify-dialog max-w-sm w-full p-6" @click.outside="open = false">
      <div class="flex items-start gap-4 mb-5">
        <div class="flex-shrink-0 w-10 h-10 rounded-full bg-shopify-critical-sub flex items-center justify-center">
          <i class="bi bi-exclamation-triangle text-shopify-critical text-lg"></i>
        </div>
        <div>
          <h3 class="text-heading text-shopify-text">{% trans "Are you sure?" %}</h3>
          <p class="text-body text-shopify-text-sub mt-1" x-text="message">
            {% trans "This action cannot be undone." %}
          </p>
        </div>
      </div>
      <div class="flex gap-2 justify-end">
        <button @click="open = false" class="...secondary-button...">
          {% trans "Cancel" %}
        </button>
        <form :action="action" method="post" class="m-0">
          {% csrf_token %}
          <button type="submit" class="...destructive-button...">
            {% trans "Delete" %}
          </button>
        </form>
      </div>
    </div>
  </div>
</div>
```

**Trigger from anywhere:**

```html
<button @click="$dispatch('confirm-action', {
  action: '{% url 'products:delete' product.id %}',
  message: '{{ product.name }} will be permanently deleted.'
})">
  <i class="bi bi-trash3"></i> Delete
</button>
```

---

## 11. HTMX Patterns

### Golden Rules

1. **HTMX replaces DOM fragments.** Django renders a partial template. The browser swaps it in. No JSON. No JS parsing.
2. **One partial = one responsibility.** `cart/_items.html` returns only cart items. Never an entire page.
3. **Use `hx-indicator` for every request.** Users must always see feedback.
4. **Use `hx-trigger` custom events** to coordinate components (e.g., cart drawer refreshes when an item is added anywhere on the page).

### Pattern: Add to Cart with Feedback

```html
{# Button #}
<button
  hx-post="{% url 'cart:add' product.id %}"
  hx-headers='{"X-CSRFToken": "{{ csrf_token }}"}'
  hx-vals='{"quantity": 1}'
  hx-target="#cart-count"
  hx-swap="innerHTML"
  hx-indicator="closest .htmx-indicator"
  hx-on::after-request="htmx.trigger(document.body, 'refresh-cart'); $dispatch('toast', {message: 'Added to cart!', type: 'success'})">
  Add to Cart
</button>
```

```python
# cart/views.py
def cart_add(request, product_id):
    # ... add logic ...
    if request.htmx:
        return HttpResponse(str(cart.items.count()))  # Just the count
    return redirect('cart:detail')
```

### Pattern: Infinite Scroll / Load More

```html
<div id="product-grid"
     hx-get="{% url 'products:products' %}?page={{ page_obj.next_page_number }}"
     hx-trigger="revealed"
     hx-swap="afterend"
     hx-indicator="#load-more-spinner">
</div>

<div id="load-more-spinner" class="htmx-indicator flex justify-center py-8">
  <svg class="animate-spin h-6 w-6 text-shopify-interactive" ...></svg>
</div>
```

### Pattern: Live Search

```html
<input type="search" name="q"
       hx-get="{% url 'search' %}"
       hx-trigger="input changed delay:300ms, search"
       hx-target="#search-results"
       hx-swap="innerHTML"
       hx-indicator="#search-spinner"
       hx-push-url="true"
       placeholder="{% trans 'Search products...' %}"
       class="...shopify-input-classes...">

<div id="search-results">
  {% include 'products/_list.html' %}
</div>
```

### HTMX Loading Indicator Convention

Always use the Flowbite spinner as the `hx-indicator`:

```html
<div class="htmx-indicator">
  <div role="status" class="flex items-center justify-center gap-2 text-shopify-text-sub text-body-sm">
    <svg class="animate-spin h-4 w-4 text-shopify-interactive" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path>
    </svg>
    <span>{% trans "Loading…" %}</span>
  </div>
</div>
```

---

## 12. Alpine.js Patterns

### Golden Rules

1. **Alpine = UI state only.** Open/close, tabs, toggles, accordion. Nothing that requires server truth.
2. **Never duplicate Django state in Alpine.** If the database knows the answer, render it with Django. Alpine reads the DOM, not the API.
3. **Keep `x-data` scoped and small.** Each component gets its own `x-data`. No global Alpine stores unless absolutely required (cart count is the exception).

### Pattern: Tabs

```html
<div x-data="{ tab: 'description' }">
  <div class="flex border-b border-shopify-border gap-6 mb-6">
    <button @click="tab = 'description'"
            :class="tab === 'description' ? 'text-shopify-interactive border-shopify-interactive' : 'text-shopify-text-sub border-transparent hover:text-shopify-text'"
            class="pb-3 text-body font-semibold border-b-2 transition-colors duration-shopify">
      {% trans "Description" %}
    </button>
    <button @click="tab = 'reviews'"
            :class="tab === 'reviews' ? 'text-shopify-interactive border-shopify-interactive' : 'text-shopify-text-sub border-transparent hover:text-shopify-text'"
            class="pb-3 text-body font-semibold border-b-2 transition-colors duration-shopify">
      {% trans "Reviews" %}
    </button>
  </div>

  <div x-show="tab === 'description'" x-transition.opacity>
    {{ product.description|linebreaks }}
  </div>
  <div x-show="tab === 'reviews'" x-transition.opacity x-cloak>
    {% include 'products/_reviews.html' %}
  </div>
</div>
```

### Pattern: Quantity Stepper

```html
<div x-data="{ qty: 1, min: 1, max: {{ product.stock|default:10 }} }" class="inline-flex items-center border border-shopify-border rounded-shopify overflow-hidden">
  <button @click="qty = Math.max(min, qty - 1)"
          :disabled="qty <= min"
          class="px-3 py-2 text-shopify-text-sub hover:bg-shopify-surface-hover disabled:opacity-30 transition-colors">
    <i class="bi bi-dash"></i>
  </button>
  <input type="number" name="quantity" x-model.number="qty" :min="min" :max="max"
         class="w-14 text-center text-body font-semibold text-shopify-text border-x border-shopify-border bg-transparent focus:outline-none">
  <button @click="qty = Math.min(max, qty + 1)"
          :disabled="qty >= max"
          class="px-3 py-2 text-shopify-text-sub hover:bg-shopify-surface-hover disabled:opacity-30 transition-colors">
    <i class="bi bi-plus"></i>
  </button>
</div>
```

### Pattern: Cart Count Store (Global)

The one acceptable global store — keeps the cart badge in sync across all components.

```js
// static/js/alpine-store.js
document.addEventListener('alpine:init', () => {
  Alpine.store('cart', {
    count: parseInt(document.getElementById('cart-count')?.textContent || '0'),

    async addToCart(formEl) {
      const resp = await fetch(formEl.action, {
        method: 'POST',
        body: new FormData(formEl),
      });
      if (resp.ok) {
        const data = await resp.json();
        this.count = data.cart_count;
        document.getElementById('cart-count').textContent = this.count;
        htmx.trigger(document.body, 'refresh-cart');
      }
    },

    showDrawer() {
      window.dispatchEvent(new CustomEvent('open-cart'));
    }
  });
});
```

---

## 13. Django Template Conventions

### File Organization

```
templates/
├── shared/
│   ├── base.html              ← Master layout (navbar, drawer, toasts, footer)
│   └── partials/
│       ├── _navbar.html
│       ├── _footer.html
│       ├── _cart_drawer.html
│       ├── _toasts.html
│       └── _confirm_dialog.html
├── products/
│   ├── products.html          ← Full page
│   ├── products_details.html  ← Full page
│   ├── _card.html             ← HTMX partial (prefixed with _)
│   ├── _list.html             ← HTMX partial
│   └── _reviews.html          ← HTMX partial
├── cart/
│   ├── detail.html            ← Full page
│   └── _offcanvas.html        ← HTMX partial (cart drawer content)
└── orders/
    ├── checkout.html
    └── _fraud_alert.html      ← HTMX partial
```

### Naming Rules

| Convention | Example | Why |
|-----------|---------|-----|
| Full pages: **no prefix** | `products.html` | Rendered by views, extends `base.html` |
| HTMX partials: **underscore prefix** | `_card.html` | Never standalone. Swapped into a container. |
| Blocks use semantic names | `{% block content %}`, `{% block extra_js %}` | Predictable override points |

### View Pattern for HTMX

```python
# products/views.py
def product_list(request):
    products = Product.objects.select_related('brand', 'category').all()
    template = 'products/_list.html' if request.htmx else 'products/products.html'
    return render(request, template, {'products': products})
```

---

## 14. Accessibility Checklist

Apply these to every component. Non-negotiable.

| Requirement | Implementation |
|-------------|----------------|
| **Color contrast** | All text meets WCAG AA (4.5:1 for body, 3:1 for large text). The Shopify palette is pre-tested. |
| **Focus visible** | Every interactive element has `focus:ring-2 focus:ring-shopify-border-focus focus:ring-offset-2`. |
| **Keyboard navigation** | Drawers close on `Escape`. Modals trap focus. Buttons are `<button>`, not `<div>`. |
| **Screen readers** | All icon-only buttons have `<span class="sr-only">`. Images have meaningful `alt`. |
| **ARIA landmarks** | `<main>`, `<nav>`, `<aside>`, `role="dialog"` on modals. |
| **Loading states** | `hx-indicator` spinners have `role="status"` and visually hidden "Loading" text. |
| **RTL support** | Use logical properties: `start`/`end`, `ms-`/`me-`/`ps-`/`pe-`. Never `left`/`right`/`ml-`/`mr-`. |

---

## 15. Solo Developer Best Practices

> You are the designer, developer, QA, and PM. These rules protect you from yourself.

### Architecture Discipline

| Rule | Rationale |
|------|-----------|
| **State lives in Django.** | The database is the single source of truth. Alpine state is ephemeral (UI toggles only). HTMX reads server-rendered HTML. |
| **No JSON APIs.** | You're not building an SPA. Django renders HTML. HTMX swaps it. JSON is only for the rare Alpine store operation (cart count). |
| **One primary action per view.** | Each page has exactly one blue primary button. Everything else is secondary or plain. This forces clarity. |
| **Prefix HTMX partials with `_`.** | Glance at file tree = instant distinction between full pages and swappable fragments. |

### Development Speed

| Practice | How |
|----------|-----|
| **`hx-indicator` on every HTMX request** | Use the Flowbite spinner (see Section 11). Users always see that something is happening. |
| **Alpine only for UI toggles** | Open/close, tabs, expand/collapse. If logic requires a server call, use HTMX instead. |
| **Keep Django context processors lean** | Only put globally-needed data (categories, cart count, wishlist IDs) in context processors. Everything else goes in the view. |
| **Use `select_related()` and `prefetch_related()` everywhere** | N+1 queries are the #1 performance killer in Django templates. Add `.select_related('brand', 'category')` to every product queryset. |
| **Template fragment caching** | Wrap expensive template sections in `{% cache 300 section_name %}`. Carousel, category grids, footer — anything that doesn't change per-request. |

### Quality Gates (Before You Push)

```bash
# 1. Lint Python
ruff check . --fix

# 2. Build Tailwind (purge unused classes)
npm run build:css

# 3. Run Django checks
python manage.py check --deploy

# 4. Scan for N+1 queries (with django-debug-toolbar open)
#    Target: < 10 queries per page load

# 5. Check page load time
#    Target: < 400ms for server response (TTFB)
```

### Decision Framework

When you're unsure which tool to use:

```
┌─────────────────────────────────────────────┐
│ Does the UI change require server data?     │
│                                             │
│   YES → Use HTMX                            │
│         (hx-get/hx-post → Django partial)   │
│                                             │
│   NO  → Is it a toggle/tab/animation?       │
│         YES → Use Alpine.js (x-data)        │
│         NO  → Use plain CSS (:hover, :focus)│
└─────────────────────────────────────────────┘
```

### Naming Cheat Sheet

| What | Format | Example |
|------|--------|---------|
| CSS ID (HTMX target) | `kebab-case` | `#cart-drawer-content` |
| CSS ID (JS hook) | `js-` prefix | `.js-cart-badge` |
| URL name | `app:action` | `cart:add`, `products:detail` |
| Template file | `snake_case.html` | `products_details.html` |
| HTMX partial | `_snake_case.html` | `_card.html` |
| Django view | `snake_case` | `product_list`, `cart_add` |
| Alpine x-data | `camelCase` | `{ isOpen: false }` |

---

## Quick Reference Card

Copy this to a sticky note on your monitor:

```
COLORS:  Surface (#F6F6F7) · Blue (#2C6ECB) · Red (#D72C0D) · Green (#008060)
SPACING: 4px grid → p-1 (4) · p-2 (8) · p-4 (16) · p-6 (24) · p-8 (32)
RADIUS:  rounded-shopify (8px) · rounded-shopify-sm (6px)
SHADOW:  shadow-shopify-card (cards) · shadow-shopify-dialog (modals)
FONT:    text-body (14px) · text-heading (20px) · text-display (28px)
RULE:    HTMX for data · Alpine for UI · CSS for styling · Django for truth
```

---

*Last updated: {{ "now"|date:"Y-m-d" }} · Stack: Django 6 + Tailwind 3 + Flowbite + Alpine.js + HTMX*
