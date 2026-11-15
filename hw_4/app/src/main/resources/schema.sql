create table if not exists visits (
    id serial primary key,
    visited_at timestamp not null default now()
);
