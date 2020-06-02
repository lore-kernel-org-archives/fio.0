Return-Path: <martin@lichtvoll.de>
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: Fio fails to build from source with gcc 10.1: multiple definition of
Date: Tue, 02 Jun 2020 16:56:54 +0200
Message-ID: <3082480.yLNBqAqXSp@merkaba>
In-Reply-To: <c0a8ab00-6b1d-43b9-faf3-a464d4a2d5ba@kernel.dk>
References: <2090225.DZbHg2GNPv@merkaba> <c0a8ab00-6b1d-43b9-faf3-a464d4a2d5ba@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Jens Axboe - 02.06.20, 16:20:51 CEST:
> On 6/2/20 7:28 AM, Martin Steigerwald wrote:
> 
> > Hi!
> > 
> > Fio fails to build from source with gcc 10.1:
> > 
> > See:
> > 
> > fio: ftbfs with GCC-10
> > 
> > https://bugs.debian.org/957204
> > 
> > Build log is here:
> > 
> > https://people.debian.org/~doko/logs/gcc10-20200225/fio_3.16-1_unsta
> > ble_gcc10.log
 
> > there are errors like:
> > 
> > gcc -Wl,-z,defs -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,-z,defs
> > -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -rdynamic -o gfio
> > crc/crc16.o crc/crc32.o crc/crc32c-arm64.o crc/crc32c-intel.o
> > crc/crc32c.o crc/crc64.o crc/crc7.o crc/fnv.o crc/md5.o
> > crc/murmur3.o crc/sha1.o crc/sha256.o crc/sha3.o crc/sha512.o
> > crc/test.o crc/xxhash.o lib/axmap.o lib/bloom.o lib/flist_sort.o
> > lib/gauss.o lib/getrusage.o lib/hweight.o lib/ieee754.o lib/lfsr.o
> > lib/memalign.o lib/memcpy.o lib/mountcheck.o lib/num2str.o
> > lib/output_buffer.o lib/pattern.o lib/prio_tree.o lib/rand.o
> > lib/rbtree.o lib/strntol.o lib/zipf.o gettime.o ioengines.o init.o
> > stat.o log.o time.o filesetup.o eta.o verify.o memory.o io_u.o
> > parse.o fio_sem.o rwlock.o pshared.o options.o smalloc.o filehash.o
> > profile.o debug.o engines/cpu.o engines/mmap.o engines/sync.o
> > engines/null.o engines/net.o engines/ftruncate.o
> > engines/filecreate.o server.o client.o iolog.o backend.o libfio.o
> > flow.o cconv.o gettime-thread.o helpers.o json.o idletime.o
> > td_error.o profiles/tiobench.o profiles/act.o io_u_queue.o
> > filelock.o workqueue.o rate-submit.o optgroup.o helper_thread.o
> > steadystate.o zone-dist.o engines/libaio.o engines/rdma.o
> > engines/posixaio.o engines/falloc.o engines/e4defrag.o
> > engines/splice.o engines/rados.o engines/rbd.o oslib/asprintf.o
> > oslib/strlcat.o engines/glusterfs.o engines/glusterfs_sync.o
> > engines/glusterfs_async.o engines/mtd.o oslib/libmtd.o
> > oslib/libmtd_legacy.o zbd.o diskutil.o fifo.o blktrace.o cgroup.o
> > trim.o engines/sg.o oslib/linux-dev-lookup.o engines/io_uring.o
> > gfio.o graph.o tickmarks.o ghelpers.o goptions.o gerror.o gclient.o
> > gcompat.o cairo_text_helpers.o printing.o -lgfapi -lglusterfs -lrbd
> > -lrados -lrados -lnuma -lrdmacm -libverbs -lrt -laio -lz  -lm 
> > -lpthread -ldl -lnuma -lrdmacm -libverbs -lrt -laio -lz 
> > -lgtk-x11-2.0 -lgdk-x11-2.0 -lpangocairo-1.0 -latk-1.0 -lcairo
> > -lgdk_pixbuf-2.0 -lgio-2.0 -lpangoft2-1.0 -lpango-1.0 -lgobject-2.0
> > -lfontconfig -lfreetype -lgthread-2.0 -pthread -lglib-2.0  
 gcc
> > -Wl,-z,defs -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,-z,defs
> > -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -rdynamic -g -O2
> > -fdebug-prefix-map=/<<PKGBUILDDIR>>=. -fstack-protector-strong
> > -Wformat -Werror=format-security -D_GNU_SOURCE -include
> > config-host.h -pthread -I/usr/include/gtk-2.0
> > -I/usr/lib/x86_64-linux-gnu/gtk-2.0/include
> > -I/usr/include/pango-1.0 -I/usr/include/atk-1.0
> > -I/usr/include/cairo -I/usr/include/pixman-1
> > -I/usr/include/gdk-pixbuf-2.0 -I/usr/include/libmount
> > -I/usr/include/blkid -I/usr/include/pango-1.0
> > -I/usr/include/harfbuzz -I/usr/include/pango-1.0
> > -I/usr/include/fribidi -I/usr/include/uuid -I/usr/include/freetype2
> > -I/usr/include/libpng16 -I/usr/include/glib-2.0
> > -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -Wimplicit-fallthrough
> > -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement -g
> > -ffast-math  -D_GNU_SOURCE -include config-host.h -pthread
> > -I/usr/include/gtk-2.0 -I/usr/lib/x86_64-linux-gnu/gtk-2.0/include
> > -I/usr/include/pango-1.0 -I/usr/include/atk-1.0
> > -I/usr/include/cairo -I/usr/include/pixman-1
> > -I/usr/include/gdk-pixbuf-2.0 -I/usr/include/libmount
> > -I/usr/include/blkid -I/usr/include/pango-1.0
> > -I/usr/include/harfbuzz -I/usr/include/pango-1.0
> > -I/usr/include/fribidi -I/usr/include/uuid -I/usr/include/freetype2
> > -I/usr/include/libpng16 -I/usr/include/glib-2.0
> > -I/usr/lib/x86_64-linux-gnu/glib-2.0/include -Wimplicit-fallthrough
> > -I. -I. -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
> > -DBITS_PER_LONG=64 -DFIO_VERSION='"fio-3.16"' -o t/fio-genzipf
> > t/log.o lib/ieee754.o lib/rand.o lib/pattern.o lib/zipf.o
> > lib/strntol.o lib/gauss.o t/genzipf.o oslib/strcasestr.o
> > oslib/strndup.o -lgfapi -lglusterfs -lrbd -lrados -lrados -lnuma
> > -lrdmacm -libverbs -lrt -laio -lz  -lm  -lpthread -ldl /usr/bin/ld:
> > goptions.o:./gfio.h:81: multiple definition of `main_ui';
> > gfio.o:./gfio.h:81: first defined here /usr/bin/ld:
> > gerror.o:./gfio.h:81: multiple definition of `main_ui';
> > gfio.o:./gfio.h:81: first defined here /usr/bin/ld:
> > gclient.o:./gfio.h:81: multiple definition of `main_ui';
> > gfio.o:./gfio.h:81: first defined here /usr/bin/ld:
> > printing.o:./gfio.h:81: multiple definition of `main_ui';
> > gfio.o:./gfio.h:81: first defined here 
> > This build log is about fio-3.16, however I tested with fio-3.20 and
> > got the same errors.
> > 
> > I would prefer this to be fixed upstream.
> 
> 
> I pushed a trivial fix for this.

Thank you.

-- 
Martin



