Return-Path: <dongjin.lee@auckland.ac.nz>
MIME-Version: 1.0
From: DongJin Lee <dongjin.lee@auckland.ac.nz>
Date: Thu, 4 Aug 2011 00:58:21 -0600
Subject: Re: On I/O engines
Message-ID: 
 <CA+e7fc_Lfm=Zhp52sAWWLf7g4h6K_fW9w66inSqpx-n9ajh__g@mail.gmail.com>
References: <201108032213.36977.Martin@lichtvoll.de>
	<4E3A4008.9050105@fusionio.com>
In-Reply-To: <4E3A4008.9050105@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

just adding 2c question:

> On Thu, Aug 4, 2011 at 18:45, Jens Axboe <jaxboe@fusionio.com> wrote:
> That does not mean it's stable, it could just be
> sitting in the drive write back cache.

right, example with a simple hdd 2tb with some 64mb cache, so indeed,
there's no real way to confirm that the data has been physically
written to the mechanical platter;
but as I understand when shutting down the system, all are physically
written to the platter; so I wonder what command the os issues to the
disk then? maybe just unmount do so?

Regards

On Thu, Aug 4, 2011 at 18:45, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-08-03 22:13, Martin Steigerwald wrote:
>> Hi!
>>
>> In order to understand I/O engines better, I like to summarize what I
>> think to know at the moment. Maybe this can be a starting point for some
>> additional documentation:
>>
>> =3D=3D=3D sync, psync, vsync =3D=3D=3D
>>
>> - all these are using synchronous Linux (POSIX) system calls
>> - is used by regular applications
>> - synchronous just refers to the system call interface: i.e. the when th=
e
>> system call returns to the application
>> - as far as I understand it returns when the I/O request is told to be
>> completed
>> - it does not imply synchronous I/O aka O_SYNC which is way slower and
>> enabled by sync=3D1
>> - thus it does not guarantee that the I/O has been physically written to
>> the underlying device (see open(2))
>
> All of above are correct.
>
>> - thus is only guarantees that the I/O request has been dealt with? what
>> does this exactly mean?
>
> For reads, the IO has been done by the device. For writes, it could just
> be sitting in the page cache for later writeback.
>
>> - does it mean that this is I/O in the context of the process?
>
> Not sure what you mean here. For reads, the IO always happens in the
> context of the process. For buffered writes, it usually does not. The
> process merely dirties the page, kernel threads will most often do the
> actual writeback of the data.
>
>> - it can be used with direct=3D1 to circumvent the pagecache
>
> Right, and additionally direct=3D1 will make the writes sync as well. So
> instead of just returning when it's in page cache, when a sync write
> with direct=3D1 returns, the data has been received and acknowledged by
> the backing device. That does not mean it's stable, it could just be
> sitting in the drive write back cache.
>
>> difference is the kind of system call used:
>> - sync uses read/write which read/write count bytes into from/to a buffe=
r.
>> Uses current file offset, changeable via fseek (or lseek, I did not find=
 a
>> manpage for fseek)
>
> Fio uses file descriptors, not handles. So lseek() will be used to
> position the file before each IO, unless the offset of the new IO is
> identical to the current offset.
>
>> - psync uses pread/pwrite which read/write count bytes from given offset
>> - vsync uses readv/writev which read/writes count, i.e. mutiple buffers =
of
>> given length in one call (struct iovec)
>>
>> I am not sure on what performance difference to expect. I bet that
>> sync/psync should perform roughly the same.
>
> For random IO, you save a lseek() syscall for each IO. Depending on your
> IO rates, this may or may not be significant. It usually isn't. But if
> you are doing hundreds of thousand IOPS, then it could make a
> difference.
>
>> =3D=3D=3D libaio =3D=3D=3D
>>
>> - this uses Linux asynchronous I/O calls[1]
>> - it uses libaio for that
>> - who else uses libaio? It systems application that are near to the
>> system:
>>
>> martin@merkaba:~> apt-cache rdepends libaio1
>> libaio1
>> Reverse Depends:
>> =A0 fio
>> =A0 qemu-kvm
>> =A0 libdbd-oracle-perl
>> =A0 zfs-fuse
>> =A0 stressapptest
>> =A0 qemu-kvm
>> =A0 qemu-utils
>> =A0 qemu-system
>> =A0 multipath-tools
>> =A0 ltp-kernel-test
>> =A0 libaio1-dbg
>> =A0 libaio-dev
>> =A0 fio
>> =A0 drizzle
>> =A0 blktrace
>>
>> - these calls allow applications to offload I/O calls to the background
>> - according to [1] this is only supported for direct I/O
>> - using anything else let it fall back to synchronous call behavior
>> - thus one sees this in combination with direct=3D1 in fio jobs
>> - does this mean that this is I/O outside the context of the process?
>
> aio assumes the identity of the process. aio is usually mostly used by
> databases.
>
>> Question:
>> - what difference is between the following two other than the second one
>> seems to be more popular in example job files?
>> 1) ioengine=3Dsync + direct=3D1
>> 2) ioengine=3Dlibaio + direct=3D1
>>
>> Current answer: It is that fio can issue further I/Os while the Linux
>> kernels handles the I/O.
>
> Yes
>
>> =3D=3D=3D other I/O engines relevant to Linux =3D=3D=3D
>> There seem to be some other I/O engines relevant to Linux and mass stora=
ge
>> I/O:
>>
>> =3D=3D mmap =3D=3D
>> - maps the memory into files and uses memcpy
>> - used by quite some applications
>> - what else to note?
>
> mmap'ed IO is quite widely used.
>
>> =3D=3D syslet-rw =3D=3D
>> - make regular read/write asynchronous
>> - where is this used?
>> - what else to note?
>
> syslet-rw is an engine that was written to benchmark/test the syslet
> async system call interface. It was never merged, so it has mostly
> historic relevance now.
>
>> Any others?
>
> You should mention posixaio and net as well, might be interesting. And
> splice is unique to Linux, would be good to cover.
>
>> Is what I wrote correct so far?
>
> Yep, good so far!
>
>> I think I=B4d like to write something up about the different I/O concept=
s in
>> Linux, if such a document doesn=B4t exist yet.
>
> Might not be a bad idea :-)
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

