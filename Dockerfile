FROM lsiobase/alpine.nginx:3.8

# set version label
ARG ORGANIZR_COMMIT
ARG BUILD_DATE
ARG VERSION

LABEL build_version="OrganizrTools version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="OrganizrTools"

# install packages
RUN \
echo "**** install runtime packages ****" && \
apk add --no-cache \
	curl \
	php7-curl \
	php7-ldap \
	php7-pdo_sqlite \
	php7-sqlite3 \
	php7-session \
	php7-zip \
	php7-xmlrpc \
	mediainfo && \
echo "**** fetch organizr ****" && \
mkdir -p\
	/var/www/html && \
if [ -z ${ORGANIZR_COMMIT+x} ]; then \
	ORGANIZR_COMMIT=$(curl -sX GET "https://api.github.com/repos/causefx/Organizr/branches/v2-master" \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
fi && \
curl -o \
	/tmp/organizr.tar.gz -L \
	"https://github.com/causefx/Organizr/archive/${ORGANIZR_COMMIT}.tar.gz" && \
tar xf \
	/tmp/organizr.tar.gz -C \
	/var/www/html/ --strip-components=1 && \
echo "**** cleanup ****" && \
rm -rf \
	/root/.compose

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config
