# Poorly Named Resume Generator (PNRG)
Generates plain-text, formatted-text, and PDF (via LaTeX) resumes from YAML. Looks like PRNG
(psuedo-random number generator), but isn't.

## Build
Regardless of method, generated files are emitted in the `output/` directory.

### Docker
* On macOS, either start the Docker daemon or run `podman machine start`
    * If you haven't yet created a podman virtual machine, run `podman machine init` first!
    * Also consider running `podman machiner set --rootful` since this container runs as `root` (sorry)
* Run `make docker`

### Native
* Install Python 3 and a recent texlive distribution
    * Platform-specific instructions are left as an exercise to the reader
* Run `make`
