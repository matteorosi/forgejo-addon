FROM codeberg.org/forgejo/forgejo:12.0.3

RUN mkdir -p /data && chown -R git:git /data

COPY run.sh /
RUN chmod a+x /run.sh

EXPOSE 3000 22

CMD [ "/run.sh" ]
