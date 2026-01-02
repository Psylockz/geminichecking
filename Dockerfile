FROM node:20-alpine

RUN apk update && apk add --no-cache \
  libc6-compat \
    python3 \
      make \
        g++ \
          build-base \
            cairo-dev \
              pango-dev \
                chromium \
                  curl && \
                    npm install -g pnpm

                    ENV PUPPETEER_SKIP_DOWNLOAD=true
                    ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
                    ENV NODE_OPTIONS=--max-old-space-size=4096
                    ENV ROLLUP_MAX_PARALLEL=1

                    WORKDIR /usr/src/flowise
                    COPY . .

                    # 1) instalacja zależności repo
                    RUN pnpm install

                    # 3) build
                    RUN pnpm turbo run build --concurrency=1


                    RUN chown -R node:node .
                    USER node

                    EXPOSE 3000
                    CMD ["pnpm","start"]
                    
