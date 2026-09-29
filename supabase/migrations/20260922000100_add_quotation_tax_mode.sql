alter table public.quotations
  add column if not exists tax_mode text not null default 'exclusive'
  check (tax_mode in ('exclusive', 'inclusive'));
