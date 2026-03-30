# Grimoire

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-CC--BY--SA_4.0-lightgrey)
![Platform](https://img.shields.io/badge/platform-Windows_x64-blue)
![Language](https://img.shields.io/badge/language-Assembly-blue)
![Issues](https://img.shields.io/github/issues/StellarWolfEnt/grimoire-pcg)
![Last commit](https://img.shields.io/github/last-commit/StellarWolfEnt/grimoire-pcg)
![Downloads](https://img.shields.io/github/downloads/StellarWolfEnt/grimoire-pcg/total)
[![Docs](https://img.shields.io/badge/docs-online-purple)](https://stellarwolfent.github.io/grimoire-pcg/)

Grimoire PCG is a procedural content generation library for Windows x64.
It provides deterministic random generation and noise/fractal APIs with a C-facing header surface.

## Current Scope

- Platform target: Windows x64.
- Public headers live in `include/grimoire-pcg`.
- Assembly sources live in `win64`.
- Shared assembler macros live in `inc/common.inc`.
- Windows resource metadata is defined in `res/dll.rc`.

## Features

- `GrimoireRandom` opaque RNG API.
- Seeded and non-seeded RNG creation.
- Integer and floating-point random generation.
- State serialization/deserialization and cloning.
- Value noise (sharp/smooth), Perlin noise, FBM, and Billow helpers.

## Public API Headers

- `include/grimoire-pcg/common.h`
- `include/grimoire-pcg/random.h`
- `include/grimoire-pcg/noise.h`

## Source Layout

```text
inc/
	common.inc
include/
	grimoire-pcg/
		common.h
		noise.h
		random.h
res/
	dll.rc
win64/
	dllmain.asm
	noise.asm
	random.asm
```

## Usage Example

```c
#include <grimoire-pcg/random.h>

GrimoireRandom rng = GrimoireRandom_CreateNew();
if (rng) {
		int32_t value = GrimoireRandom_NextRange(rng, 0, 100);
		(void)value;
		GrimoireRandom_Destroy(rng);
}
```

## Build Notes

This repository contains the library sources and headers.
Build automation used by local development environments may be untracked.

To build, you need a Windows x64 toolchain capable of assembling NASM-style x86-64 and linking a DLL with the Windows SDK resource object.

## Changelog

Release history is tracked in [CHANGELOG.md](CHANGELOG.md).

## Roadmap

Planned platform and project direction is tracked in [ROADMAP.md](ROADMAP.md).

## License

This project is licensed under [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)](LICENSE.md).

## Security

`GrimoireRandom` is not cryptographically secure.
Do not use this library for cryptographic or security-sensitive randomness.

See [Security.md](SECURITY.md) for responsible disclosure guidance.
