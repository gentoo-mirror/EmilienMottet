# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Pulseaudio command line mixer."
HOMEPAGE="https://github.com/cdemoulins/pamixer"

inherit git-r3 meson
EGIT_REPO_URI="https://github.com/cdemoulins/pamixer"

RESTRICT="mirror"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/cxxopts
	media-sound/pulseaudio[alsa]"

DEPEND="${RDEPEND}"
