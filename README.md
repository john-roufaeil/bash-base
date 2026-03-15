# bash-base
A simple Bash-based DBMS that manages databases as directories and tables as files. It supports basic operations such as creating, reading, updating, and deleting records, with column type and primary key validation through a command-line menu interface. bash-base is lightweight, requires no external dependencies. All operations are performed through a simple menu-driven interface.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Bash-brightgreen.svg)](https://www.gnu.org/software/bash/)

## Features

- Create and delete databases
- Create, update, and delete tables
- Insert, select, update, and delete records
- Enforce column data types and primary key constraints
- Simple command-line menu interface
- No external dependencies beyond Bash

## Installation

To install bash-base, clone the repository and make the main script executable:

```sh
git clone https://github.com/john/bash-base.git
cd bash-base
./src/main.sh -x
```

You can then run the application with:

```sh
./src/main.sh
```

No additional setup is required.

## How to Use

After launching the script, you will be presented with a menu. Use the menu options to:

- Create a new database by entering its name
- Select a database to manage its tables
- Create tables by specifying column names, types, and primary keys
- Insert new records, update existing ones, or delete records
- Drop tables or entire databases as needed

All data is stored in plain text files, making it easy to inspect or modify manually if necessary.

## Technologies Used

- Bash scripting
- Standard Unix utilities (awk, sed, grep, etc.)

No third-party dependencies are required.

## Screenshots

Screenshot of the main menu:

![Main Menu Screenshot](https://images2.imgbox.com/09/12/vcVbqbBg_o.png)

Screenshot of database menu:

![Database Menu Screenshot](https://images2.imgbox.com/8a/e4/T3fI2Vv8_o.png)

Screenshot of entry insertion:

![Entry Insertion Screenshot](https://images2.imgbox.com/f7/1c/xdnNKE6H_o.png)

Screenshot of table display:

![Table Display Screenshot](https://images2.imgbox.com/8a/e4/T3fI2Vv8_o.png)


Screenshot of entry deletion:

![Entry Deletion Screenshot](https://images2.imgbox.com/e8/06/TiX8zGEj_o.png)

## Contributing

Contributions are welcome. Please open an issue or submit a pull request if you have suggestions or improvements.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
