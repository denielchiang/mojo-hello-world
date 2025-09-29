# Mojo Hello World

A minimal [Mojolicious](https://mojolicious.org/) web application written in Perl.

## Requirements
* **Perl 5.40** – recommended to manage via [plenv](https://github.com/tokuhirom/plenv)
* [Carton](https://metacpan.org/pod/Carton) – dependency manager for Perl

## Setup

Clone and install dependencies:

    git clone git@github.com:<your-username>/mojo-hello-world.git
    cd mojo-hello-world
    carton install

This installs all modules listed in `cpanfile` into the local `local/` directory.

## Development

Start the development server with hot reload:

    carton exec morbo script/hello_world
    # Visit http://127.0.0.1:3000

## Testing

Run the test suite:

    carton exec prove -lr t

## Deployment

For production, run with the built-in Hypnotoad server:

    carton exec hypnotoad script/hello_world

## Project Layout

    lib/HelloWorld.pm         # Application class
    script/hello_world        # Main app launcher
    templates/                # Templates (HTML::EP)
    public/                   # Static files
    t/                        # Tests
    cpanfile                  # Perl dependencies
    cpanfile.snapshot         # Locked dependency versions

---

Generated with:

    carton exec mojo generate app HelloWorld

Flattened to a single-app layout for easier CI/CD and deployment.
