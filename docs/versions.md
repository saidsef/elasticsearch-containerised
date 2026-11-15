# Versions

`main`, `latest` and `v2026.11` run Elasticsearch 9.5.5. Elastic's [end-of-life table](https://www.elastic.co/support/eol) no longer lists Elasticsearch 6.8. To stay on 6.8, pin git tag `v2026.09` and image `docker.io/saidsef/elasticsearch:v2026.09`, the last 6.8 release.

| Elasticsearch | Docker image tags | Git tags |
|---|---|---|
| 9.5.5 | `latest`, `v2026.11` | `v2026.11` |
| 6.8.23 | `v2026.09`, `v2026.06`, `v2024.10`, `v2024.06`, `v2023.12`, `v2023.09`, `v2023.02`, `v2023.01` | `v2026.09`, `v2026.06`, `v2024.10`, `v2024.06`, `v2023.12`, `v2023.09`, `v2023.02`, `v2023.01`, `v2022.12`, `v2022.11`, `v2022.10`, `v2022.01` |
| 6.8.18 | `v2021.09` | `v2021.08`, `v8` |
| 6.8.6 to 6.8.20 | None | `v2021.10`, `v2021.09`, `v7`, `v6`, `v5`, `v4`, `v3`, `v1.0` |
| 8.17.0 | None | `v2026.04`, `v2025.11`, `v2025.09`, `v2025.08`, `v2024.12` |

- The 8.17.0 git tags change only the Dockerfile. Docker Hub does not have an image for them, and their manifests deploy image `v2023.01`, which runs 6.8.23.
- Image `v2021.09` dates from 9 September 2021 and runs 6.8.18. Git tag `v2021.09` points at a commit from 30 September that moved to 6.8.19.
- The repository has never published Elasticsearch 5.

## Release tags

A merge to `main` that changes a file the [CI workflow](https://github.com/saidsef/elasticsearch-containerised/blob/main/.github/workflows/docker.yml) watches, such as the Dockerfile, builds `latest` and the current month's `vYYYY.MM` image. The Tagging workflow then points git tag `vYYYY.MM` at that commit. The Release workflow publishes a GitHub release for the tag. A monthly tag can change until the month ends.

A merge that changes only the documentation or the manifests in `deployment/` does not build an image or move a tag.
