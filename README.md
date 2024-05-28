# [Custom Base Docker Image with S6 Overlay](https://github.com/DockForge/base-linux)

This project provides a custom base Docker image built on Alpine Linux, integrated with S6 Overlay for efficient process management. It is designed to be lightweight, secure, and extensible, making it ideal for various deployment environments. The image supports multiple architectures, including amd64 and arm64, ensuring versatility. It includes automated GitHub Actions workflows to build and push the image to DockerHub, facilitating seamless integration and deployment. This base image is suitable for developers looking to create reliable and manageable containerized applications.

## Installation Instructions

To install and run this project, follow these specific instructions:

### Pulling the Docker Image from DockerHub

- **Latest Stable Image**:
  ```bash
  docker pull dublok/base-image:alpine-latest
  ```
- **Latest Nightly Build Image**:
  ```bash
  docker pull dublok/base-image:alpine-main
  ```
- **Specific Version** (e.g., version `v0.0.1`):
  ```bash
  docker pull dublok/base-image:alpine-v0.0.1
  ```

### Running the Container

To run the container using the pulled image, use the following command:
```bash
docker run -d dublok/base-image:alpine-latest
```
Replace `alpine-latest` with `alpine-main` or `alpine-v0.0.1` if you are using the nightly build or a specific version, respectively.

### Customizing and Building the Image Locally

If you need to customize the base image, you can clone the repository and build it locally.
```bash
git clone https://github.com/DockForge/base-linux.git
cd custom-base-image
docker build -t yourusername/custom-base-image:latest .
```

### Running the Customized Container

Run the container using your customized image:
```bash
docker run -d yourusername/custom-base-image:latest
```

By following these instructions, you can easily install and run the custom base image tailored to your requirements. For more details and updates, you can check the DockerHub repository: [dublok/base-linux](https://hub.docker.com/r/dublok/base-linux).

## Usage

This custom base Docker image has several common use cases:

- **Microservices**: Ideal for deploying microservices due to its lightweight and secure nature. The image's efficient process management ensures reliable service operation.
- **Development Environments**: Suitable for creating consistent and isolated development environments. Its minimal footprint allows for quick setup and efficient use of resources.
- **Custom Applications**: A great foundation for building custom applications. Developers can easily extend the base image with specific dependencies, creating smaller and more secure images.
- **CI/CD Pipelines**: Can be integrated into CI/CD pipelines to automate the building, testing, and deployment of applications. Its multi-architecture support ensures compatibility across different platforms.
- **Containerized Services**: Useful for running containerized services such as web servers or APIs. The image's process management features enhance service stability and performance.
- **Testing Environments**: Perfect for setting up isolated testing environments. This helps ensure that applications function correctly and are compatible with production environments before deployment.

## Contributing

We welcome contributions from the community. If you wish to contribute, please follow these guidelines:

1. Fork the repository and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. Ensure the test suite passes.
4. Make sure your code lints.
5. Open a pull request with a detailed description of your changes.

## Contact Information

- Email: [dockforge@gmail.com](mailto:dockforge@gmail.com) / [dockforge@dublok.com](mailto:dockforge@dublok.com)
- Main Maintainer: Ercin Dedeoglu [LinkedIn](https://www.linkedin.com/in/ercindedeoglu/)

## Dependencies

This project relies on several key dependencies to function correctly:

- **Alpine Linux**: The base image is built on Alpine Linux, a lightweight and secure Linux distribution.
- **S6 Overlay**: This is used for process supervision and management within the container, ensuring that services are reliably managed.
- **Essential Packages**: Several core packages are installed during the build process, including:
  - `alpine-baselayout`
  - `alpine-keys`
  - `apk-tools`
  - `busybox`
  - `libc-utils`
  - `bash`
  - `xz`
  - `ca-certificates`
  - `curl`
  - `jq`
  - `netcat-openbsd`
  - `procps-ng`
  - `shadow`
  - `tzdata`
- **Docker**: Docker must be installed and properly configured on the system to build and run the container images.
- **GitHub Actions**: For automated building and pushing of the Docker images, the project uses GitHub Actions, which includes actions for setting up QEMU, Docker Buildx, and Docker login.

These dependencies are crucial for the smooth operation and functionality of the custom base image, providing a secure and efficient environment for various applications.

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007. See the [LICENSE](LICENSE) file for more details.
