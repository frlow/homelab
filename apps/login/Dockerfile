FROM oven/bun as build
ADD * /app/
WORKDIR /app
RUN bun install
RUN bun build --target=bun ./login.ts --outfile=dist/index.js 

FROM oven/bun
COPY --from=build /app/dist/index.js index.js
CMD bun run index.js
EXPOSE 3000