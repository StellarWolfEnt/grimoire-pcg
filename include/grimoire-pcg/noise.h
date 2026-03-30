/**
 * @file noise.h
 * @brief Noise generation functions and fractal settings.
 *
 * Provides 1D, 2D, and 3D value and Perlin noise functions, plus fractal and billow noise
 * combiners. Uses a deterministic seed for reproducible patterns
 *
 * @author Stellar Wolf
 * @version 1.0.0
 * @date 2026-03-01
 */
#ifndef GRIMOIRE_NOISE_H
#define GRIMOIRE_NOISE_H

#include "common.h"

GRIMOIRE_BEGIN

/**
 * @struct GrimoireFractalSettings
 * @brief Parameters controlling fractal noise generation.
 *
 * Defines how multiple octaves of a base noise function are combined to produce
 * fractal patterns such as fBm or billow noise.
 */
typedef struct GrimoireFractalSettings
{
    float frequency;   //< Starting frequency of the first layer.
    uint32_t octaves;  //< Number of layers to generate and combine.
    float lacunarity;  //< How much the frequency increases per layer.
    float persistence; //< How much the amplitude decreases per layer.
    bool staticSeed;   //< If true, every layer uses the same seed; if false, each layer uses seed + layerIndex.
} GrimoireFractalSettings;

/**
 * @typedef GrimoireNoiseFunction
 * @brief Function pointer type for noise generation functions.
 *
 * Allows flexible use of different noise algorithms in a consistent manner.
 *
 * @param x X-coordinate.
 * @param y Y-coordinate.
 * @param z Z-coordinate.
 * @param seed Deterministic seed value.
 * @return Noise value, typically [0.0, 1.0].
 */
typedef float (*GrimoireNoiseFunction)(float x, float y, float z, hash_t seed);

/* Value Noise (Sharp) ---------------------------------------------------------------------------------------------- */

/**
 * @brief Computes 1D sharp value noise.
 *
 * Produces a noise pattern with abrupt transitions between values. Use this for procedural
 * generation scenarios where blocky or pixelated patterns are desired.
 *
 * @param x X-coordinate for evaluation.
 * @param y Y-coordinate (ignored in 1D).
 * @param z Z-coordinate (ignored in 1D).
 * @param seed Deterministic seed for reproducible noise.
 * @return Noise value in [0.0, 1.0] with sharp transitions.
 */
GRIMOIRE_API float Grimoire_ValueSharp1D(float x, float y, float z, hash_t seed);

/**
 * @brief Computes 2D sharp value noise.
 *
 * Produces a noise pattern with abrupt transitions in two dimensions. Ideal for grid-like or
 * tile-based procedural textures with blocky features.
 *
 * @param x X-coordinate for evaluation.
 * @param y Y-coordinate for evaluation.
 * @param z Z-coordinate (ignored in 2D).
 * @param seed Deterministic seed for reproducible noise.
 * @return Noise value in [0.0, 1.0] with sharp transitions.
 */
GRIMOIRE_API float Grimoire_ValueSharp2D(float x, float y, float z, hash_t seed);

/**
 * @brief Computes 3D sharp value noise.
 *
 * Produces a noise pattern with abrupt transitions in three dimensions. Useful for voxel-based
 * procedural content or volumetric patterns with blocky detail.
 *
 * @param x X-coordinate for evaluation.
 * @param y Y-coordinate for evaluation.
 * @param z Z-coordinate for evaluation.
 * @param seed Deterministic seed for reproducible noise.
 * @return Noise value in [0.0, 1.0] with sharp transitions.
 */
GRIMOIRE_API float Grimoire_ValueSharp3D(float x, float y, float z, hash_t seed);

/* Value Noise (Smooth) --------------------------------------------------------------------------------------------- */

/**
 * @brief Computes 1D smooth value noise.
 *
 * Produces smoothly interpolated noise in one dimension. Use this for continuous gradients or
 * procedural curves.
 *
 * @param x X-coordinate for evaluation.
 * @param y Y-coordinate (ignored in 1D).
 * @param z Z-coordinate (ignored in 1D).
 * @param seed Deterministic seed for reproducible noise.
 * @return Noise value in [0.0, 1.0] with smooth transitions.
 */
GRIMOIRE_API float Grimoire_ValueSmooth1D(float x, float y, float z, hash_t seed);

/**
 * @brief Computes 2D smooth value noise.
 *
 * Produces smoothly interpolated noise in two dimensions. Ideal for terrain heightmaps,
 * textures, or any application needing continuous 2D noise.
 *
 * @param x X-coordinate for evaluation.
 * @param y Y-coordinate for evaluation.
 * @param z Z-coordinate (ignored in 2D).
 * @param seed Deterministic seed for reproducible noise.
 * @return Noise value in [0.0, 1.0] with smooth transitions.
 */
GRIMOIRE_API float Grimoire_ValueSmooth2D(float x, float y, float z, hash_t seed);

/**
 * @brief Computes 3D smooth value noise.
 *
 * Produces smoothly interpolated noise in three dimensions. Useful for volumetric effects,
 * fluid simulations, or 3D procedural content where smooth gradients are required.
 *
 * @param x X-coordinate for evaluation.
 * @param y Y-coordinate for evaluation.
 * @param z Z-coordinate for evaluation.
 * @param seed Deterministic seed for reproducible noise.
 * @return Noise value in [0.0, 1.0] with smooth transitions.
 */
GRIMOIRE_API float Grimoire_ValueSmooth3D(float x, float y, float z, hash_t seed);

/* Perlin Noise ----------------------------------------------------------------------------------------------------- */

/**
 * @brief Computes 1D Perlin noise.
 *
 * Produces smooth gradient noise in one dimension with continuous transitions, suitable for
 * natural procedural patterns like clouds, terrain curves, or animated sequences.
 *
 * @param x X-coordinate for evaluation.
 * @param y Y-coordinate (ignored in 1D).
 * @param z Z-coordinate (ignored in 1D).
 * @param seed Deterministic seed for reproducible noise.
 * @return Perlin noise value in [0.0, 1.0].
 */
GRIMOIRE_API float Grimoire_Perlin1D(float x, float y, float z, hash_t seed);

/**
 * @brief Computes 2D Perlin noise.
 *
 * Produces smooth gradient noise in two dimensions. Useful for terrain, textures, or procedural
 * 2D maps where natural variation is needed.
 *
 * @param x X-coordinate for evaluation.
 * @param y Y-coordinate for evaluation.
 * @param z Z-coordinate (ignored in 2D).
 * @param seed Deterministic seed for reproducible noise.
 * @return Perlin noise value in [0.0, 1.0].
 */
GRIMOIRE_API float Grimoire_Perlin2D(float x, float y, float z, hash_t seed);

/**
 * @brief Computes 3D Perlin noise.
 *
 * Produces smooth gradient noise in three dimensions. Useful for volumetric textures, 3D terrain
 * generation, or fluid simulations requiring smooth gradients.
 *
 * @param x X-coordinate for evaluation.
 * @param y Y-coordinate for evaluation.
 * @param z Z-coordinate for evaluation.
 * @param seed Deterministic seed for reproducible noise.
 * @return Perlin noise value in [0.0, 1.0].
 */
GRIMOIRE_API float Grimoire_Perlin3D(float x, float y, float z, hash_t seed);

/* Fractal Noise ---------------------------------------------------------------------------------------------------- */

/**
 * @brief Computes fractal noise from multiple octaves of a base noise function.
 *
 * Combines several layers of a base noise function according to the
 * parameters in `GrimoireFractalSettings`.
 *
 * @param noiseFunc Base noise function.
 * @param x X-coordinate for evaluation.
 * @param y Y-coordinate for evaluation.
 * @param z Z-coordinate for evaluation.
 * @param seed Deterministic seed for reproducible noise.
 * @param settings Pointer to fractal noise parameters.
 * @return Fractal noise value in the same output range as the base noise function, typically [0.0, 1.0].
 */
GRIMOIRE_API float Grimoire_Fbm(GrimoireNoiseFunction noiseFunc, float x, float y, float z, hash_t seed,
                                const GrimoireFractalSettings* settings);

/**
 * @brief Computes billow noise (fractal noise with absolute value applied per octave).
 *
 * Creates a soft, cloud-like appearance by applying absolute value to each octave’s noise
 * contribution.
 *
 * @param noiseFunc Base noise function.
 * @param x X-coordinate for evaluation.
 * @param y Y-coordinate for evaluation.
 * @param z Z-coordinate for evaluation.
 * @param seed Deterministic seed for reproducible noise.
 * @param settings Pointer to billow noise parameters.
 * @return Billow noise value in the same output range as the base noise function, typically [0.0, 1.0].
 */
GRIMOIRE_API float Grimoire_Billow(GrimoireNoiseFunction noiseFunc, float x, float y, float z, hash_t seed,
                                   const GrimoireFractalSettings* settings);

GRIMOIRE_END

#endif // GRIMOIRE_NOISE_H