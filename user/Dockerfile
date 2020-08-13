FROM debian:buster

RUN apt-get update && apt-get install -y curl netcat


COPY ./entrypoint.sh /bin/entrypoint.sh


ENTRYPOINT [ "/bin/entrypoint.sh" ]