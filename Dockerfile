# image used for the healthcheck binary
FROM golang:1.15-buster AS gobuilder
COPY healthcheck/ /go/src/healthcheck/
RUN CGO_ENABLED=0 go build -ldflags '-w -s -extldflags "-static"' -o /healthcheck /go/src/healthcheck/

# -- BUILD STAGE --------------------------------
FROM node:lts-slim AS build

WORKDIR /src

# Define build arguments & map them to environment variables
ARG NPM_TOKEN
ARG FONTAWESOME_TOKEN
ENV NEXT_TELEMETRY_DISABLED=1

# Build the project and then dispose files not necessary to run the project
# This will make the runtime image as small as possible
COPY . .
RUN yarn install --frozen-lockfile
RUN yarn build
RUN yarn install --production
RUN rm -rf .next/cache

# -- RUNTIME STAGE --------------------------------

FROM gcr.io/distroless/nodejs:14

WORKDIR /app

# copy in our healthcheck binary
COPY --from=gobuilder --chown=nonroot /healthcheck /healthcheck

COPY --chown=nonroot --from=build /src/package.json /app/package.json
COPY --chown=nonroot --from=build /src/node_modules /app/node_modules
COPY --chown=nonroot --from=build /src/.next /app/.next
COPY --chown=nonroot --from=build /src/public /app/public
COPY --chown=nonroot --from=build /src/next.config.js /app/next.config.js

# default next.js port
EXPOSE 3000

# healthcheck to report the container status
HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD [ "/healthcheck", "3000" ]

CMD ["/app/node_modules/.bin/next", "start", "-p", "3000"]
