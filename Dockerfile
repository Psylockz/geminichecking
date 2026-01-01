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
ENV NODE_OPTIONS=--max-old-space-size=8192

WORKDIR /usr/src/flowise
COPY . .

# 1) instalacja zależności repo
RUN pnpm install

# 2) doinstaluj pakiety, których potrzebujesz w JS Function
# (w monorepo najlepiej dodać je do package.json odpowiedniego workspace,
#  ale to najprostszy działający wariant)
RUN pnpm add cld3-asm franc-min

# 3) build
RUN pnpm build

RUN chown -R node:node .
USER node

EXPOSE 3000
CMD ["pnpm","start"]
