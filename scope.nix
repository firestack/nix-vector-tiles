{ makeScope
, newScope
}:
makeScope newScope (self: {
	build_pbf_glyphs = self.callPackage ./packages/build-pbf-glyphs {};
})
