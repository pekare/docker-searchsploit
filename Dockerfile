FROM alpine:edge AS builder

WORKDIR /tmp

RUN apk add --no-cache --update git && \
    rm -rf /tmp/* /var/cache/apk/* && \
    git clone https://github.com/offensive-security/exploitdb.git /tmp/exploitdb

FROM alpine:edge

COPY --from=builder /tmp/exploitdb /exploitdb

RUN apk add --no-cache --update bash tput && \
    rm -rf /tmp/* /var/cache/apk/* && \
    sed 's|path_array+=(.*)|path_array+=("/exploitdb")|g' /exploitdb/.searchsploit_rc > ~/.searchsploit_rc

ENV PATH=${PATH}:/exploitdb

ENTRYPOINT ["searchsploit"]