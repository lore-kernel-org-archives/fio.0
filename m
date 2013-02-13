Return-Path: <fio-owner@vger.kernel.org>
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:42122 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752304Ab3BMBM7 (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 12 Feb 2013 20:12:59 -0500
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Wed, 13 Feb 2013 12:12:40 +1100
Message-ID: <511AE888.3060005@cse.unsw.edu.au>
MIME-Version: 1.0
Subject: Re: problem FIO compiling for Android
References: <CACTzACVkfEmHrCTJExxOpPqD7tZLMbmW7n3pJza-g87sZaaK1g@mail.gmail.com> <CACTzACUwtE+aoHy72dAvgcx8zby5DYwYZzhoJfOyTCj5ABCGgg@mail.gmail.com> <20130211172550.GU21269@kernel.dk> <5119A093.2030409@cse.unsw.edu.au> <CACTzACVH_QOWjKDMBGA9YNa-p1tkCN++OPShr=G3Dfgiy4ivxA@mail.gmail.com> <5119D9FE.8060403@cse.unsw.edu.au> <CACTzACUbDZ6kNnYTeS_Ggj82SjwbNj5VK1it+YjqRRVzh+dsng@mail.gmail.com> <5119E0D0.8060704@cse.unsw.edu.au> <CACTzACXzSH_H5u7F-mL2L3iE19ZAJ2b84i_kAuYnJDDzP6J1oA@mail.gmail.com> <5119E47F.6040602@cse.unsw.edu.au> <CACTzACXfS_CDhXi7pa+aQXNHuBp7TC=UVDY=yrtXub9d9R8t7g@mail.gmail.com>
In-Reply-To: <CACTzACXfS_CDhXi7pa+aQXNHuBp7TC=UVDY=yrtXub9d9R8t7g@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David N <android.wm.edu@gmail.com>
Cc: fio@vger.kernel.org

David,

You might want to try updating to git tip and try again.

git pull
make clean
make UNAME=3DAndroid=20
cross_prefix=3D~/dev/android-toolchain-r8c/bin/arm-linux-androideabi-

works for me.

Jens: what's the right way to propagate $targetos from configure to Makefil=
e?


       -- Aaron


On 12/02/13 17:55, David N wrote:
> I seem to get the same with or without the prefix:
>
> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make cle=
an
> rm -f .depend gettime.o fio.o ioengines.o init.o stat.o log.o time.o
> filesetup.o eta.o verify.o memory.o io_u.o parse.o mutex.o options.o
> rbtree.o smalloc.o filehash.o profile.o debug.o lib/rand.o
> lib/num2str.o lib/ieee754.o crc/crc16.o crc/crc32.o crc/crc32c.o
> crc/crc32c-intel.o crc/crc64.o crc/crc7.o crc/md5.o crc/sha1.o
> crc/sha256.o crc/sha512.o engines/cpu.o engines/mmap.o engines/sync.o
> engines/null.o engines/net.o memalign.o server.o client.o iolog.o
> backend.o libfio.o flow.o json.o lib/zipf.o lib/axmap.o lib/lfsr.o
> gettime-thread.o diskutil.o fifo.o blktrace.o helpers.o cgroup.o
> trim.o engines/libaio.o engines/posixaio.o engines/sg.o
> engines/splice.o engines/syslet-rw.o engines/guasi.o engines/binject.o
> engines/rdma.o profiles/tiobench.o engines/fusion-aw.o
> engines/falloc.o engines/e4defrag.o t/stest.o gettime.o mutex.o
> smalloc.o t/log.o t/ieee754.o lib/ieee754.o t/log.o lib/ieee754.o
> lib/rand.o lib/zipf.o t/genzipf.o t/axmap.o lib/lfsr.o lib/axmap.o fio
> t/stest t/ieee754 t/genzipf t/axmap core.* core FIO-VERSION-FILE
> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make
> V=3D1 cross_prefix=3D~/development/android/prebuilts/gcc/linux-x86/arm/ar=
m-linux-androideabi-4.7/bin/arm-linux-androideabi-gcc
> UNAME=3DAndroid
> build android
> FIO_VERSION =3D fio-2.0.13
> build android
> gcc -MM -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG gettime.c
> fio.c ioengines.c init.c stat.c log.c time.c filesetup.c eta.c
> verify.c memory.c io_u.c parse.c mutex.c options.c rbtree.c smalloc.c
> filehash.c profile.c debug.c lib/rand.c lib/num2str.c lib/ieee754.c
> crc/crc16.c crc/crc32.c crc/crc32c.c crc/crc32c-intel.c crc/crc64.c
> crc/crc7.c crc/md5.c crc/sha1.c crc/sha256.c crc/sha512.c
> engines/cpu.c engines/mmap.c engines/sync.c engines/null.c
> engines/net.c memalign.c server.c client.c iolog.c backend.c libfio.c
> flow.c json.c lib/zipf.c lib/axmap.c lib/lfsr.c gettime-thread.c
> diskutil.c fifo.c blktrace.c trim.c profiles/tiobench.c 1> .depend
> gcc -o gettime.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG gettime.c
> gcc -o fio.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG fio.c
> gcc -o ioengines.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG ioengines.c
> gcc -o init.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG -c init.c
> gcc -o stat.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG stat.c
> gcc -o log.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG log.c
> gcc -o time.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG time.c
> gcc -o filesetup.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG filesetup.c
> gcc -o eta.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG eta.c
> gcc -o verify.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG verify.c
> gcc -o memory.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG memory.c
> gcc -o io_u.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG io_u.c
> gcc -o parse.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG parse.c
> gcc -o mutex.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG mutex.c
> gcc -o options.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG options.c
> gcc -o rbtree.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG rbtree.c
> gcc -o smalloc.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG smalloc.c
> gcc -o filehash.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG filehash.c
> gcc -o profile.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG profile.c
> gcc -o debug.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG debug.c
> gcc -o lib/rand.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG lib/rand.c
> gcc -o lib/num2str.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG lib/num2str.c
> gcc -o lib/ieee754.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG lib/ieee754.c
> gcc -o crc/crc16.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG crc/crc16.c
> gcc -o crc/crc32.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG crc/crc32.c
> gcc -o crc/crc32c.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG crc/crc32c.c
> gcc -o crc/crc32c-intel.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG crc/crc32c-intel.c
> gcc -o crc/crc64.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG crc/crc64.c
> gcc -o crc/crc7.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG crc/crc7.c
> gcc -o crc/md5.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG crc/md5.c
> gcc -o crc/sha1.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG crc/sha1.c
> gcc -o crc/sha256.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG crc/sha256.c
> gcc -o crc/sha512.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG crc/sha512.c
> gcc -o engines/cpu.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG engines/cpu.c
> gcc -o engines/mmap.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG engines/mmap.c
> gcc -o engines/sync.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG engines/sync.c
> gcc -o engines/null.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG engines/null.c
> gcc -o engines/net.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG engines/net.c
> gcc -o memalign.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG memalign.c
> gcc -o server.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG server.c
> gcc -o client.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG client.c
> gcc -o iolog.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG iolog.c
> gcc -o backend.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG backend.c
> gcc -o libfio.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG libfio.c
> gcc -o flow.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG flow.c
> gcc -o json.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG json.c
> gcc -o lib/zipf.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG lib/zipf.c
> gcc -o lib/axmap.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG lib/axmap.c
> gcc -o lib/lfsr.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG lib/lfsr.c
> gcc -o gettime-thread.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG gettime-thread.c
> gcc -o diskutil.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG diskutil.c
> gcc -o fifo.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG fifo.c
> gcc -o blktrace.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG blktrace.c
> gcc -o trim.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG trim.c
> gcc -o profiles/tiobench.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
> -DFIO_INC_DEBUG profiles/tiobench.c
> gcc -rdynamic -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
> -DFIO_VERSION=3D'"fio-2.0.13"' -o fio gettime.o fio.o ioengines.o init.o
> stat.o log.o time.o filesetup.o eta.o verify.o memory.o io_u.o parse.o
> mutex.o options.o rbtree.o smalloc.o filehash.o profile.o debug.o
> lib/rand.o lib/num2str.o lib/ieee754.o crc/crc16.o crc/crc32.o
> crc/crc32c.o crc/crc32c-intel.o crc/crc64.o crc/crc7.o crc/md5.o
> crc/sha1.o crc/sha256.o crc/sha512.o engines/cpu.o engines/mmap.o
> engines/sync.o engines/null.o engines/net.o memalign.o server.o
> client.o iolog.o backend.o libfio.o flow.o json.o lib/zipf.o
> lib/axmap.o lib/lfsr.o gettime-thread.o diskutil.o fifo.o blktrace.o
> trim.o profiles/tiobench.o -lm  -ldl -lpthread -lrt -ldl -rdynamic
> backend.o: In function `thread_main':
> /home/david/development/android/external/fio-2.0.13/backend.c:1299:
> undefined reference to `cgroup_shutdown'
> /home/david/development/android/external/fio-2.0.13/backend.c:1142:
> undefined reference to `cgroup_setup'
> backend.o: In function `fio_backend':
> /home/david/development/android/external/fio-2.0.13/backend.c:1794:
> undefined reference to `cgroup_kill'
> collect2: ld returned 1 exit status
> make: *** [fio] Error 1
> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$
>
>
> On Tue, Feb 12, 2013 at 1:43 AM, Aaron Carroll <aaronc@cse.unsw.edu.au> w=
rote:
>> On 12/02/13 5:34 PM, David N wrote:
>>> Here's the output, Aaron. Still the same. Than you!!!
>>>
>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make c=
lean
>>> rm -f .depend gettime.o fio.o ioengines.o init.o stat.o log.o time.o
>>> filesetup.o eta.o verify.o memory.o io_u.o parse.o mutex.o options.o
>>> rbtree.o smalloc.o filehash.o profile.o debug.o lib/rand.o
>>> lib/num2str.o lib/ieee754.o crc/crc16.o crc/crc32.o crc/crc32c.o
>>> crc/crc32c-intel.o crc/crc64.o crc/crc7.o crc/md5.o crc/sha1.o
>>> crc/sha256.o crc/sha512.o engines/cpu.o engines/mmap.o engines/sync.o
>>> engines/null.o engines/net.o memalign.o server.o client.o iolog.o
>>> backend.o libfio.o flow.o json.o lib/zipf.o lib/axmap.o lib/lfsr.o
>>> gettime-thread.o diskutil.o fifo.o blktrace.o helpers.o cgroup.o
>>> trim.o engines/libaio.o engines/posixaio.o engines/sg.o
>>> engines/splice.o engines/syslet-rw.o engines/guasi.o engines/binject.o
>>> engines/rdma.o profiles/tiobench.o engines/fusion-aw.o
>>> engines/falloc.o engines/e4defrag.o t/stest.o gettime.o mutex.o
>>> smalloc.o t/log.o t/ieee754.o lib/ieee754.o t/log.o lib/ieee754.o
>>> lib/rand.o lib/zipf.o t/genzipf.o t/axmap.o lib/lfsr.o lib/axmap.o fio
>>> t/stest t/ieee754 t/genzipf t/axmap core.* core FIO-VERSION-FILE
>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$
>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$
>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$
>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ make
>>> V=3D1 UNAME=3DAndroid
>>
>> David,
>>
>> You missed the cross_prefix part.  That also explains why you had to add
>> -lpthread: you're using half the x86 build system and half Android.
>>
>>      -- Aaron
>>
>>
>>
>>
>>> build android
>>> FIO_VERSION =3D fio-2.0.13
>>> build android
>>> gcc -MM -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG gettime.c
>>> fio.c ioengines.c init.c stat.c log.c time.c filesetup.c eta.c
>>> verify.c memory.c io_u.c parse.c mutex.c options.c rbtree.c smalloc.c
>>> filehash.c profile.c debug.c lib/rand.c lib/num2str.c lib/ieee754.c
>>> crc/crc16.c crc/crc32.c crc/crc32c.c crc/crc32c-intel.c crc/crc64.c
>>> crc/crc7.c crc/md5.c crc/sha1.c crc/sha256.c crc/sha512.c
>>> engines/cpu.c engines/mmap.c engines/sync.c engines/null.c
>>> engines/net.c memalign.c server.c client.c iolog.c backend.c libfio.c
>>> flow.c json.c lib/zipf.c lib/axmap.c lib/lfsr.c gettime-thread.c
>>> diskutil.c fifo.c blktrace.c trim.c profiles/tiobench.c 1> .depend
>>> gcc -o gettime.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG gettime.c
>>> gcc -o fio.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG fio.c
>>> gcc -o ioengines.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG ioengines.c
>>> gcc -o init.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG -c init.c
>>> gcc -o stat.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG stat.c
>>> gcc -o log.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG log.c
>>> gcc -o time.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG time.c
>>> gcc -o filesetup.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG filesetup.c
>>> gcc -o eta.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG eta.c
>>> gcc -o verify.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG verify.c
>>> gcc -o memory.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG memory.c
>>> gcc -o io_u.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG io_u.c
>>> gcc -o parse.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG parse.c
>>> gcc -o mutex.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG mutex.c
>>> gcc -o options.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG options.c
>>> gcc -o rbtree.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG rbtree.c
>>> gcc -o smalloc.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG smalloc.c
>>> gcc -o filehash.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG filehash.c
>>> gcc -o profile.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG profile.c
>>> gcc -o debug.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG debug.c
>>> gcc -o lib/rand.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG lib/rand.c
>>> gcc -o lib/num2str.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG lib/num2str.c
>>> gcc -o lib/ieee754.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG lib/ieee754.c
>>> gcc -o crc/crc16.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG crc/crc16.c
>>> gcc -o crc/crc32.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG crc/crc32.c
>>> gcc -o crc/crc32c.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG crc/crc32c.c
>>> gcc -o crc/crc32c-intel.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG crc/crc32c-intel.c
>>> gcc -o crc/crc64.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG crc/crc64.c
>>> gcc -o crc/crc7.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG crc/crc7.c
>>> gcc -o crc/md5.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG crc/md5.c
>>> gcc -o crc/sha1.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG crc/sha1.c
>>> gcc -o crc/sha256.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG crc/sha256.c
>>> gcc -o crc/sha512.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG crc/sha512.c
>>> gcc -o engines/cpu.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG engines/cpu.c
>>> gcc -o engines/mmap.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG engines/mmap.c
>>> gcc -o engines/sync.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG engines/sync.c
>>> gcc -o engines/null.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG engines/null.c
>>> gcc -o engines/net.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG engines/net.c
>>> gcc -o memalign.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG memalign.c
>>> gcc -o server.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG server.c
>>> gcc -o client.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG client.c
>>> gcc -o iolog.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG iolog.c
>>> gcc -o backend.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG backend.c
>>> gcc -o libfio.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>>   -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG libfio.c
>>> gcc -o flow.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG flow.c
>>> gcc -o json.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG json.c
>>> gcc -o lib/zipf.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG lib/zipf.c
>>> gcc -o lib/axmap.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG lib/axmap.c
>>> gcc -o lib/lfsr.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG lib/lfsr.c
>>> gcc -o gettime-thread.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG gettime-thread.c
>>> gcc -o diskutil.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG diskutil.c
>>> gcc -o fifo.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG fifo.c
>>> gcc -o blktrace.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG blktrace.c
>>> gcc -o trim.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE -D_LARGEFILE_SOURCE
>>> -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -DFIO_INC_DEBUG trim.c
>>> gcc -o profiles/tiobench.o -c -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g
>>> -ffast-math  -DFIO_VERSION=3D'"fio-2.0.13"' -D_GNU_SOURCE
>>> -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2
>>> -DFIO_INC_DEBUG profiles/tiobench.c
>>> gcc -rdynamic -std=3Dgnu99 -Wwrite-strings -Wall -O3 -g -ffast-math
>>> -DFIO_VERSION=3D'"fio-2.0.13"' -o fio gettime.o fio.o ioengines.o init.o
>>> stat.o log.o time.o filesetup.o eta.o verify.o memory.o io_u.o parse.o
>>> mutex.o options.o rbtree.o smalloc.o filehash.o profile.o debug.o
>>> lib/rand.o lib/num2str.o lib/ieee754.o crc/crc16.o crc/crc32.o
>>> crc/crc32c.o crc/crc32c-intel.o crc/crc64.o crc/crc7.o crc/md5.o
>>> crc/sha1.o crc/sha256.o crc/sha512.o engines/cpu.o engines/mmap.o
>>> engines/sync.o engines/null.o engines/net.o memalign.o server.o
>>> client.o iolog.o backend.o libfio.o flow.o json.o lib/zipf.o
>>> lib/axmap.o lib/lfsr.o gettime-thread.o diskutil.o fifo.o blktrace.o
>>> trim.o profiles/tiobench.o -lm  -ldl -lpthread -lrt -ldl -rdynamic
>>> backend.o: In function `thread_main':
>>> /home/david/development/android/external/fio-2.0.13/backend.c:1299:
>>> undefined reference to `cgroup_shutdown'
>>> /home/david/development/android/external/fio-2.0.13/backend.c:1142:
>>> undefined reference to `cgroup_setup'
>>> backend.o: In function `fio_backend':
>>> /home/david/development/android/external/fio-2.0.13/backend.c:1794:
>>> undefined reference to `cgroup_kill'
>>> collect2: ld returned 1 exit status
>>> make: *** [fio] Error 1
>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$
>>>
>>>
>>> On Tue, Feb 12, 2013 at 1:27 AM, Aaron Carroll <aaronc@cse.unsw.edu.au>=
 wrote:
>>>> On 12/02/13 5:20 PM, David N wrote:
>>>>> Aaron,
>>>>>
>>>>> I added -lpthread in the Makefile and most of the errors disappeared.
>>>>> This is left:
>>>>>
>>>>> backend.o: In function `thread_main':
>>>>> /home/david/development/android/external/fio-2.0.13/backend.c:1299:
>>>>> undefined reference to `cgroup_shutdown'
>>>>> /home/david/development/android/external/fio-2.0.13/backend.c:1142:
>>>>> undefined reference to `cgroup_setup'
>>>>> backend.o: In function `fio_backend':
>>>>> /home/david/development/android/external/fio-2.0.13/backend.c:1794:
>>>>> undefined reference to `cgroup_kill'
>>>>> collect2: ld returned 1 exit status
>>>>> make: *** [fio] Error 1
>>>>
>>>> Somehow FIO_HAVE_CGROUPS got defined... perhaps you need a make clean.
>>>> Again, please use V=3D1 in your make line when posting errors.
>>>>
>>>> Thanks,
>>>>    -- Aaron
>>>>
>>>>
>>>>>
>>>>>
>>>>> On Tue, Feb 12, 2013 at 12:58 AM, Aaron Carroll <aaronc@cse.unsw.edu.=
au> wrote:
>>>>>> David,
>>>>>>
>>>>>> On 12/02/13 4:39 PM, David N wrote:
>>>>>>> Thanks much for your help. I still get following errors. Do you have
>>>>>>> any idea where the problem can be?
>>>>>>
>>>>>> I've not seen that problem before.  I wonder if adding -lpthread to =
the
>>>>>> linker flags might fix it?
>>>>>>
>>>>>> Try adding "V=3D1" to the make arguments and post the failing comman=
d.
>>>>>>
>>>>>>
>>>>>>
>>>>>>     -- Aaron
>>>>>>
>>>>>>
>>>>>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ ma=
ke
>>>>>>> cross_prefix=3D~/development/android/prebuilts/gcc/linux-x86/arm/ar=
m-linux-androideabi-4.7/bin
>>>>>>> UNAME=3DAndroid
>>>>>>> FIO_VERSION =3D fio-2.0.132
>>>>>>>      DEP .depend
>>>>>>>      CC gettime.o
>>>>>>>      CC fio.o
>>>>>>>      CC ioengines.o
>>>>>>>      CC init.o
>>>>>>>      CC stat.o
>>>>>>>      CC log.o
>>>>>>>      CC time.o
>>>>>>>      CC filesetup.o
>>>>>>>      CC eta.o
>>>>>>>      CC verify.o
>>>>>>>      CC memory.o
>>>>>>>      CC io_u.o
>>>>>>>      CC parse.o
>>>>>>>      CC mutex.o
>>>>>>>      CC options.o
>>>>>>>      CC rbtree.o
>>>>>>>      CC smalloc.o
>>>>>>>      CC filehash.o
>>>>>>>      CC profile.o
>>>>>>>      CC debug.o
>>>>>>>      CC lib/rand.o
>>>>>>>      CC lib/num2str.o
>>>>>>>      CC lib/ieee754.o
>>>>>>>      CC crc/crc16.o
>>>>>>>      CC crc/crc32.o
>>>>>>>      CC crc/crc32c.o
>>>>>>>      CC crc/crc32c-intel.o
>>>>>>>      CC crc/crc64.o
>>>>>>>      CC crc/crc7.o
>>>>>>>      CC crc/md5.o
>>>>>>>      CC crc/sha1.o
>>>>>>>      CC crc/sha256.o
>>>>>>>      CC crc/sha512.o
>>>>>>>      CC engines/cpu.o
>>>>>>>      CC engines/mmap.o
>>>>>>>      CC engines/sync.o
>>>>>>>      CC engines/null.o
>>>>>>>      CC engines/net.o
>>>>>>>      CC memalign.o
>>>>>>>      CC server.o
>>>>>>>      CC client.o
>>>>>>>      CC iolog.o
>>>>>>>      CC backend.o
>>>>>>>      CC libfio.o
>>>>>>>      CC flow.o
>>>>>>>      CC json.o
>>>>>>>      CC lib/zipf.o
>>>>>>>      CC lib/axmap.o
>>>>>>>      CC lib/lfsr.o
>>>>>>>      CC gettime-thread.o
>>>>>>>      CC diskutil.o
>>>>>>>      CC fifo.o
>>>>>>>      CC blktrace.o
>>>>>>>      CC trim.o
>>>>>>>      CC profiles/tiobench.o
>>>>>>>      CC fio
>>>>>>> verify.o: In function `verify_async_init':
>>>>>>> /home/david/development/android/external/fio-2.0.13/verify.c:1091:
>>>>>>> undefined reference to `pthread_attr_setstacksize'
>>>>>>> /home/david/development/android/external/fio-2.0.13/verify.c:1104:
>>>>>>> undefined reference to `pthread_detach'
>>>>>>> /home/david/development/android/external/fio-2.0.13/verify.c:1097:
>>>>>>> undefined reference to `pthread_create'
>>>>>>> gettime.o: In function `fio_gettime':
>>>>>>> /home/david/development/android/external/fio-2.0.13/gettime.c:152:
>>>>>>> undefined reference to `pthread_getspecific'
>>>>>>> gettime.o: In function `fio_local_clock_init':
>>>>>>> /home/david/development/android/external/fio-2.0.13/gettime.c:295:
>>>>>>> undefined reference to `pthread_setspecific'
>>>>>>> gettime.o: In function `fio_clock_init':
>>>>>>> /home/david/development/android/external/fio-2.0.13/gettime.c:309:
>>>>>>> undefined reference to `pthread_key_create'
>>>>>>> gettime.o: In function `fio_monotonic_clocktest':
>>>>>>> /home/david/development/android/external/fio-2.0.13/gettime.c:492:
>>>>>>> undefined reference to `pthread_create'
>>>>>>> /home/david/development/android/external/fio-2.0.13/gettime.c:511:
>>>>>>> undefined reference to `pthread_join'
>>>>>>> stat.o: In function `show_running_run_stats':
>>>>>>> /home/david/development/android/external/fio-2.0.13/stat.c:1388:
>>>>>>> undefined reference to `pthread_create'
>>>>>>> /home/david/development/android/external/fio-2.0.13/stat.c:1389:
>>>>>>> undefined reference to `pthread_detach'
>>>>>>> mutex.o: In function `fio_mutex_init':
>>>>>>> /home/david/development/android/external/fio-2.0.13/mutex.c:44:
>>>>>>> undefined reference to `pthread_mutexattr_init'
>>>>>>> /home/david/development/android/external/fio-2.0.13/mutex.c:54:
>>>>>>> undefined reference to `pthread_mutexattr_setpshared'
>>>>>>> /home/david/development/android/external/fio-2.0.13/mutex.c:63:
>>>>>>> undefined reference to `pthread_condattr_setpshared'
>>>>>>> /home/david/development/android/external/fio-2.0.13/mutex.c:74:
>>>>>>> undefined reference to `pthread_mutexattr_destroy'
>>>>>>> backend.o: In function `thread_main':
>>>>>>> /home/david/development/android/external/fio-2.0.13/backend.c:1299:
>>>>>>> undefined reference to `cgroup_shutdown'
>>>>>>> /home/david/development/android/external/fio-2.0.13/backend.c:1142:
>>>>>>> undefined reference to `cgroup_setup'
>>>>>>> backend.o: In function `run_threads':
>>>>>>> /home/david/development/android/external/fio-2.0.13/backend.c:1568:
>>>>>>> undefined reference to `pthread_create'
>>>>>>> /home/david/development/android/external/fio-2.0.13/backend.c:1576:
>>>>>>> undefined reference to `pthread_detach'
>>>>>>> backend.o: In function `create_disk_util_thread':
>>>>>>> /home/david/development/android/external/fio-2.0.13/backend.c:1724:
>>>>>>> undefined reference to `pthread_create'
>>>>>>> /home/david/development/android/external/fio-2.0.13/backend.c:1731:
>>>>>>> undefined reference to `pthread_detach'
>>>>>>> backend.o: In function `fio_backend':
>>>>>>> /home/david/development/android/external/fio-2.0.13/backend.c:1794:
>>>>>>> undefined reference to `cgroup_kill'
>>>>>>> gettime-thread.o: In function `fio_start_gtod_thread':
>>>>>>> /home/david/development/android/external/fio-2.0.13/gettime-thread.=
c:56:
>>>>>>> undefined reference to `pthread_attr_setstacksize'
>>>>>>> /home/david/development/android/external/fio-2.0.13/gettime-thread.=
c:57:
>>>>>>> undefined reference to `pthread_create'
>>>>>>> /home/david/development/android/external/fio-2.0.13/gettime-thread.=
c:64:
>>>>>>> undefined reference to `pthread_detach'
>>>>>>> collect2: ld returned 1 exit status
>>>>>>> make: *** [fio] Error 1
>>>>>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$ ~~
>>>>>>>
>>>>>>>
>>>>>>> On Mon, Feb 11, 2013 at 8:53 PM, Aaron Carroll <aaronc@cse.unsw.edu=
.au> wrote:
>>>>>>>> On 12/02/13 4:25 AM, Jens Axboe wrote:
>>>>>>>>> On Mon, Feb 11 2013, David N wrote:
>>>>>>>>>> Hello Everyone,
>>>>>>>>>>
>>>>>>>>>> I've been trying to compile FIO for Android but keep getting err=
or
>>>>>>>>>> bellow. Can anybody give me any guidance please?
>>>>>>>>>>
>>>>>>>>>> I very much appreciate!
>>>>>>>>>>
>>>>>>>>>> David
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> david@david-HP-ubuntu:~/development/android/external/fio-2.0.13$=
 make
>>>>>>>>>> UNAME=3DAndroid CROSS_COMPILE=3D$CCOMPILER
>>>>>>>>>>      CC init.o
>>>>>>>>>> init.c: In function =EF=BF=BDfree_shm=EF=BF=BD:
>>>>>>>>>> init.c:224:18: error: storage size of =EF=BF=BDsbuf=EF=BF=BD isn=
=EF=BF=BDt known
>>>>>>>>>> init.c:233:3: warning: implicit declaration of function =EF=BF=
=BDshmdt=EF=BF=BD
>>>>>>>>>> [-Wimplicit-function-declaration]
>>>>>>>>>> init.c:234:3: warning: implicit declaration of function =EF=BF=
=BDshmctl=EF=BF=BD
>>>>>>>>>> [-Wimplicit-function-declaration]
>>>>>>>>>> init.c:224:18: warning: unused variable =EF=BF=BDsbuf=EF=BF=BD [=
-Wunused-variable]
>>>>>>>>>> init.c: In function =EF=BF=BDsetup_thread_area=EF=BF=BD:
>>>>>>>>>> init.c:263:3: warning: implicit declaration of function =EF=BF=
=BDshmget=EF=BF=BD
>>>>>>>>>> [-Wimplicit-function-declaration]
>>>>>>>>>> init.c:277:2: warning: implicit declaration of function =EF=BF=
=BDshmat=EF=BF=BD
>>>>>>>>>> [-Wimplicit-function-declaration]
>>>>>>>>>> init.c:277:10: warning: assignment makes pointer from integer wi=
thout
>>>>>>>>>> a cast [enabled by default]
>>>>>>>>>> make: *** [init.o] Error 1
>>>>>>>>>
>>>>>>>>> Lets CC in Aaron, who added the port.
>>>>>>>>
>>>>>>>> The switch to configure broke Android.  I got a very minimal build
>>>>>>>> working with the attached patch and:
>>>>>>>>
>>>>>>>>    make
>>>>>>>> cross_prefix=3D~/dev/android-toolchain-r8c/bin/arm-linux-androidea=
bi-
>>>>>>>> UNAME=3DAndroid
>>>>>>>>
>>>>>>>>
>>>>>>>> Hope that helps,
>>>>>>>>    -- Aaron
>>>>>>>>
>>>>>>
>>>>
>>

