-- Villa Caetano Log — one-time Supabase setup
-- Run this in the SQL Editor of project: villa-caetano-issues

alter table public.issues
  add column if not exists entry_type text not null default 'Issue';

alter table public.issues
  drop constraint if exists issues_entry_type_check;

alter table public.issues
  add constraint issues_entry_type_check
  check (entry_type in ('Issue','Action Point','Note'));

create index if not exists issues_entry_type_idx on public.issues(entry_type);

-- Required for the Delete action in the browser UI.
do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'issues'
      and policyname = 'issues_delete'
  ) then
    create policy "issues_delete"
      on public.issues
      for delete
      to anon, authenticated
      using (true);
  end if;
end $$;
