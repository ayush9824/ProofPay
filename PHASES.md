# ProofPay Development Phases

This document outlines the development phases for the ProofPay MVP.

## Phase 1: Foundation & Setup (Current Phase)
- Initialize Flutter project with correct package name.
- Define a scalable, feature-based architecture.
- Identify and add required dependencies (Riverpod, GoRouter, Supabase, etc.).
- Setup routing (`go_router`) and state management (`flutter_riverpod`).
- Create environment variables configuration for secrets.
- Setup core theming and constants.

## Phase 2: Authentication
- Setup Supabase project and enable Email/Password authentication.
- Create `profiles` table in Supabase.
- Implement Authentication UI (Login / Sign Up).
- Manage auth state securely with Riverpod.
- Secure routing (redirect unauthenticated users to Login).

## Phase 3: Clients Management
- Setup `clients` table in Supabase (with Row Level Security).
- Create Client domain models and repository.
- Implement UI to add, list, and edit clients.

## Phase 4: Invoices & Dashboard
- Setup `invoices` table in Supabase (with Row Level Security).
- Create Invoice domain models and repository.
- Implement logic to automatically determine invoice status (Outstanding, Due Soon, Overdue).
- Build the main Dashboard showing categorized invoices.
- Implement UI to create and view specific invoices.

## Phase 5: AI Reminders
- Integrate Gemini API via `google_generative_ai`.
- Create a service to generate professional payment follow-up messages based on client and invoice data.
- Build UI to display the generated message, allowing the user to copy or share it.

## Phase 6: Polish & Local Notifications
- Implement local notifications to remind users of upcoming or overdue invoices.
- UI/UX polish (colors, typography, micro-animations).
- Error handling, form validations, and empty states.
- Final testing on Android and iOS.

## Notes & Constraints
- Focus only on MVP features.
- Avoid building complex features (e.g., automated messaging, client portals, payments).
- Never expose Gemini API keys; use `flutter_dotenv` for configuration and ensure keys are secured.
- Stick to Clean Architecture principles (feature-based routing).
