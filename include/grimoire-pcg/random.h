/**
 * @file random.h
 * @brief Knuth‑derived pseudo-random number generator (RNG)
 *
 * Provides an opaque RNG API based on algorithms derived from Donald Knuth’s work.
 * Supports creation, seeding, destruction, generating integers/floats, filling buffers,
 * and serializing/deserializing state for reproducible sequences.
 *
 * @author Stellar Wolf Entertainment
 * @version 1.0.0
 * @date 2026‑02‑14
 */
#ifndef GRIMOIRE_RANDOM_H
#define GRIMOIRE_RANDOM_H

#include "common.h"

GRIMOIRE_BEGIN

/**
 * @typedef GrimoireRandom_t
 * @brief Opaque RNG instance structure.
 *
 * Users interact with this only through the `GrimoireRandom` handle.
 */
typedef struct GrimoireRandom_t GrimoireRandom_t;

/**
 * @def GrimoireRandom
 * @brief Pointer type to an opaque RNG instance.
 */
#define GrimoireRandom GrimoireRandom_t*

/* Lifecycle -------------------------------------------------------------------------------------------------------- */

/**
 * @brief Creates a new RNG with a non-deterministic seed.
 *
 * The seed is sourced from system‑provided entropy to ensure each instance starts from a unique state.
 *
 * @return A new RNG instance, or `NULL` on failure.
 */
GRIMOIRE_API GrimoireRandom GrimoireRandom_CreateNew();

/**
 * @brief Creates a new RNG with a specific 32-bit seed.
 *
 * Initializes the RNG to a deterministic state based on the provided seed, allowing for reproducible
 * random sequences across runs when the same seed is used.
 *
 * @param seed Seed value for deterministic sequences.
 * @return A new RNG instance, or `NULL` on failure.
 */
GRIMOIRE_API GrimoireRandom GrimoireRandom_CreateSeed(hash_t seed);

/**
 * @brief Destroys an RNG instance
 *
 * Frees all resources associated with the RNG.
 *
 * @param random RNG instance to destroy.
 */
GRIMOIRE_API void GrimoireRandom_Destroy(GrimoireRandom random);

/* Sampling --------------------------------------------------------------------------------------------------------- */

/**
 * @brief Generates a 32-bit pseudo-random integer.
 *
 * Produces a uniformly distributed integer in the half‑open interval [0, INT32_MAX).
 *
 * @param random RNG instance.
 * @return Signed 32-bit integer.
 */
GRIMOIRE_API int32_t GrimoireRandom_Next(GrimoireRandom random);

/**
 * @brief Generates a random integer within [min, max).
 *
 * Produces a uniformly distributed integer in the half‑open interval [min, max).
 *
 * @param random RNG instance.
 * @param min Minimum value (inclusive, must be < max).
 * @param max Maximum value (exclusive).
 * @return Random integer in [min, max).
 */
GRIMOIRE_API int32_t GrimoireRandom_NextRange(GrimoireRandom random, int32_t min, int32_t max);

/**
 * @brief Generates a random integer within [0, max).
 *
 * Produces a uniformly distributed integer in the half‑open interval [0, max).
 *
 * @param random RNG instance.
 * @param max Maximum value (exclusive, must be > 0).
 * @return Random integer in [0, max).
 */
GRIMOIRE_API int32_t GrimoireRandom_NextMax(GrimoireRandom random, int32_t max);

/**
 * @brief Generates a uniform double in [0.0, 1.0).
 *
 * Produces a uniformly distributed double in the half‑open interval [0.0, 1.0).
 *
 * @param random RNG instance.
 * @return Double in [0.0, 1.0).
 */
GRIMOIRE_API double GrimoireRandom_NextDouble(GrimoireRandom random);

/**
 * @brief Fills a buffer with random bytes.
 *
 * Writes `length` bytes of pseudo‑random data into the provided buffer.
 * The buffer is filled sequentially and is not required to be aligned.
 *
 * @param random RNG instance.
 * @param buffer Pointer to buffer to fill.
 * @param length Number of bytes to write.
 */
GRIMOIRE_API void GrimoireRandom_NextBytes(GrimoireRandom random, void* buffer, size_t length);

/* State Management ------------------------------------------------------------------------------------------------- */

/**
 * @brief Serializes RNG state into a buffer.
 *
 * Writes the internal state of the RNG into the provided buffer.
 *
 * @param random RNG instance.
 * @param buffer Output buffer, must be at least 228 bytes.
 */
GRIMOIRE_API void GrimoireRandom_Serialize(GrimoireRandom random, uint8_t* buffer);

/**
 * @brief Restores an RNG from serialized state.
 *
 * Creates a new RNG instance from the provided serialized state.
 *
 * @param buffer Input buffer produced by `GrimoireRandom_Serialize`, must be at least 228 bytes.
 * @return New RNG instance, or `NULL` on failure.
 */
GRIMOIRE_API GrimoireRandom GrimoireRandom_Deserialize(const uint8_t* buffer);

/**
 * @brief Clones an RNG into an existing instance.
 *
 * Copies the state of `source` into `destination`.
 *
 * @param source Source RNG.
 * @param destination Pointer to store the cloned RNG.
 */
GRIMOIRE_API void GrimoireRandom_CloneInto(const GrimoireRandom source, GrimoireRandom destination);

/**
 * @brief Clones an RNG and returns the new instance.
 *
 * Creates a new RNG instance with the same state as the source.
 *
 * @param source Source RNG.
 * @return New RNG instance with identical state, or `NULL` on failure.
 */
GRIMOIRE_API GrimoireRandom GrimoireRandom_Clone(const GrimoireRandom source);

GRIMOIRE_END

#endif // GRIMOIRE_RANDOM_H