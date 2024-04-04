# Wallet-API

## Setting up Devise Key

Devise, a flexible authentication solution for Rails, requires a secret key for encrypting and verifying user sessions. Follow these steps to generate a secret key:

1. Generate a secret key using the following Ruby code:
    ```ruby
    require 'securerandom'

    # Generates a 32-byte (256-bit) secret key
    secret_key = SecureRandom.hex(32)

    puts secret_key
    ```
2. Note down the generated secret key for later use.
3. Open your Rails application's credentials by running:
    ```bash
    EDITOR=nano bin/rails credentials:edit
    ```
4. Add the following line to your credentials file, replacing {your_secret_key} with the generated secret key:
    ```yaml
    devise_jwt_secret_key: {your_secret_key}
    ```
5. Save and close the credentials file.

## Installing Dependencies

After setting up the Devise key, install the necessary dependencies using the following command:

```bash
bundle install
```

### Initializing the Database

Before running the Rails server, initialize the database by running the following commands:

```bash
rails db:create
rails db:migrate
```

## Starting PostgreSQL Service
### macOS:

If you're using macOS, start the PostgreSQL service using Homebrew:

```bash
brew services start postgresql
```

### Windows:

If you're using Windows, start the PostgreSQL service with the following command:

```bash
sudo service postgresql start
```
## Starting Rails Server

Once the dependencies are installed, the PostgreSQL service is running, and the database is initialized, start your Rails server using:

```bash
rails server
```
