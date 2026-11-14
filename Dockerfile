# Build and test Open Location Code for Swift in Linux.
FROM swift:6.0
WORKDIR /OpenLocationCode
COPY . .
RUN swift --version
RUN swift build
RUN swift test
