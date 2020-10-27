ARG ALPINE_TAG=3.12
ARG DOTNET_TAG=3.1
ARG OMBI_VER=4.0.550

FROM mcr.microsoft.com/dotnet/core/sdk:${DOTNET_TAG}-alpine AS builder

ARG OMBI_VER
ARG DOTNET_TAG
ARG NG_CLI_ANALYTICS=ci

### install ombi
WORKDIR /ombi-src
RUN apk add --no-cache git binutils file; \
    git clone https://github.com/tidusjar/Ombi.git --branch feature/v4 --depth 1 .; \
    yarn --cwd src/Ombi/ClientApp install; \
    yarn --cwd src/Ombi/ClientApp run build; \
    dotnet publish -p:SemVer=${OMBI_VER} -p:FullVer=${OMBI_VER} -p:PublishTrimmed=true -c Release -f netcoreapp${DOTNET_TAG} \
        -r linux-musl-x64 -o /output/ombi src/Ombi; \
    mkdir -p /output/ombi/ClientApp; \
    cp -a src/Ombi/ClientApp/dist /output/ombi/ClientApp/; \
    find /output/ombi -exec sh -c 'file "{}" | grep -q ELF && strip --strip-debug "{}"' \;

COPY *.sh /output/usr/local/bin/
RUN chmod -R u=rwX,go=rX /output/ombi; \
    chmod +x /output/usr/local/bin/*.sh /output/ombi/Ombi

#=============================================================

FROM loxoo/alpine:${ALPINE_TAG}

ARG OMBI_VER
ENV SUID=952 SGID=952

LABEL org.label-schema.name="ombi" \
      org.label-schema.description="A Docker image for the reauest content software Ombi" \
      org.label-schema.url="https://github.com/tidusjar/Ombi" \
      org.label-schema.version=${OMBI_VER}

COPY --from=builder /output/ /

WORKDIR /ombi
RUN apk add --no-cache libstdc++ libgcc libintl icu-libs

VOLUME ["/config"]

EXPOSE 5000/TCP

HEALTHCHECK --start-period=10s --timeout=5s \
    CMD wget -qO /dev/null "http://localhost:5000/api/v1/Status"

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["/ombi/Ombi", "--storage", "/config"]
