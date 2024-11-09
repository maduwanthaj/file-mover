# File Mover Container 📁

A lightweight Docker container for automated file moving and logging, using `cron` to handle both recurring and one-time file-moving tasks between specified directories.

## Features

- Customizable schedule for recurring file-moving tasks.
- One-time or immediate file-moving task execution using `cron`.
- Logging of each file transfer, with error messages logged separately.
- Lightweight Alpine-based Docker image with support for setting time zones.

## Getting Started

### Prerequisites

- Docker installed on your system.

### Build the Image

To build the Docker image locally:

```bash
docker build -t file-mover .
```

### Running the Container

Start the container to run with default behavior. By default, it will check for files in `/app/source` and move them to `/app/target`, logging each operation to `/app/log/file-mover.log`.

#### Example

```bash
docker run -d --name file-mover \
  -v /path/to/source:/app/source \
  -v /path/to/target:/app/target \
  -v /path/to/log:/app/log \
  file-mover
```

## Configuration

The container accepts the following command-line options:

| Option              | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `--schedule [TIME]` | Schedule the container to run the file move operation repeatedly at a specified time (e.g., `* * * * *` cron format). |
| `--run-once [TIME]` | Run the container to execute the file move operation once at a specified time in `cron` format (e.g., `00 21 1 12 *` to run at 9:00 PM on December 1st). If no time is provided, the operation runs immediately. |
| `--help`            | Display help message with available options.                                |
| `--version`         | Display the script version.                                                 |

### Example Usage

#### Run Once at a Specific Time

This command schedules a one-time execution of the file-moving operation at a specified time using `cron` format (e.g., `00 21 1 12 *` to run at 9:00 PM on the 1st of December):

```bash
docker run --rm -d --name file-mover \
  -v /path/to/source:/app/source \
  -v /path/to/target:/app/target \
  -v /path/to/log:/app/log \
  -e TZ=Asia/Colombo \
  file-mover --run-once "00 21 1 12 *"
```

If the `--run-once` option is used with no time argument, the operation will execute immediately.

#### Schedule Recurring File Moves

To schedule a recurring file-moving operation every day at 9:00 PM, while ensuring the container restarts if stopped:

```bash
docker run -d --name file-mover \
  -v /path/to/source:/app/source \
  -v /path/to/target:/app/target \
  -v /path/to/log:/app/log \
  --restart always \
  -e TZ=Asia/Colombo \
  file-mover --schedule "00 21 * * *"
```

### Setting the Time Zone

Use the `TZ` environment variable to set the container's time zone. The example above uses `Asia/Colombo`. 

## Directory Structure

The container defines the following directories for file operations:

- **/app/source**: Mount this directory as the source location for files to be moved.
- **/app/target**: Mount this directory as the destination for files being moved.
- **/app/log**: Mount this directory for storing logs of file operations.

## File Structure

- **Dockerfile**: Sets up the Alpine environment, installs `tzdata`, and configures the working directories and entrypoint script.
- **entrypoint.sh**: Main entry script that handles command-line options and schedules tasks with `cron`.
- **app.sh**: The core script that checks for new files in the source directory, moves them to the target directory, and logs each operation.

## Logging

All file-moving operations are logged to `/app/log/file-mover.log` with time-stamped informational messages. Errors are also logged with details.

### Sample Log Output

```
time=2024-09-15 15:20:35 level=info msg=checking for new files.
time=2024-09-15 15:20:36 level=info msg=2 file(s) found.
time=2024-09-15 15:20:36 level=info msg=example.txt has been moved.
```

## Docker Compose Example

Here’s an example `docker-compose.yml` file to run the container with Docker Compose:

```yaml
services:
  file-mover:
    image: file-mover
    container_name: file-mover
    volumes:
      - /path/to/source:/app/source
      - /path/to/target:/app/target
      - /path/to/log:/app/log
    environment:
      - TZ=Asia/Colombo
    command: ["--schedule", "00 21 * * *"]
    restart: always
```

To start the container with Docker Compose:

```bash
docker-compose up -d
```

## Help and Version

You can display the help message and version information by running the container with the respective options:

```bash
# Display help message
docker run --rm file-mover --help

# Display version information
docker run --rm file-mover --version
```

## License

This project is licensed under the MIT License.