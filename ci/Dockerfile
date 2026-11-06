# Lambdapad needs Erlang (lpad 0.12.0 is built with OTP 29) and Tailwind for CSS assets.
FROM erlang:29

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl \
 && curl -sLO https://github.com/tailwindlabs/tailwindcss/releases/download/v4.1.12/tailwindcss-linux-x64 \
 && chmod +x tailwindcss-linux-x64 \
 && mv tailwindcss-linux-x64 /usr/local/bin/tailwind \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /work
# dymploy runs each step as `sh -ec "<step>"`: the image must not start anything by itself.
ENTRYPOINT []
