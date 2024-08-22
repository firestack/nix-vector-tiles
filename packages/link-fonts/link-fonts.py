# Symlinking
import os
from pathlib import Path

# Reading input files
import json


from dataclasses import dataclass

@dataclass
class FontGroup:
	path: str
	name: str

	def from_string(line: str):
		try:
			path, name = line.split(":", maxsplit=1)
			return FontGroup(path, name)
		except:
			print(list(line))
			raise

	def from_lines(lines: str):
		return [FontGroup.from_string(line) for line in lines.splitlines()]

	def symlink(self, output_directory: Path):

		out_path = Path(os.path.join(output_directory, self.name)).with_suffix(Path(self.path).suffix)
		os.symlink(os.path.realpath(self.path), out_path)


def matching_fonts(font_list: list[FontGroup], wanted_fonts: list[str]):
	for font in wanted_fonts:
		yield (font, [font_group for font_group in font_list if font_group.name == font])

def link_fonts(font_list: list[FontGroup], output_directory: Path):
	for fg in font_list:
		fg.symlink(output_directory)


if __name__ == "__main__":
	import argparse
	import sys

	parser = argparse.ArgumentParser(description="Links matching font files to directory")
	parser.add_argument("wanted_fonts")
	parser.add_argument("font_list")
	parser.add_argument("output_directory")

	args = parser.parse_args()

	output_directory: Path = Path(args.output_directory)
	font_list: str = FontGroup.from_lines(Path(args.font_list).read_text())
	wanted_fonts: str = json.load(open(args.wanted_fonts))


	font_list1: list[FontGroup] = []
	for (name, fonts) in matching_fonts(font_list, wanted_fonts):
		if len(fonts) != 1:
			print(f"No Matching Fonts! {name}:{fonts}", file=sys.stderr)
			if len(fonts) == 0:
				continue

		font_list1.append(fonts[0])

	print(f"linking to {output_directory}", file=sys.stderr)
	link_fonts(font_list1, output_directory)

	from pprint import pprint
	pprint(font_list1)
