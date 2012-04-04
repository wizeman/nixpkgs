{ callPackage, pkgs, isTesting }:
let
  gnome = pkgs.gnome;
in rec {

  #### DEPENDENCIES

  lib = import ../../lib;

  inherit (pkgs) gtk glib;
  inherit (gnome) libglade libwnck vte;
  inherit (pkgs.perlPackages) URI;
  inherit (pkgs) pcre;

  # The useful bits from ‘gnome-disk-utility’.
  libgdu = callPackage ./support/libgdu.nix { };

  # Gvfs is required by Thunar for the trash feature and for volume
  # mounting.  Should use the one from Gnome, but I don't want to mess
  # with the Gnome packages (or pull in a zillion Gnome dependencies).
  gvfs = callPackage ./support/gvfs.nix { };

  # intelligent fetcher for Xfce
  fetchXfce = rec {
    generic = prepend : name : hash :
      let p = builtins.parseDrvName name;
          versions = lib.splitString "." p.version;
          ver_maj = lib.concatStrings (lib.intersperse "." (lib.take 2 versions));
          name_low = lib.toLower p.name;
      in pkgs.fetchurl {
        url = "mirror://xfce/${prepend}/${name_low}/${ver_maj}/${name}.tar.bz2";
        sha256 = hash;
      };
    core = generic "xfce";
    app = generic "apps";
    art = generic "art";
  };


  #### CORE

  libxfce4util    = callPackage ./core/libxfce4util.nix
    { v= "4.8.2";   h= "05n8586h2fwkibfld5fm4ygx1w66jnbqqb3li0ardjvm2n24k885"; };
  xfconf          = callPackage ./core/xfconf.nix
    { v= "4.8.1";   h= "1jwkb73xcgqfly449jwbn2afiyx50p150z60x19bicps75sp6q4q"; };
  libxfce4ui      = callPackage ./core/libxfce4ui.nix     ( if isTesting then
    { v= "4.9.0";   h= "1zfskfzmwzq64yavnv7gcjws0v6r192y5kkykw5qdwmhpcvg8wi4"; } else
    { v= "4.8.1";   h= "0mlrcr8rqmv047xrb2dbh7f4knsppb1anx2b05s015h6v8lyvjrr"; } );
  libxfcegui4     = callPackage ./core/libxfcegui4.nix
    { v= "4.8.1";   h= "0hr4h6a9p6w3qw1976p8v9c9pwhd9zhrjlbaph0p7nyz7j1836ih"; };
  exo             = callPackage ./core/exo.nix            ( if isTesting then
    { v= "0.7.1";   h= "11is93g82gl0z489ifvilg5s5q34j7p4brfvz3pz0klgsgr6grz4"; } else
    { v= "0.6.2";   h= "0f8zh5y057l7xffskjvky6k88hrnz6jyk35mvlfpmx26anlgd77l"; } );
  garcon          = callPackage ./core/garcon.nix
    { v= "0.1.10";  h= "05hkfqirnbspr4rifnjzds7j6z5s5bvjwwfw47kc27qhj4lpljf2"; };
  xfce4panel      = callPackage ./core/xfce4-panel.nix    ( if isTesting then
    { v= "4.9.0";   h= "1f5zk5j37jzdi13wdvcl6m78x29xkvn0cl2d4gh8zcg6h22v23yn"; } else
    { v= "4.8.6";   h= "00zdkg1jg4n2n109nxan8ji2m06r9mc4lnlrvb55xvj229m2dwb6"; } );
  thunar          = callPackage ./core/thunar.nix
    { v= "1.3.0";   h= "02j3dcgk65mig3jmrg740d1swc8sbn3mkkyrca1ijvv1a955345n"; };
  xfce4settings   = callPackage ./core/xfce4-settings.nix ( if isTesting then
    { v= "4.9.2";   h= "1yz20xj6kp5mx4gfhqqa9hxls7i85h4dcqqkfkk9mlmw9vqmgl1v"; } else
    { v= "4.8.3";   h= "0bmw0s6jp2ws4n0f3387zwsyv46b0w89m6r70yb7wrqy9r3wqy6q"; } );
  xfce4session    = callPackage ./core/xfce4-session.nix
    { v= "4.8.2";   h= "1l608kik98jxbjl73waf8515hzji06lr80qmky2qlnp0b6js5g1i"; };
  xfwm4           = callPackage ./core/xfwm4.nix
    { v= "4.8.3";   h= "0zi2g1d2jdgw5armlk9xjh4ykmydy266gdba86nmhy951gm8n3hb"; };
  xfdesktop       = callPackage ./core/xfdesktop.nix
    { v= "4.8.3";   h= "097lc9djmay0jyyl42jmvcfda75ndp265nzn0aa3hv795bsn1175"; };
  xfceutils       = callPackage ./core/xfce-utils.nix
    { v= "4.8.3";   h= "09mr0amp2f632q9i3vykaa0x5nrfihfm9v5nxsx9vch8wvbp0l03"; };
  xfce4_power_manager = callPackage ./core/xfce4-power-manager.nix
    { v= "1.0.10";  h= "1w120k1sl4s459ijaxkqkba6g1p2sqrf9paljv05wj0wz12bpr40"; };

  # not used anymore
  gtk_xfce_engine = callPackage ./core/gtk-xfce-engine.nix { };

  #### APPLICATIONS

  terminal            = callPackage ./applications/terminal.nix
    { v= "0.4.8";   h= "13bqrhjkwlv4dgmbzw74didh125y2n4lvx0h3vx7xs3w2avv0pgy"; };
  mousepad            = callPackage ./applications/mousepad.nix
    { v= "0.2.16";  h= "0gp7yh8b9w3f1n2la1l8nlqm0ycf0w0qkgcyv9yd51qv9gyr7rc6"; };
  ristretto           = callPackage ./applications/ristretto.nix
    { v= "0.3.5";   h= "1wmq3s2pr3zmk9ps2lyas1m1mc22fnxvkmr7f3wma2ck5sf53p4n"; };
  xfce4mixer          = callPackage ./applications/xfce4-mixer.nix
    { v= "4.8.0";   h= "1aqgjxvck6hx26sk3n4n5avhv02vs523mfclcvjb3xnks3yli7wz"; };
  xfce4notifyd        = callPackage ./applications/xfce4-notifyd.nix
    { v= "0.2.2";   h= "0s4ilc36sl5k5mg5727rmqims1l3dy5pwg6dk93wyjqnqbgnhvmn"; };

  #TODO: correct links; more stuff
  # move power_manager to core

  xfce4_appfinder     = callPackage ./core/xfce4-appfinder.nix { };
  thunar_volman       = callPackage ./core/thunar-volman.nix { };

  #### ART

  xfce4icontheme = callPackage ./art/xfce4-icon-theme.nix
    { v= "4.4.3";   h= "1yk6rx3zr9grm4jwpjvqdkl13pisy7qn1wm5cqzmd2kbsn96cy6l"; };

}
