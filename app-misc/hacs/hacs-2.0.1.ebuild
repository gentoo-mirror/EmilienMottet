# /usr/local/portage/app-misc/hacs/hacs-2.0.1.ebuild
EAPI=8

DESCRIPTION="Home Assistant Community Store (HACS)"
HOMEPAGE="https://github.com/hacs/integration"
SRC_URI="https://github.com/hacs/integration/releases/download/${PV}/hacs.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="app-misc/homeassistant-full"

src_install() {
	local ha_path="/etc/homeassistant"

	# Vérification que le répertoire Home Assistant existe
	if [ ! -d "$ha_path" ]; then
		die "Home Assistant directory ($ha_path) not found."
	fi

	# Créer le répertoire custom_components si nécessaire
	mkdir -p "${ha_path}/custom_components"

	# Télécharger et installer HACS (version 2.0.1)
	unzip -o ${DISTDIR}/hacs.zip -d "${ha_path}/custom_components/"

	# Vérification de la version de Home Assistant
	local current_version
	local target_version
	current_version=$(cat "$ha_path/.HA_VERSION" || echo "unknown")
	target_version=$(sed -n -e '/^MINIMUM_HA_VERSION/p' "${ha_path}/custom_components/hacs/const.py" | cut -d '"' -f 2)

	if [[ "$current_version" == "unknown" || "$current_version" < "$target_version" ]]; then
		ewarn "Home Assistant version ($current_version) is lower than the required minimum ($target_version)"
	fi
}

pkg_postinst() {
	einfo "HACS has been installed. Please restart Home Assistant before configuring it."
}
