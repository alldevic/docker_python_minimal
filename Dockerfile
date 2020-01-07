FROM alpine:3.11.2 AS build
ENV PYTHONUNBUFFERED 1
RUN apk add --no-cache python3
RUN if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi

RUN pip3 uninstall pip setuptools -y

RUN rm -rf /root/.cache /root/.local \
    /etc/apk/ /usr/share/apk/ /lib/apk/ /sbin/apk \
    /media /usr/lib/terminfo /usr/share/terminfo \
    /usr/lib/python*/ensurepip \
    /usr/lib/python*/lib2to3 \
    /usr/bin/2to3* \
    /usr/lib/python*/site-packages/*.dist-info \
    /usr/lib/python*/site-packages/*.egg-info \
    /usr/lib/python*/turtledemo  \
    /usr/lib/python*/turtle.py /usr/lib/python*/__pycache__/turtle.* \
    /var/cache/apk \
    /var/lib/apk

RUN find /usr/lib/python*/* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf

RUN python3 -m compileall -b /usr/lib/python*
RUN find /usr/lib/python*/* -name "*.py"|xargs rm -rf
RUN find /usr/lib/python*/* -name '*.c' -delete
RUN find /usr/lib/python*/* -name '*.pxd' -delete
RUN find /usr/lib/python*/* -name '*.pyd' -delete
RUN find /usr/lib/python*/* -name '__pycache__' | xargs rm -r


FROM scratch AS deploy
ENV PYTHONUNBUFFERED 1
COPY --from=build / /
