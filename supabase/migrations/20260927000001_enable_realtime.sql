-- Enable Realtime for clients and invoices tables
alter publication supabase_realtime add table public.clients;
alter publication supabase_realtime add table public.invoices;
