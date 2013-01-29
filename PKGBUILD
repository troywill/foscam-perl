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
md5sums=('9de16228d02cb47f43f98a31baca619f')

build() {
  cd  $srcdir/foscam-perl-$pkgver
}

package() {
  cd  $srcdir/foscam-perl-$pkgver
  install -Dm755 usr/bin/foscam-record.pl $pkgdir/usr/bin/

  find $pkgdir -name '.packlist' -delete
  find $pkgdir -name '*.pod' -delete
}
