FROM alpine

# 
RUN apk add --no-cache tzdata at && \
    mkdir -p /app/source /app/target /app/log

# 
WORKDIR /app

# 
VOLUME [ "/app/source","/app/target","/app/log" ]

# 
COPY app.sh .
RUN chmod +x app.sh

# 
ENTRYPOINT [ "./app.sh" ]