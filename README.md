# Swift From Scratch

A sample project based on building Swift from scratch on Linux. The project is set up to allow
you to use Swift 3, Swift Package Manager, the new Swift-based Foundation, and the new Swift
Dispatch (GCD) module.

This project is set up to build with Docker so that (1) you don't have to build the Swift binaries
over and over again each time you change your application and (2) so that the output can be run
in a portable manner. This build is not "immutable" in the sense that it tracks Swift version 3.0
(which is not yet finalized). Periodically clearing the Docker build machine's image cache will
allow you to grab fresh Swift sources. This would be a good idea as the codebase evolves and gets
closer to release.

## Make it yours

You can clone this repository, then rename the directory to your project name, edit the name of the
package in `Package.swift`, and edit the name of the `"CMD"` binary in `Dockerfile`.

## Building

Build the Docker image:

```
docker build -t username/appname .
```

**NOTE**: This will take a __long__ time the first time you run it. It shouldn't on subsequent runs.

## Running

```
docker run username/appname
```

## Contributing

Create an issue or send me a PR.
