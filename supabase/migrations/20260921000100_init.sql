create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  display_name text not null,
  demo_role text not null check (demo_role in ('sales','purchasing','supplier','admin')),
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(), name text unique not null, segment text not null,
  contact_name text, phone text, created_by uuid references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.projects (id uuid primary key default gen_random_uuid(), name text not null, segment text, customer_id uuid references public.customers(id), created_at timestamptz not null default now());
create table if not exists public.opportunities (
  id uuid primary key default gen_random_uuid(), name text not null, customer_id uuid references public.customers(id), customer_name text,
  expected_value numeric(14,2) not null default 0, stage text not null default 'Qualified', lead_source text, created_by uuid references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(), name text unique not null, category text not null, model text, height_type text, section text, thickness text, length numeric(10,2), price_per_meter numeric(14,2) not null default 0, cutting_fee numeric(14,2) not null default 0, created_at timestamptz not null default now()
);
create table if not exists public.product_price_rules (id uuid primary key default gen_random_uuid(), product_id uuid references public.products(id) on delete cascade, rule_name text not null, price numeric(14,2) not null, valid_from date not null default current_date, valid_to date);
create table if not exists public.quotations (
  id uuid primary key default gen_random_uuid(), quotation_number text unique not null, opportunity_id uuid references public.opportunities(id), opportunity_name text, customer_name text not null,
  subtotal numeric(14,2) not null default 0, discount numeric(14,2) not null default 0, shipping numeric(14,2) not null default 0, vat numeric(14,2) not null default 0, total_amount numeric(14,2) not null default 0,
  status text not null default 'Draft', sync_status text not null default 'Pending', created_by uuid references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.quotation_items (id uuid primary key default gen_random_uuid(), quotation_id uuid references public.quotations(id) on delete cascade, product_id uuid references public.products(id), product_name text not null, specification jsonb not null default '{}'::jsonb, quantity numeric(14,2) not null default 0, unit_price numeric(14,2) not null default 0, cutting_fee numeric(14,2) not null default 0, line_total numeric(14,2) not null default 0);
create table if not exists public.purchase_requisitions (
  id uuid primary key default gen_random_uuid(), pr_number text unique not null, quotation_id uuid references public.quotations(id), status text not null default 'Draft', rejection_reason text, created_by uuid references auth.users(id), approved_by uuid references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.purchase_requisition_items (id uuid primary key default gen_random_uuid(), pr_id uuid references public.purchase_requisitions(id) on delete cascade, product_name text not null, specification jsonb not null default '{}'::jsonb, quantity numeric(14,2) not null default 0, unit_price numeric(14,2) not null default 0, line_total numeric(14,2) not null default 0);
create table if not exists public.suppliers (id uuid primary key default gen_random_uuid(), name text unique not null, status text not null default 'Active', created_at timestamptz not null default now());
create table if not exists public.supplier_entitlements (id uuid primary key default gen_random_uuid(), supplier_id uuid references public.suppliers(id) on delete cascade, entitlement_type text not null default 'Included Partner', active boolean not null default true, activated_at timestamptz);
create table if not exists public.purchase_orders (
  id uuid primary key default gen_random_uuid(), po_number text unique not null, pr_id uuid references public.purchase_requisitions(id), supplier_id uuid references public.suppliers(id), supplier_name text not null,
  total_amount numeric(14,2) not null default 0, status text not null default 'Draft', sync_status text not null default 'Pending', rejection_reason text, created_by uuid references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.purchase_order_items (id uuid primary key default gen_random_uuid(), po_id uuid references public.purchase_orders(id) on delete cascade, product_name text not null, specification jsonb not null default '{}'::jsonb, quantity numeric(14,2) not null default 0, unit_price numeric(14,2) not null default 0, line_total numeric(14,2) not null default 0);
create table if not exists public.fulfillment_updates (id uuid primary key default gen_random_uuid(), po_id uuid references public.purchase_orders(id) on delete cascade, status text not null, note text, updated_by uuid references auth.users(id), updated_at timestamptz not null default now());
create table if not exists public.sync_logs (id uuid primary key default gen_random_uuid(), document_type text not null, document_id uuid not null, document_number text, destination text not null default 'DoHome Legacy System', status text not null default 'Pending', error_message text, retry_count int not null default 0, last_synced_at timestamptz, created_at timestamptz not null default now());
create table if not exists public.crm_activities (id uuid primary key default gen_random_uuid(), title text not null, customer_id uuid references public.customers(id), customer_name text, opportunity_id uuid references public.opportunities(id), date date not null, time time, owner_name text, status text not null default 'Planned' check (status in ('Planned','Completed','Cancelled')), note text, created_by uuid references auth.users(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now());

alter table public.profiles enable row level security;
do $$ declare t text; begin foreach t in array array['customers','projects','opportunities','products','product_price_rules','quotations','quotation_items','purchase_requisitions','purchase_requisition_items','purchase_orders','purchase_order_items','suppliers','supplier_entitlements','fulfillment_updates','sync_logs','crm_activities'] loop execute format('alter table public.%I enable row level security', t); begin execute format('create policy "authenticated read %1$s" on public.%1$s for select to authenticated using (true)', t); exception when duplicate_object then null; end; begin execute format('create policy "authenticated write %1$s" on public.%1$s for all to authenticated using (true) with check (true)', t); exception when duplicate_object then null; end; end loop; end $$;
do $$ begin
  create policy "authenticated read profiles" on public.profiles for select to authenticated using (id = auth.uid());
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "authenticated write own profile" on public.profiles for all to authenticated using (id = auth.uid()) with check (id = auth.uid());
exception when duplicate_object then null; end $$;
