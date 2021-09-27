docker run  -d \
            --rm \
            --name anki-server \
            -p 27701:27701 \
            -v /data/anki:/anki/data \
            mingwiki/anki-sync-server:v1