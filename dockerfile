FROM nginx:stable-alpine 
# NOTE:
#    Fundamental changes to the image should be planned and communicated to users, to remain
#    transparent and to allow them to increase their testing after build.
USER root
#COPY nginx-repo.crt /etc/ssl/nginx/
#COPY nginx-repo.key /etc/ssl/nginx/
#COPY nginx-repo.jwt /etc/nginx/license.jwt
#COPY repos.d/nginx-plus-8.repo /etc/yum.repos.d/nginx-plus-8.repo
#RUN yum install -y ca-certificates \
#    nginx-plus-module-headers-more \
#    nginx-plus && \
#    yum -y update libksba && \
#    yum clean all && \
#    mkdir -p /etc/ssl/nginx && \
#    rm -fv /etc/nginx/conf.d/default.conf && \
#    ln -sf /dev/stdout /var/log/nginx/access.log && \
#    ln -sf /dev/stderr /var/log/nginx/error.log
#COPY nginx.conf /etc/nginx/nginx.conf
#COPY conf.d/ /etc/nginx/conf.d/
#COPY ssl/ /etc/ssl/
# Fix OSE permission problems
RUN chmod -R g+w /var/cache/nginx /etc/nginx/conf.d/ && \
    chmod g+w /etc/ssl/*.pem && \
    mkdir /var/cache/nginx/client_temp && \
    chown -R testuser:testuser /var/cache/nginx /var/ /etc/nginx /etc/ssl || true && \
    rm -rf /etc/ssl/nginx/nginx-repo.key

RUN touch /var/run/nginx.pid && chmod 666 /var/run/nginx.pid && \
    ls -lrtha /var/run/

EXPOSE 9000
ENTRYPOINT ["mi-tec", "-t", "/etc/nginx/conf.d/*.conf", "-t", "/etc/ssl/*.pem"]
CMD ["nginx"]
USER testuser
