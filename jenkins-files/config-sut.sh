#! /bin/bash

name="$1"
id="$2"
arch="$3"

scripts=$(dirname $0)

virsh destroy sut-$name 2> /dev/null
virsh undefine sut-$name 2> /dev/null

script=$(printf "s/@@NAME@@/%s/; s/@@ID@@/%02d/; s/@@ARCH@@/%s/\n" $name $id $arch)
sed "$script" $scripts/config-sut.template > $WORKSPACE/wicked-sut.xml

virsh define $WORKSPACE/wicked-sut.xml
[ $? -eq 0 ] || exit $?
virsh start sut-$name
[ $? -eq 0 ] || exit $?

rm $WORKSPACE/wicked-sut.xml
