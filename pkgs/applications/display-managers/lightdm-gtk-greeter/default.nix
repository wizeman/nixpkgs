{ stdenv, fetchurl, lightdm, pkgconfig, intltool
, useGTK2 ? true, gtk2, gtk3 # don't pull gtk3 by default
}:

let
  ver_branch = "1.6";
  version = "1.5.1"; # 1.5.2 results into infinite cycling of X in restarts
in
stdenv.mkDerivation rec {
  name = "lightdm-gtk-greeter-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.gz";
    sha256 = "08fnsbnay5jhd7ps8n91i6c227zq6xizpyn34qhqzykrga8pxkpc";
  };

  patches = [ ./lightdm-gtk-greeter.patch ];
  patchFlags = "-p0";

  buildInputs = [ pkgconfig lightdm intltool (if useGTK2 then gtk2 else gtk3) ];

  configureFlags = stdenv.lib.optional useGTK2 "--with-gtk2";

  postInstall = ''
      substituteInPlace "$out/share/xgreeters/lightdm-gtk-greeter.desktop" \
        --replace "Exec=lightdm-gtk-greeter" "Exec=$out/sbin/lightdm-gtk-greeter"
    '';

  meta = {
    homepage = http://launchpad.net/lightdm-gtk-greeter;
    platforms = stdenv.lib.platforms.linux;
  };
}
