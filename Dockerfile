# syntax=docker/dockerfile:1.4

# BUILD STAGE
FROM --platform=linux/amd64 haskell:9.6.7-slim AS build

WORKDIR /work

# Najprv sa vyriesia vsetky dependencies - pri zmene  
# zdrojoveho kodu sa len vytiahnu z cache
COPY flp-fun.cabal cabal.project ./
RUN cabal update \
 && cabal build --only-dependencies lib:flp-fun-lib exe:flp-fun

# Potom build zdrojoveho kodu
COPY src/ ./src/
COPY app/ ./app/
RUN cabal build exe:flp-fun

# Skopirovanie executable pre finalny obraz
RUN cp "$(cabal list-bin exe:flp-fun)" /work/flp-fun


# TEST STAGE
FROM build AS test

COPY test/ ./test/
RUN cabal test --test-show-details=streaming


# RUNTIME STAGE

# debian:bookworm-slim poradil chatbot, maly obraz = rychly build
# runtime obraz ma < 100MB oproti 4.5GB pri build stage
#   - diffutils pre diff 
#   - libgmp10, libffi8 su dependencies runtimu
FROM --platform=linux/amd64 debian:bookworm-slim AS runtime

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      diffutils \ 
      libgmp10 \
      libffi8 \
      python3 \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Skopirovanie executablu z build stage.
COPY --from=build /work/flp-fun /app/flp-fun
ENTRYPOINT ["/app/flp-fun"]
CMD ["--help"]
