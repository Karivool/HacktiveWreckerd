CREATE TABLE pizzas (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  eater_id INTEGER,

  FOREIGN KEY(eater_id) REFERENCES diner(id)
);

CREATE TABLE diners (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  pizzeria_id INTEGER,

  FOREIGN KEY(pizzeria_id) REFERENCES diner(id)
);

CREATE TABLE pizzerias (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  pizzerias (id, address)
VALUES
  (1, "14th and A"), (2, "13th and 1st");

INSERT INTO
  diners (id, fname, lname, pizzeria_id)
VALUES
  (1, "Sir", "Eatem", 1),
  (2, "Madam", "Crusteat", 1),
  (3, "The", "Boxer", 2),
  (4, "Calzone", "Lovey", NULL);

INSERT INTO
  pizzas (id, name, eater_id)
VALUES
  (1, "Tom Ato", 1),
  (2, "kmongeatyouregreenz92", 2),
  (3, "MrPitaComita", 3),
  (4, "JessauceWalky", 3),
  (5, "Pizza Lady", NULL);
