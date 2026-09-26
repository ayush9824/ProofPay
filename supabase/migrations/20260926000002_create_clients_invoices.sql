-- Custom types
create type public.invoice_status as enum ('draft', 'due_soon', 'due', 'overdue', 'paid');

-- Clients Table
create table public.clients (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  name text not null,
  email text,
  phone text,
  company_name text,
  notes text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Invoices Table
create table public.invoices (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  client_id uuid references public.clients on delete restrict not null,
  invoice_number text not null,
  project_name text not null,
  amount numeric(12, 2) not null check (amount > 0),
  currency text not null default 'USD',
  invoice_date date not null,
  due_date date not null,
  status public.invoice_status not null default 'draft',
  notes text,
  paid_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  constraint check_due_date check (due_date >= invoice_date)
);

-- Enable RLS
alter table public.clients enable row level security;
alter table public.invoices enable row level security;

-- RLS Policies for Clients
create policy "Users can view own clients." on public.clients for select using (auth.uid() = user_id);
create policy "Users can insert own clients." on public.clients for insert with check (auth.uid() = user_id);
create policy "Users can update own clients." on public.clients for update using (auth.uid() = user_id);
create policy "Users can delete own clients." on public.clients for delete using (auth.uid() = user_id);

-- RLS Policies for Invoices
create policy "Users can view own invoices." on public.invoices for select using (auth.uid() = user_id);
create policy "Users can insert own invoices." on public.invoices for insert with check (auth.uid() = user_id);
create policy "Users can update own invoices." on public.invoices for update using (auth.uid() = user_id);
create policy "Users can delete own invoices." on public.invoices for delete using (auth.uid() = user_id);

-- Functions and Triggers for updated_at
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger on_client_updated
  before update on public.clients
  for each row execute procedure public.handle_updated_at();

create trigger on_invoice_updated
  before update on public.invoices
  for each row execute procedure public.handle_updated_at();
