# Build and test Open Location Code for Swift in Linux.
FROM swift:3.1
RUN mkdir /OpenLocationCode
WORKDIR /OpenLocationCode
ADD . /OpenLocationCode
RUN swift --version
RUN swift build
RUN swift test
