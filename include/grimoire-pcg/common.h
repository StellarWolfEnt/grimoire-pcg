/**
 * @file common.h
 *
 * @brief Common definitions and utilities for Grimoire libraries.
 *
 * This header provides platform normalization, export/import attributes, deprecation macros,
 * C/C++ linkage macros, and standard type definitions used across all Grimoire libraries.
 *
 * @author Stellar Wolf Entertainment
 * @version 1.0.0
 * @date 2026‑03-30
 */

// clang-format off
#ifndef GRIMOIRE_COMMON_H
#define GRIMOIRE_COMMON_H

/* Platform Normalization ------------------------------------------------------------------------------------------- */

#if !defined(_WIN32) && (defined(__WIN32__) || defined(WIN32) || defined(__MINGW32__))
#   define _WIN32
#endif

/* Export / Import Attributes ---------------------------------------------------------------------------------------- */

#ifndef GRIMOIRE_STATIC
#   ifdef _WIN32
#       ifdef _GRIMOIRE_BUILD
#           define GRIMOIRE_API __declspec(dllexport)
#       else
#           define GRIMOIRE_API __declspec(dllimport)
#       endif
#   elif defined(__GNUC__) || defined(__clang__)
#       define GRIMOIRE_API __attribute__((visibility("default")))
#   endif
#endif

#ifndef GRIMOIRE_API
#   define GRIMOIRE_API
#endif

/* Deprecation Attributes ------------------------------------------------------------------------------------------- */

#ifdef _MSC_VER
#   define GRIMOIRE_DEPRECATED(msg) __declspec(deprecated(msg))
#elif defined(__GNUC__) || defined(__clang__)
#   define GRIMOIRE_DEPRECATED(msg) __attribute__((deprecated(msg)))
#else
#   define GRIMOIRE_DEPRECATED(msg)
#endif

/* C / C++ Linkage -------------------------------------------------------------------------------------------------- */

#ifdef __cplusplus
#   define GRIMOIRE_BEGIN extern "C" {
#   define GRIMOIRE_END   }
#else
#   define GRIMOIRE_BEGIN
#   define GRIMOIRE_END
#endif

/* Standard Types --------------------------------------------------------------------------------------------------- */

#include <stdbool.h>
#include <stdint.h>

/**
 * @typedef hash_t
 * @brief 32-bit signed integer used as a deterministic seed.
 *
 * Suitable for RNGs, noise functions, or any system requiring reproducible
 * initialization. Identical seeds guarantee identical output.
 */
typedef int32_t hash_t;

#endif /* GRIMOIRE_COMMON_H */
// clang-format on