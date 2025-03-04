# Flint

*Flint is still in development so breaking changes may occur.*

Flint is a tool for encoding and decoding different data formats in sequence. Note that Flint is still in development, and some UI
features are not yet implemented.

## Features

- Supports encoding and decoding of different data formats in sequence.

## Installation

1. Clone the repository.
    ```bash
    git clone https://github.com/chriso345/flint.git
    ```

2. Install the dependencies.
    ```bash
    opam install dune cohttp-lwt-unix
    ```

3. Use the `Flint.sh` script to format, build, and run the project.
    ```bash
    Flint.sh --fmt --build --run
    ```

## Technologies

- Written in OCaml with the following libraries:
    - `Dune` for building the project.
    - `Cohttp` and `Lwt` for handling HTTP requests.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
