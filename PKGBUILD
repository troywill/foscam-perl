# Maintainer: Troy Will <troydwill@gmail.com>

pkgname=foscam-perl
pkgver=0.0.1
pkgrel=1
pkgdesc="Perl system to control and record Foscam cameras"
arch=('any')
url="http://foscam-perl.shilohsystem.com"
license=('GPL' 'PerlArtistic')
depends=('perl>=5.10.0')
options=('!emptydirs')
source=(http://packages.shilohsystem.com/foscam-perl-$pkgver.tar.gz)
md5sums=('689988a01fca07f0ec9f2ce972b9a5eb')

build() {
  cd  $srcdir/foscam-perl-$pkgver
}

package() {
  cd  $srcdir/Foscam-Perl-$pkgver
  install -Dm755 bin/foscam-record.pl $pkgdir/usr/bin/

  find $pkgdir -name '.packlist' -delete
  find $pkgdir -name '*.pod' -delete
}
