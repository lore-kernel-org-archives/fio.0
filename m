Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:54195 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1HDGpb (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Aug 2011 02:45:31 -0400
Message-ID: <4E3A4008.9050105@fusionio.com>
Date: Thu, 4 Aug 2011 08:45:28 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: On I/O engines
References: <201108032213.36977.Martin@lichtvoll.de>
In-Reply-To: <201108032213.36977.Martin@lichtvoll.de>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: fio@vger.kernel.org

On 2011-08-03 22:13, Martin Steigerwald wrote:
> Hi!
>=20
> In order to understand I/O engines better, I like to summarize what I=20
> think to know at the moment. Maybe this can be a starting point for some =

> additional documentation:
>=20
> =3D=3D=3D sync, psync, vsync =3D=3D=3D
>=20
> - all these are using synchronous Linux (POSIX) system calls
> - is used by regular applications
> - synchronous just refers to the system call interface: i.e. the when the=
=20
> system call returns to the application
> - as far as I understand it returns when the I/O request is told to be=20
> completed
> - it does not imply synchronous I/O aka O_SYNC which is way slower and=20
> enabled by sync=3D1
> - thus it does not guarantee that the I/O has been physically written to =

> the underlying device (see open(2))

All of above are correct.

> - thus is only guarantees that the I/O request has been dealt with? what =

> does this exactly mean?

For reads, the IO has been done by the device. For writes, it could just
be sitting in the page cache for later writeback.

> - does it mean that this is I/O in the context of the process?

Not sure what you mean here. For reads, the IO always happens in the
context of the process. For buffered writes, it usually does not. The
process merely dirties the page, kernel threads will most often do the
actual writeback of the data.

> - it can be used with direct=3D1 to circumvent the pagecache

Right, and additionally direct=3D1 will make the writes sync as well. So
instead of just returning when it's in page cache, when a sync write
with direct=3D1 returns, the data has been received and acknowledged by
the backing device. That does not mean it's stable, it could just be
sitting in the drive write back cache.

> difference is the kind of system call used:
> - sync uses read/write which read/write count bytes into from/to a buffer=
.=20
> Uses current file offset, changeable via fseek (or lseek, I did not find =
a=20
> manpage for fseek)

Fio uses file descriptors, not handles. So lseek() will be used to
position the file before each IO, unless the offset of the new IO is
identical to the current offset.

> - psync uses pread/pwrite which read/write count bytes from given offset
> - vsync uses readv/writev which read/writes count, i.e. mutiple buffers o=
f=20
> given length in one call (struct iovec)
>=20
> I am not sure on what performance difference to expect. I bet that=20
> sync/psync should perform roughly the same.

For random IO, you save a lseek() syscall for each IO. Depending on your
IO rates, this may or may not be significant. It usually isn't. But if
you are doing hundreds of thousand IOPS, then it could make a
difference.

> =3D=3D=3D libaio =3D=3D=3D
>=20
> - this uses Linux asynchronous I/O calls[1]
> - it uses libaio for that
> - who else uses libaio? It systems application that are near to the=20
> system:
>=20
> martin@merkaba:~> apt-cache rdepends libaio1
> libaio1
> Reverse Depends:
>   fio
>   qemu-kvm
>   libdbd-oracle-perl
>   zfs-fuse
>   stressapptest
>   qemu-kvm
>   qemu-utils
>   qemu-system
>   multipath-tools
>   ltp-kernel-test
>   libaio1-dbg
>   libaio-dev
>   fio
>   drizzle
>   blktrace
>=20
> - these calls allow applications to offload I/O calls to the background
> - according to [1] this is only supported for direct I/O
> - using anything else let it fall back to synchronous call behavior
> - thus one sees this in combination with direct=3D1 in fio jobs
> - does this mean that this is I/O outside the context of the process?

aio assumes the identity of the process. aio is usually mostly used by
databases.

> Question:
> - what difference is between the following two other than the second one =

> seems to be more popular in example job files?
> 1) ioengine=3Dsync + direct=3D1
> 2) ioengine=3Dlibaio + direct=3D1
>=20
> Current answer: It is that fio can issue further I/Os while the Linux=20
> kernels handles the I/O.

Yes

> =3D=3D=3D other I/O engines relevant to Linux =3D=3D=3D
> There seem to be some other I/O engines relevant to Linux and mass storag=
e=20
> I/O:
>=20
> =3D=3D mmap =3D=3D
> - maps the memory into files and uses memcpy
> - used by quite some applications
> - what else to note?

mmap'ed IO is quite widely used.

> =3D=3D syslet-rw =3D=3D
> - make regular read/write asynchronous
> - where is this used?
> - what else to note?

syslet-rw is an engine that was written to benchmark/test the syslet
async system call interface. It was never merged, so it has mostly
historic relevance now.

> Any others?

You should mention posixaio and net as well, might be interesting. And
splice is unique to Linux, would be good to cover.

> Is what I wrote correct so far?

Yep, good so far!

> I think I=EF=BF=BDd like to write something up about the different I/O co=
ncepts in=20
> Linux, if such a document doesn=EF=BF=BDt exist yet.

Might not be a bad idea :-)

--=20
Jens Axboe

