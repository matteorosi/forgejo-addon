FROM codeberg.org/forgejo/forgejo:12.0.3
RUN mkdir -p /data/custom/conf /data/repositories /data/log
COPY run.sh /
RUN chmod +x /run.sh
EXPOSE 3000 22
CMD ["/run.sh"]
