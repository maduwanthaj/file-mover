FROM alpine

# install tzdata and create necessary directories
RUN apk add --no-cache tzdata && \
    mkdir -p /app/source /app/target /app/log

# set the working directory
WORKDIR /app

# define mount points for source, target, and log directories
VOLUME [ "/app/source","/app/target","/app/log" ]

# copy all shell scripts to the working directory and make them executable
COPY scripts/*.sh .
RUN chmod +x *.sh

# set the entrypoint to execute the main entrypoint script
ENTRYPOINT [ "./entrypoint.sh" ]