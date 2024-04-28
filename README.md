# Furniture and Appliances Rental App

This project is a Furniture and Appliances Rental App developed using Flutter for the frontend, Express.js for the backend server, and MongoDB for the database. The app allows users to browse, rent, and manage furniture and appliances for short-term or long-term use.

## Features

- User authentication and authorization
- Browse available furniture and appliances
- Filter and search functionality
- Rental history and management
- Payment integration
- Admin panel for managing inventory and users

## Repositories

- [Frontend Repository](https://github.com/akodali9/rental_app): Contains the Flutter code for the frontend of the app.
- [Backend Repository](https://github.com/akodali9/rentalapp_server): Contains the Express.js code for the backend server.

## Technologies Used

- **Frontend**: Flutter
- **Backend**: Express.js
- **Database**: MongoDB
- **Server Hosting**: Render

## Getting Started

To get started with the development, follow these steps:

1. Clone the frontend repository:

   ```bash
   git clone <https://github.com/akodali9/rental_app.git>

2. Clone the backend repository:

   ```bash
   git clone <https://github.com/akodali9/rentalapp_server.git>

3. Install dependencies for both frontend and backend:

    1. Frontend repo
        ```bash
        #For frontend
        cd <frontend-folder>
        flutter pub get
    2. Backend repo
        ```bash
        # For backend
        cd <backend-folder>
        npm install

4. Configure environment variables:
    - For the backend, create a .env file and define environment variables like database connection URL, JWT secret, etc.

5. Start the backend server:
    ```bash
    cd <backend-folder>
    npm start
6. Run the frontend app:
    ```bash
    cd <frontend-folder>
    flutter run

## Deployment:

To host the backend server, follow these steps:

    1. Choose a hosting provider (e.g., AWS, Google Cloud Platform, Heroku).
    2. Set up a MongoDB instance for the database.
    3. Configure environment variables for the production environment.
    4. Deploy the backend server to the hosting provider.
    5. Update frontend API endpoints to point to the deployed backend server.


License
This project is licensed under the MIT License.
