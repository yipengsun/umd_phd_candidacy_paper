FROM alpine

# NOTE: `libsrvg`, pandoc uses `rsvg-convert` for working with svg images.
# NOTE: to maintainers, please keep this listing alphabetical.
RUN apk --no-cache add \
        freetype \
        fontconfig \
        gnupg \
        gzip \
        librsvg \
        perl \
        tar \
        wget \
        xz

# DANGER: this will vary for different distributions, particularly the
# `linuxmusl` suffix.  Alpine linux is a musl libc based distribution, for other
# "more common" distributions, you likely want just `-linux` suffix rather than
# `-linuxmusl` -----------------> vvvvvvvvvvvvvvvv
ENV PATH="/opt/texlive/texdir/bin/x86_64-linuxmusl:${PATH}"
WORKDIR /root

COPY ci/texlive.profile /root/texlive.profile
COPY ci/install-texlive.sh /root/install-texlive.sh
RUN bash /root/install-texlive.sh

COPY ci/install-tex-packages.sh /root/install-tex-packages.sh
RUN bash /root/install-tex-packages.sh

RUN rm -f /root/texlive.profile \
          /root/install-texlive.sh \
          /root/install-tex-packages.sh

WORKDIR /data
