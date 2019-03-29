#!/bin/bash
set -o errexit

cleanup() {
  printf 'Removing container...\n'
  docker rm "$container_name" || true
}

in_dir="$1"
in_file="$2"
out_file="${in_file}.pdf"

container_name="wkhtmltopdf.$$"

owner="$(stat -c "%u:%g" "${in_dir}/${in_file}" )"

printf 'Creating container...\n'
docker create \
 --name "$container_name" \
 wkhtmltopdf \
 wkhtmltopdf \
  --enable-internal-links --print-media-type \
  -L .5in -R .5in -T .5in -B .5in \
  -s Letter --dpi 96 --disable-smart-shrinking \
  "/html/${in_file}" "/html/${out_file}"

trap 'rv=$? ; cleanup ; exit $rv' INT TERM EXIT

printf 'Copying files in...\n'
docker cp "$in_dir" "${container_name}:/html/"

printf 'Starting container...\n'
docker start -a "${container_name}"

printf 'Copying files out...\n'
docker cp "${container_name}:/html/${out_file}" "$(basename "${out_file}" )"

printf 'Fixing file ownership...\n'
chown "$owner" "$(basename "${out_file}" )"

trap - INT TERM EXIT

cleanup

