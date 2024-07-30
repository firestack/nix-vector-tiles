{ makeScope
, newScope
}:
makeScope newScope (self: {
	map-sprite-packer = self.callPackage ./packages/map-sprite-packer {};
})
