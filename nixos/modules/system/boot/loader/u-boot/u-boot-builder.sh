#! @bash@/bin/sh -eu

set -o pipefail
shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done

target=/boot

copyForced() {
    local src="$1"
    local dst="$2"
    cp $src $dst.tmp
    mv $dst.tmp $dst
}

copyForced @package@/u-boot.bin $target/u-boot.bin

if test -n "@firmware@"; then
  fwdir=@firmware@/share/raspberrypi/boot/

  copyForced $fwdir/bootcode.bin  $target/bootcode.bin
  copyForced $fwdir/fixup.dat     $target/fixup.dat
  copyForced $fwdir/fixup_cd.dat  $target/fixup_cd.dat
  copyForced $fwdir/fixup_db.dat  $target/fixup_db.dat
  copyForced $fwdir/start.elf     $target/start.elf
  copyForced $fwdir/start_cd.elf  $target/start_cd.elf
  copyForced $fwdir/start_db.elf  $target/start_db.elf
  copyForced $fwdir/start_x.elf   $target/start_x.elf
fi
