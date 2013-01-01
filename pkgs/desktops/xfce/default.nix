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

  libxfce4util    = callPackage ./core/libxfce4util.nix   ( if isTesting then
    { v= "4.10.0";  h= "13k0wwbbqvdmbj4xmk4nxdlgvrdgr5y6r3dk380mzfw053hzwy89"; } else
    { v= "4.8.2";   h= "05n8586h2fwkibfld5fm4ygx1w66jnbqqb3li0ardjvm2n24k885"; } );
  xfconf          = callPackage ./core/xfconf.nix         ( if isTesting then
    { v= "4.10.0";  h= "0xh520z0qh0ib0ijgnyrgii9h5d4pc53n6mx1chhyzfc86j1jlhp"; } else
    { v= "4.8.1";   h= "1jwkb73xcgqfly449jwbn2afiyx50p150z60x19bicps75sp6q4q"; } );
  libxfce4ui      = callPackage ./core/libxfce4ui.nix     ( if isTesting then
    { v= "4.10.0";  h= "1qm31s6568cz4c8rl9fsfq0xmf7pldxm0ki62gx1cpybihlgmfd2"; } else
    { v= "4.8.1";   h= "0mlrcr8rqmv047xrb2dbh7f4knsppb1anx2b05s015h6v8lyvjrr"; } );
  libxfcegui4     = callPackage ./core/libxfcegui4.nix    ( if isTesting then
    { v= "4.10.0";  h= "0cs5im0ib0cmr1lhr5765yliqjfyxvk4kwy8h1l8bn3mj6bzk0ib"; } else
    { v= "4.8.1";   h= "0hr4h6a9p6w3qw1976p8v9c9pwhd9zhrjlbaph0p7nyz7j1836ih"; } );
  exo             = callPackage ./core/exo.nix            ( if isTesting then
    { v= "0.8.0";   h= "1c05pbagw14djv5zmqg34qfj40jav8sd10w2zi2wpzrad4qal8bf"; } else
    { v= "0.6.2";   h= "0f8zh5y057l7xffskjvky6k88hrnz6jyk35mvlfpmx26anlgd77l"; } );
  garcon          = callPackage ./core/garcon.nix
    { v= "0.2.0";   h= "0v7pkvxcayi86z4f173z5l7w270f3g369sa88z59w0y0p7ns7ph2"; }; # testing
  xfce4panel      = callPackage ./core/xfce4-panel.nix    ( if isTesting then
    { v= "4.10.0";  h= "1f8903nx6ivzircl8d8s9zna4vjgfy0qhjk5d2x19g9bmycgj89k"; } else
    { v= "4.8.6";   h= "00zdkg1jg4n2n109nxan8ji2m06r9mc4lnlrvb55xvj229m2dwb6"; } );
  thunar          = callPackage ./core/thunar.nix         ( if isTesting then
    { v= "1.4.0";   h= "1fn8wjzkfvnx2giv3rrg2cyrr2c96f9mskgvcji0ixyfcjga249c"; } else
    { v= "1.2.3";   h= "19mczys6xr683r68g3s2njrrmnk1p73zypvwrhajw859c6nsjsp6"; } );
  xfce4settings   = callPackage ./core/xfce4-settings.nix ( if isTesting then
    { v= "4.10.0";  h= "0zppq747z9lrxyv5zrrvpalq7hb3gfhy9p7qbldisgv7m6dz0hq8"; } else
    { v= "4.8.3";   h= "0bmw0s6jp2ws4n0f3387zwsyv46b0w89m6r70yb7wrqy9r3wqy6q"; } );
  xfce4session    = callPackage ./core/xfce4-session.nix  /*/( if isTesting then
      #TODO: some hardcoded problem: trying to create /usr/share/xsessions when installing
    { v= "4.10.0";  h= "1kj65jkjhd0ysf0yxsf88wzpyv6n8i8qgd3gb502hf1x9jksk2mv"; } else # /**/
    { v= "4.8.2";   h= "1l608kik98jxbjl73waf8515hzji06lr80qmky2qlnp0b6js5g1i"; } /*)*/;
  xfwm4           = callPackage ./core/xfwm4.nix          ( if isTesting then
    { v= "4.10.0";  h= "170zzs7adj47srsi2cl723w9pl8k8awd7w1bpzxby7hj92zmf8s9"; } else
    { v= "4.8.3";   h= "0zi2g1d2jdgw5armlk9xjh4ykmydy266gdba86nmhy951gm8n3hb"; } );
  xfdesktop       = callPackage ./core/xfdesktop.nix      ( if isTesting then
    { v= "4.10.0";  h= "0yrddj1lgk3xn4w340y89z7x2isks72ia36pka08kk2x8gpfcyl9"; } else
    { v= "4.8.3";   h= "097lc9djmay0jyyl42jmvcfda75ndp265nzn0aa3hv795bsn1175"; } );
  xfceutils       = if isTesting then null else callPackage ./core/xfce-utils.nix
    { v= "4.8.3";   h= "09mr0amp2f632q9i3vykaa0x5nrfihfm9v5nxsx9vch8wvbp0l03"; };
  xfce4_power_manager = callPackage ./core/xfce4-power-manager.nix
    { v= "1.0.10";  h= "1w120k1sl4s459ijaxkqkba6g1p2sqrf9paljv05wj0wz12bpr40"; };

  # not used anymore TODO: really? Update to 2.99.2?
  gtk_xfce_engine = callPackage ./core/gtk-xfce-engine.nix { };

  #### APPLICATIONS

  terminal            = callPackage ./applications/terminal.nix
    { v= "0.4.8";   h= "13bqrhjkwlv4dgmbzw74didh125y2n4lvx0h3vx7xs3w2avv0pgy"; };
  mousepad            = if isTesting then null else callPackage ./applications/mousepad.nix
      #TODO: broken in testing ATM
    { v= "0.2.16";  h= "0gp7yh8b9w3f1n2la1l8nlqm0ycf0w0qkgcyv9yd51qv9gyr7rc6"; };
  ristretto           = callPackage ./applications/ristretto.nix
    { v= "0.6.0";   h= "0a8ck4lvfy6qz84bxvbwrg7zb0y939fcv3s5iv2z9ry61w5hv0gs"; };
  xfce4mixer          = callPackage ./applications/xfce4-mixer.nix
    { v= "4.8.0";   h= "1aqgjxvck6hx26sk3n4n5avhv02vs523mfclcvjb3xnks3yli7wz"; };
  xfce4notifyd        = callPackage ./applications/xfce4-notifyd.nix
    { v= "0.2.2";   h= "0s4ilc36sl5k5mg5727rmqims1l3dy5pwg6dk93wyjqnqbgnhvmn"; };

  #TODO: correct links; more stuff
  # move power_manager to core

  xfce4_appfinder = callPackage ./core/xfce4-appfinder.nix  ( if isTesting then
    { v= "4.9.4";   h= "12lgrbd1n50w9n8xkpai98s2aw8vmjasrgypc57sp0x0qafsqaxq"; } else
    { v= "4.8.0";   h= "0zy7i9x4qjchmyb8nfpb7m2ply5n2aq35p9wrhb8lpz4am1ihx7x"; } );
  thunar_volman       = callPackage ./core/thunar-volman.nix { };

  #### ART

  xfce4icontheme = callPackage ./art/xfce4-icon-theme.nix
    { v= "4.4.3";   h= "1yk6rx3zr9grm4jwpjvqdkl13pisy7qn1wm5cqzmd2kbsn96cy6l"; };

}
