# Build and test Open Location Code for Swift in Linux.
FROM swift:5.0
RUN mkdir /OpenLocationCode
WORKDIR /OpenLocationCode
ADD . /OpenLocationCode
RUN swift --version
RUN swift build
RUN swift test
