# Live Task Manifest

## Done

- `v0.9_EscCaps` remains the locked QA-passed baseline at commit
  `da7247c5b1268d769ba1a4135c4c09ea101e4652`; archived keymap SHA-256:
  `abbbf227ae1ffcb1d164775673fd1bfe2338b07c6b7ebf01e1f686838091a187`.
- v0.19 hardware QC failed. Do not reuse or promote its UF2.
- A v0.20 per-key QC checklist and release record exist under
  `JIGS/QC-IN_PROGRESS/`; v0.20 is not the active implementation candidate.
- The active successor is
  `JIGS/QC-IN_PROGRESS/v0.21-symbol-tap-dances.keymap`, SHA-256
  `4b279b96cfce91cb9f7de62d774dbad113f64de1b3e7b4070fbc658b7efa8f05`.
  It defines Layer 2 `J`, `K`, and `L` tap dances: single `(`/`{`/`[`,
  double `)`/`}`/`]`, and triple `()`/`{}`/`[]`.
- v0.21 built successfully in an isolated Windows workspace. Its UF2 SHA-256
  is `38b513b01651983f6f424d6e83b02e50d32a9672d37116ea4ac788352fa56b7a`.
- No ZMK core firmware, shared DTS behavior source, board, shield, or build
  configuration changed for v0.20 or v0.21.

## In progress

- Obtain the required post-fix independent review of the v0.21 hash, then run
  its hardware checklist in order. The existing UF2 is build evidence only.

## Remaining

- Do not use Docker for B1 Pro builds. Do not modify source, toolchain,
  board, shield, or candidate after recording its approved hash.
- Interns may create the verified UF2, update the packaged checklist, and
  record an explicitly preliminary smoke-test result. Only the formal testing
  authority may declare QC passed, fill formal Pass cells, or promote QC-PASS.
- Do not flash v0.21 until the post-fix review passes. Do not promote until
  explicit hardware QC passes.
