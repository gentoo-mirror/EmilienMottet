EAPI=7

DESCRIPTION="Microsoft Intune Portal"
HOMEPAGE="https://www.microsoft.com/en-us/microsoft-365/enterprise-mobility-security/microsoft-intune"
SRC_URI="file://${FILESDIR}/intune-portal.tar.gz"

LICENSE="Microsoft"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insinto /opt/intune-portal
	doins -r "${S}"/*
	dosym /opt/intune-portal/bin/intune /usr/bin/intune
}
