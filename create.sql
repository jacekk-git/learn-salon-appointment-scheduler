drop table if exists  appointments;
drop table if exists  customers;
drop table if exists  services;

create table services (
  service_id SERIAL NOT NULL,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY(service_id)
);

create table customers (
  customer_id SERIAL NOT NULL,
  phone VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY(customer_id)
);

create table appointments (
  appointment_id SERIAL NOT NULL,
  customer_id INT NOT NULL,
  service_id INT NOT NULL,
  time VARCHAR(255) NOT NULL,
  PRIMARY KEY(appointment_id),
  CONSTRAINT fk_customers
    FOREIGN KEY(customer_id)
      REFERENCES customers(customer_id),
  CONSTRAINT fk_services
    FOREIGN KEY(service_id)
      REFERENCES services(service_id)
);

INSERT INTO services(service_id, name)
OVERRIDING SYSTEM VALUE
VALUES
  (1, 'Cut')
, (2, 'Colour')
, (3, 'Wash')
;