create table users (
    id serial primary key,
    name text not null,
    email text not null
);

insert into users values (1,"john", "john@fake.fake")