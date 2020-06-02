Return-Path: <martin@lichtvoll.de>
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Fio fails to build from source with gcc 10.1: multiple definition of
Date: Tue, 02 Jun 2020 15:28:11 +0200
Message-ID: <2090225.DZbHg2GNPv@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi!

=46io fails to build from source with gcc 10.1:

See:

fio: ftbfs with GCC-10

https://bugs.debian.org/957204

Build log is here:

https://people.debian.org/~doko/logs/gcc10-20200225/fio_3.16-1_unstable_gcc=
10.log

there are errors like:

gcc -Wl,-z,defs -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,-z,defs -Wl,--a=
s-needed -Wl,-z,relro -Wl,-z,now -rdynamic -o gfio crc/crc16.o crc/crc32.o =
crc/crc32c-arm64.o crc/crc32c-intel.o crc/crc32c.o crc/crc64.o crc/crc7.o c=
rc/fnv.o crc/md5.o crc/murmur3.o crc/sha1.o crc/sha256.o crc/sha3.o crc/sha=
512.o crc/test.o crc/xxhash.o lib/axmap.o lib/bloom.o lib/flist_sort.o lib/=
gauss.o lib/getrusage.o lib/hweight.o lib/ieee754.o lib/lfsr.o lib/memalign=
=2Eo lib/memcpy.o lib/mountcheck.o lib/num2str.o lib/output_buffer.o lib/pa=
ttern.o lib/prio_tree.o lib/rand.o lib/rbtree.o lib/strntol.o lib/zipf.o ge=
ttime.o ioengines.o init.o stat.o log.o time.o filesetup.o eta.o verify.o m=
emory.o io_u.o parse.o fio_sem.o rwlock.o pshared.o options.o smalloc.o fil=
ehash.o profile.o debug.o engines/cpu.o engines/mmap.o engines/sync.o engin=
es/null.o engines/net.o engines/ftruncate.o engines/filecreate.o server.o c=
lient.o iolog.o backend.o libfio.o flow.o cconv.o gettime-thread.o helpers.=
o json.o idletime.o td_error.o profiles/tiobench.o profiles/act.o io_u_queu=
e.o filelock.o workqueue.o rate-submit.o optgroup.o helper_thread.o steadys=
tate.o zone-dist.o engines/libaio.o engines/rdma.o engines/posixaio.o engin=
es/falloc.o engines/e4defrag.o engines/splice.o engines/rados.o engines/rbd=
=2Eo oslib/asprintf.o oslib/strlcat.o engines/glusterfs.o engines/glusterfs=
_sync.o engines/glusterfs_async.o engines/mtd.o oslib/libmtd.o oslib/libmtd=
_legacy.o zbd.o diskutil.o fifo.o blktrace.o cgroup.o trim.o engines/sg.o o=
slib/linux-dev-lookup.o engines/io_uring.o gfio.o graph.o tickmarks.o ghelp=
ers.o goptions.o gerror.o gclient.o gcompat.o cairo_text_helpers.o printing=
=2Eo -lgfapi -lglusterfs -lrbd -lrados -lrados -lnuma -lrdmacm -libverbs -l=
rt -laio -lz  -lm  -lpthread -ldl -lnuma -lrdmacm -libverbs -lrt -laio -lz =
 -lgtk-x11-2.0 -lgdk-x11-2.0 -lpangocairo-1.0 -latk-1.0 -lcairo -lgdk_pixbu=
f-2.0 -lgio-2.0 -lpangoft2-1.0 -lpango-1.0 -lgobject-2.0 -lfontconfig -lfre=
etype -lgthread-2.0 -pthread -lglib-2.0 =20
gcc -Wl,-z,defs -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,-z,defs -Wl,--a=
s-needed -Wl,-z,relro -Wl,-z,now -rdynamic -g -O2 -fdebug-prefix-map=3D/<<P=
KGBUILDDIR>>=3D. -fstack-protector-strong -Wformat -Werror=3Dformat-securit=
y -D_GNU_SOURCE -include config-host.h -pthread -I/usr/include/gtk-2.0 -I/u=
sr/lib/x86_64-linux-gnu/gtk-2.0/include -I/usr/include/pango-1.0 -I/usr/inc=
lude/atk-1.0 -I/usr/include/cairo -I/usr/include/pixman-1 -I/usr/include/gd=
k-pixbuf-2.0 -I/usr/include/libmount -I/usr/include/blkid -I/usr/include/pa=
ngo-1.0 -I/usr/include/harfbuzz -I/usr/include/pango-1.0 -I/usr/include/fri=
bidi -I/usr/include/uuid -I/usr/include/freetype2 -I/usr/include/libpng16 -=
I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -Wimpli=
cit-fallthrough -std=3Dgnu99 -Wwrite-strings -Wall -Wdeclaration-after-stat=
ement -g -ffast-math  -D_GNU_SOURCE -include config-host.h -pthread -I/usr/=
include/gtk-2.0 -I/usr/lib/x86_64-linux-gnu/gtk-2.0/include -I/usr/include/=
pango-1.0 -I/usr/include/atk-1.0 -I/usr/include/cairo -I/usr/include/pixman=
=2D1 -I/usr/include/gdk-pixbuf-2.0 -I/usr/include/libmount -I/usr/include/b=
lkid -I/usr/include/pango-1.0 -I/usr/include/harfbuzz -I/usr/include/pango-=
1.0 -I/usr/include/fribidi -I/usr/include/uuid -I/usr/include/freetype2 -I/=
usr/include/libpng16 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/gl=
ib-2.0/include -Wimplicit-fallthrough -I. -I. -O3 -U_FORTIFY_SOURCE -D_FORT=
IFY_SOURCE=3D2 -DBITS_PER_LONG=3D64 -DFIO_VERSION=3D'"fio-3.16"' -o t/fio-g=
enzipf t/log.o lib/ieee754.o lib/rand.o lib/pattern.o lib/zipf.o lib/strnto=
l.o lib/gauss.o t/genzipf.o oslib/strcasestr.o oslib/strndup.o -lgfapi -lgl=
usterfs -lrbd -lrados -lrados -lnuma -lrdmacm -libverbs -lrt -laio -lz  -lm=
  -lpthread -ldl
/usr/bin/ld: goptions.o:./gfio.h:81: multiple definition of `main_ui'; gfio=
=2Eo:./gfio.h:81: first defined here
/usr/bin/ld: gerror.o:./gfio.h:81: multiple definition of `main_ui'; gfio.o=
:./gfio.h:81: first defined here
/usr/bin/ld: gclient.o:./gfio.h:81: multiple definition of `main_ui'; gfio.=
o:./gfio.h:81: first defined here
/usr/bin/ld: printing.o:./gfio.h:81: multiple definition of `main_ui'; gfio=
=2Eo:./gfio.h:81: first defined here

This build log is about fio-3.16, however I tested with fio-3.20 and got
the same errors.

I would prefer this to be fixed upstream.

This is not all that urgent. There is still some time till Debian 11 aka
bullseye release. First milestone for the freeze towards bullseye is
planned for January 2021, so it would be good to have some fix within
till November 2020.

Thanks,
=2D-=20
Martin



