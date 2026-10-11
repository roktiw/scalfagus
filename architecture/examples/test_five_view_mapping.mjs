// Scalfagus ADR-0003 — dependency-free Node.js reference test.
// Run: node --test architecture/examples/test_five_view_mapping.mjs
// This validates the ANGLE MATH only; it does not test Godot import or 3D art quality.
import test from "node:test";
import assert from "node:assert/strict";

export function resolveFiveView(signedAngleDegrees) {
  if (!Number.isFinite(signedAngleDegrees)) throw new TypeError("Finite bearing required");
  // Explicitly match nearest 45° sector. Ties go away from zero.
  const steps = signedAngleDegrees / 45;
  const nearest = steps >= 0 ? Math.floor(steps + 0.5) : Math.ceil(steps - 0.5);
  const sector = ((nearest % 8) + 8) % 8;
  return { sector, sourceRow: sector <= 4 ? sector : 8 - sector, flipH: sector > 4 };
}

export function viewBearing(camera, actor, projection) {
  if (projection === "orthographic") {
    // Parallel camera rays: the view-back vector is shared for every actor.
    return [camera.backwardX, camera.backwardZ];
  }
  const x = camera.x - actor.x;
  const z = camera.z - actor.z;
  const length = Math.hypot(x, z);
  if (length === 0) return [camera.backwardX, camera.backwardZ];
  return [x / length, z / length];
}

test("eight sectors map to five source rows and three mirrors", () => {
  const rows = [0, 1, 2, 3, 4, 3, 2, 1];
  const flipped = [false, false, false, false, false, true, true, true];
  for (let sector = 0; sector < 8; sector++) {
    assert.deepEqual(resolveFiveView(sector * 45), {
      sector, sourceRow: rows[sector], flipH: flipped[sector]
    });
  }
});

test("angle wrap works in both directions", () => {
  for (const a of [0, -0.1, 0.1, 359.9, -360.1, 720, -720]) {
    assert.equal(resolveFiveView(a).sector, 0, String(a));
  }
  assert.deepEqual(resolveFiveView(-45), { sector: 7, sourceRow: 1, flipH: true });
  assert.deepEqual(resolveFiveView(-90), { sector: 6, sourceRow: 2, flipH: true });
  assert.deepEqual(resolveFiveView(-180), { sector: 4, sourceRow: 4, flipH: false });
});

test("near-sector boundary is stable unless threshold is actually crossed", () => {
  assert.equal(resolveFiveView(22.4).sector, 0);
  assert.equal(resolveFiveView(22.6).sector, 1);
  assert.equal(resolveFiveView(-22.4).sector, 0);
  assert.equal(resolveFiveView(-22.6).sector, 7);
});

test("orthographic camera shares bearing regardless of actor position", () => {
  const cam = { x: 50, z: 50, backwardX: 0, backwardZ: 1 };
  assert.deepEqual(viewBearing(cam, { x: 1, z: 1 }, "orthographic"), [0, 1]);
  assert.deepEqual(viewBearing(cam, { x: 1000, z: -1000 }, "orthographic"), [0, 1]);
});

test("perspective camera bearing differs for actors on opposite sides of camera", () => {
  const cam = { x: 0, z: 0, backwardX: 0, backwardZ: 1 };
  assert.deepEqual(viewBearing(cam, { x: 10, z: 0 }, "perspective"), [-1, 0]);
  assert.deepEqual(viewBearing(cam, { x: -10, z: 0 }, "perspective"), [1, 0]);
});

test("zero horizontal camera-to-actor vector does not yield NaN", () => {
  const cam = { x: 0, z: 0, backwardX: 0, backwardZ: 1 };
  assert.deepEqual(viewBearing(cam, { x: 0, z: 0 }, "perspective"), [0, 1]);
});
