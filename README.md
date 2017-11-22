# transactor

Transactor is a simple smart banking application which assists bank employees
to add customers to the bank, help the customers to transfer money between
each other and lend money to the customers.

Main features of the application are

1. Adding a customer
1. Listing the customers by their account number, username and balance
1. Removing a customer from the system
1. Searching for a customer by their account number or username
1. Lend money to a customer
1. Transfer money between two customers
1. Inform the customer about the interest they will be earning over a period
    of one year on the basis of their current balance.

The application is named `transactor`. Any commands that need to be carried
out must start with the same name.

All the features have been grouped within 3 subcommands.

1. `user`
1. `transact`
1. `compute`

`user` subcommand has 4 other subcommands nested inside.

1. `add` -> Add a user to the system
1. `list` -> List the users in the system
1. `remove` -> Remove a user from the system
1. `search` -> Search for a user within the system

All these subcommands take other commands/flags which can be used to perform a
task. Ex: `search` command can be run like `transactor user search <VALUE>`.
This command searches for a user by taking in the #{VALUE} which can be either
an account number or a username.

`transact` subcommand has 2 other subcommands nested inside.

1. `lend` -> A bank can lend some money to the customer.
1. `transfer` -> A customer can transfer money to another customer of the
    bank.

`compute` subcommand can be run like `transactor compute <VALUE>` where VALUE
can either be username or account number

