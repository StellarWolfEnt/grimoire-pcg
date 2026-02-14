/**
 * @file random.h
 * @brief Knuth‑derived Random Number Generator
 *
 * This header defines the public interface for a pseudo‑random number generator
 * based on algorithms originating from Donald Knuth’s work. The API provides
 * functions to create and destroy generator instances, produce random integers
 * and floating‑point values, fill arbitrary buffers with random bytes, and
 * serialize/deserialize generator state for persistence or replication.
 *
 * The implementation is opaque and hidden from users of the API, allowing the
 * internal algorithm to evolve without breaking binary or source compatibility.
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
 * @brief Incomplete struct representing the RNG instance.
 *
 * This struct is intentionally incomplete in the header. Users interact with
 * the generator only through the pointer type @ref GrimoireRandom, ensuring
 * full encapsulation of internal state and implementation details.
 */
typedef struct GrimoireRandom_t GrimoireRandom_t;

/**
 * @def GrimoireRandom
 * @brief Opaque handle to a random number generator instance.
 *
 * This macro defines `GrimoireRandom` as a pointer to the opaque
 * `GrimoireRandom_t` structure. It simplifies function signatures and user code
 * by allowing the type to be treated as a direct handle without exposing the
 * underlying structure.
 */
#define GrimoireRandom GrimoireRandom_t*

/**
 * @brief Creates a new random number generator with a non‑deterministic seed.
 *
 * The seed source is implementation‑defined (e.g., system entropy, time‑based
 * seed, or platform‑specific randomness). Use this when deterministic behavior
 * is not required.
 *
 * @return A newly allocated RNG instance, or `NULL` on failure.
 */
GRIMOIRE_API GrimoireRandom GrimoireRandom_CreateNew();

/**
 * @brief Creates a new random number generator with a specific seed.
 *
 * Use this function when deterministic, reproducible sequences are required.
 *
 * @param seed The 32‑bit integer seed value.
 * @return A newly allocated RNG instance, or `NULL` on failure.
 */
GRIMOIRE_API GrimoireRandom GrimoireRandom_CreateSeed(int32_t seed);

/**
 * @brief Destroys a random number generator instance.
 *
 * Frees all memory associated with the RNG. Passing `NULL` is safe and has no
 * effect.
 *
 * @param random The RNG instance to destroy.
 */
GRIMOIRE_API void GrimoireRandom_Destroy(GrimoireRandom random);

/**
 * @brief Generates the next 32‑bit pseudo‑random integer.
 *
 * @param random The RNG instance.
 * @return A signed 32‑bit pseudo‑random integer.
 */
GRIMOIRE_API int32_t GrimoireRandom_Next(GrimoireRandom random);

/**
 * @brief Generates a random integer within a specified inclusive range.
 *
 * The result is uniformly distributed between `min` and `max` (inclusive).
 * Behavior is undefined if `min > max`.
 *
 * @param random The RNG instance.
 * @param min The minimum value (inclusive).
 * @param max The maximum value (inclusive).
 * @return A random integer in the range [`min`, `max`].
 */
GRIMOIRE_API int32_t GrimoireRandom_NextRange(GrimoireRandom random, int32_t min, int32_t max);

/**
 * @brief Generates a random integer in the range [0, max].
 *
 * Equivalent to calling `GrimoireRandom_NextRange(random, 0, max)`.
 * Behavior is undefined if `max < 0`.
 *
 * @param random The RNG instance.
 * @param max The maximum value (inclusive).
 * @return A random integer in the range [0, max].
 */
GRIMOIRE_API int32_t GrimoireRandom_NextMax(GrimoireRandom random, int32_t max);

/**
 * @brief Generates a random double in the range [0.0, 1.0).
 *
 * The distribution is uniform across the interval.
 *
 * @param random The RNG instance.
 * @return A double in the range [0.0, 1.0).
 */
GRIMOIRE_API double GrimoireRandom_NextDouble(GrimoireRandom random);

/**
 * @brief Fills a buffer with random bytes.
 *
 * The buffer may be of any type. This allows convenient usage such as:
 *
 * @code
 * int32_t values[16];
 * GrimoireRandom_NextBytes(random, values, sizeof(values));
 * @endcode
 *
 * @param random The RNG instance.
 * @param buffer Pointer to the buffer to fill.
 * @param length Number of bytes to write.
 */
GRIMOIRE_API void GrimoireRandom_NextBytes(GrimoireRandom random, void* buffer, size_t length);

/**
 * @brief Serializes the RNG state into a byte buffer.
 *
 * The buffer must be at least 228 bytes in size. Any buffer smaller than this
 * will result in undefined behavior. The exact layout of the serialized data is
 * implementation‑defined and may change between versions, but the required size
 * will remain constant for this release.
 *
 * @param random The RNG instance.
 * @param buffer Output buffer for serialized state (must be >= 228 bytes).
 */
GRIMOIRE_API void GrimoireRandom_Serialize(GrimoireRandom random, uint8_t* buffer);

/**
 * @brief Restores an RNG instance from serialized state.
 *
 * The input buffer must contain at least 228 bytes previously produced by
 * @ref GrimoireRandom_Serialize. Passing a buffer of insufficient size or one
 * not produced by this API results in undefined behavior.
 *
 * @param buffer The serialized state buffer (must be >= 228 bytes).
 * @return A new RNG instance restored from the serialized state, or `NULL` on failure.
 */
GRIMOIRE_API GrimoireRandom GrimoireRandom_Deserialize(const uint8_t* buffer);

GRIMOIRE_END

#endif // !GRIMOIRE_RANDOM_H