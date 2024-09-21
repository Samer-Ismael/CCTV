# CCTV

A very simple CCTV camera application in Python. This project allows you to host multiple USB cameras and stream them live on `localhost:8080`.

## Features

- Stream live video from multiple USB cameras
- Easy to set up and configure

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/Samer-Ismael/CCTV.git
    cd CCTV
    ```

2. Install the required dependencies:
    ```sh
    pip install -r requirements.txt
    ```

## Usage

1. Run the application:
    ```sh
    python main.py
    ```

2. Open your web browser and navigate to `http://localhost:8080` to view the live streams.

## Deployment to Raspberry Pi

To deploy this application to a Raspberry Pi and run it as a service, follow these steps:

1. Ensure SSH is enabled on your Raspberry Pi.
2. Update the `deploy.sh` script with the correct Raspberry Pi user and host.
3. Run the deployment script:
    ```sh
    ./deploy.sh
    ```

## Configuration

You can edit the code to host more than one USB camera. Modify the configuration section in `main.py` to add additional cameras.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.