FROM ubuntu:15.10
MAINTAINER Ankur Oberoi <aoberoi@gmail.com>

# Get Swift dependencies
RUN apt-get update && \
    apt-get install -y \
      autoconf \
      clang \
      cmake \
      git \
      icu-devtools \
      libblocksruntime-dev \
      libbsd-dev \
      libedit-dev \
      libicu-dev \
      libncurses5-dev \
      libpython-dev \
      libsqlite3-dev \
      libtool \
      libxml2-dev \
      ninja-build \
      pkg-config \
      python \
      swig \
      systemtap-sdt-dev \
      uuid-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get Swift sources
ENV PATH /usr/bin:$PATH
RUN git config --global user.email "Docker Build" && \
    git config --global user.name "dockerbuild@fake.com"
RUN mkdir /swift-src && \
    cd /swift-src && \
    git clone --branch swift-3.0-branch --single-branch https://github.com/apple/swift.git && \
    ./swift/utils/update-checkout --clone --branch swift-3.0-branch

# Build and Install Swift binaries
RUN /swift-src/swift/utils/build-script --assertions --no-swift-stdlib-assertions --llbuild --swiftpm --xctest --build-subdir=buildbot_linux --lldb --release --libdispatch --foundation --lit-args=-v -- --swift-enable-ast-verifier=0 --install-swift --install-lldb --install-llbuild --install-swiftpm --install-xctest --install-prefix=/usr '--swift-install-components=autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license' --build-swift-static-stdlib --build-swift-static-sdk-overlay --install-destdir=/ --installable-package=/swift.tar.gz --install-libdispatch --install-foundation --reconfigure

# The above command is the result of patching the buildbot_linux_1510 preset with libdispatch, and then taking the expanded build-script command, and making minor edits.
# Fully expanded form: ./swift/utils/build-script --assertions --no-swift-stdlib-assertions --llbuild --swiftpm --xctest --build-subdir=buildbot_linux --lldb --release --test --validation-test --long-test --libdispatch --foundation --lit-args=-v -- --swift-enable-ast-verifier=0 --install-swift --install-lldb --install-llbuild --install-swiftpm --install-xctest --install-prefix=/usr '--swift-install-components=autolink-driver;compiler;clang-builtin-headers;stdlib;swift-remote-mirror;sdk-overlay;license' --build-swift-static-stdlib --build-swift-static-sdk-overlay --build-swift-stdlib-unittest-extra --test-installable-package --install-destdir=/ --installable-package=/swift.tar.gz --install-libdispatch --install-foundation --reconfigure
# Useful commands to derive this (but the tests may fail):
# ADD tools/patches/build-presets.ini.add-libdispatch.patch /tools/patches/build-presets.ini.add-libdispatch.patch
# RUN cd /swift-src/swift/utils && \
#     patch < /tools/patches/build-presets.ini.add-libdispatch.patch && \
#     git add build-presets.ini && \
#     git commit -m "patched build presets for adding libdispatch" && \
#     cd /swift-src && \
#     ./swift/utils/build-script --preset buildbot_linux_1510 install_destdir="/" installable_package="/swift.tar.gz"

# Add application sources
ADD . /app
WORKDIR /app

# Build application
RUN swift build -Xcc -fblocks

# Run application
# NOTE: rename the binary here for your own project
CMD [".build/debug/SwiftFromScratch"]
