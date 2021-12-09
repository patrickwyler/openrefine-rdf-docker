FROM java:8-jre-alpine

ENV OPENREFINE_VERSION 3.4.1
ENV RDF_EXTENSION_VERSION 1.3.1
ENV OPENREFINE_FILE openrefine-linux-${OPENREFINE_VERSION}.tar.gz
ENV RDF_EXTENSION_FILE rdf-extension-${RDF_EXTENSION_VERSION}.zip
ENV OPENREFINE_URL https://github.com/OpenRefine/OpenRefine/releases/download/${OPENREFINE_VERSION}/${OPENREFINE_FILE}
ENV RDF_EXTENSION_URL https://github.com/stkenny/grefine-rdf-extension/releases/download/v${RDF_EXTENSION_VERSION}/${RDF_EXTENSION_FILE}

WORKDIR /app

RUN set -xe && \
    apk add --no-cache bash curl jq tar unzip && \
    echo "Download OpenRefine..." && \
    curl -sSL ${OPENREFINE_URL} | tar xz --strip 1 && \
    echo "Download OpenRefine RDF extension..." && \
    cd webapp/extensions && mkdir rdf-extension && \
    curl -sSL ${RDF_EXTENSION_URL} -o rdf-extension.zip && \
    unzip -d rdf-extension rdf-extension.zip && rm rdf-extension.zip && \
    echo "Done installing RDF extension." && \
    echo "Done installing OpenRefine."

VOLUME /data
WORKDIR /data

EXPOSE 3333

ENTRYPOINT ["/app/refine"]
CMD ["-i", "0.0.0.0", "-d", "/data"]
