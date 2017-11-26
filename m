Return-Path: <fio-owner@vger.kernel.org>
Received: from g4t3426.houston.hpe.com ([15.241.140.75]:13160 "EHLO
        g4t3426.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdKZFaw (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 26 Nov 2017 00:30:52 -0500
Received: from G1W8106.americas.hpqcorp.net (g1w8106.austin.hp.com [16.193.72.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g4t3426.houston.hpe.com (Postfix) with ESMTPS id 4E0E967
        for <fio@vger.kernel.org>; Sun, 26 Nov 2017 05:30:51 +0000 (UTC)
From: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>
Subject: RE: fio 3.2
Date: Sun, 26 Nov 2017 05:30:48 +0000
Message-ID: <TU4PR8401MB0991DC48F1741A8F8F1DEF20EC240@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM>
 <903d418b-bac4-104b-28e5-3c529efab7f5@kernel.dk>
In-Reply-To: <903d418b-bac4-104b-28e5-3c529efab7f5@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

OK, I rebuild 3.2 with libaio & libpmem libraries,

dl560g10spmem01:/var/work/fio-3.2 # rpm -qa|grep libpmem
libpmemblk-1.3-3.fc27.x86_64
libpmempool-devel-1.3-3.fc27.x86_64
libpmemlog-1.3-3.fc27.x86_64
libpmem-devel-1.3-3.fc27.x86_64
libpmemobj-devel-1.3-3.fc27.x86_64
libpmem-1.3-3.fc27.x86_64
libpmemobj-1.3-3.fc27.x86_64
libpmemblk-devel-1.3-3.fc27.x86_64
libpmempool-1.3-3.fc27.x86_64
libpmemlog-devel-1.3-3.fc27.x86_64

dl560g10spmem01:/var/work/fio-3.2 # ./configure
Operating system              Linux
CPU                           x86_64
Big endian                    no
Compiler                      gcc
Cross compile                 no
Static build                  no
Wordsize                      64
zlib                          yes
Linux AIO support             yes
POSIX AIO support             yes
POSIX AIO support needs -lrt  yes
POSIX AIO fsync               yes
POSIX pshared support         yes
Solaris AIO support           no
__sync_fetch_and_add          yes
__sync_synchronize            yes
__sync_val_compare_and_swap   yes
libverbs                      no
rdmacm                        no
Linux fallocate               yes
POSIX fadvise                 yes
POSIX fallocate               yes
sched_setaffinity(3 arg)      yes
sched_setaffinity(2 arg)      no
clock_gettime                 yes
CLOCK_MONOTONIC               yes
CLOCK_MONOTONIC_RAW           yes
CLOCK_MONOTONIC_PRECISE       no
clockid_t                     yes
gettimeofday                  yes
fdatasync                     yes
sync_file_range               yes
EXT4 move extent              yes
Linux splice(2)               yes
GUASI                         no
Fusion-io atomic engine       no
libnuma                       yes
libnuma v2                    yes
strsep                        yes
strcasestr                    yes
strlcat                       no
getopt_long_only()            yes
inet_aton                     yes
socklen_t                     yes
__thread                      yes
RUSAGE_THREAD                 yes
SCHED_IDLE                    yes
TCP_NODELAY                   yes
Net engine window_size        yes
TCP_MAXSEG                    yes
RLIMIT_MEMLOCK                yes
pwritev/preadv                yes
pwritev2/preadv2              no
IPv6 helpers                  yes
Rados Block Device engine     no
rbd blkin tracing             no
setvbuf                       yes
Gluster API engine            no
s390_z196_facilities          no
HDFS engine                   no
MTD                           yes
libpmem                       yes
libpmemblk                    yes
NVML pmemblk engine           yes
NVML dev-dax engine           yes
lex/yacc for arithmetic       no
getmntent                     yes
getmntinfo                    no
Static Assert                 yes
bool                          yes
strndup                       yes
march_armv8_a_crc_crypto      no
cuda                          no
mkdir(a, b)                   yes
dl560g10spmem01:/var/work/fio-3.2 # make
    CC crc/crc16.o
    CC crc/crc32.o
    CC crc/crc32c-arm64.o
    CC crc/crc32c-intel.o
    CC crc/crc32c.o
    CC crc/crc64.o
    CC crc/crc7.o
    CC crc/fnv.o
    CC crc/md5.o
    CC crc/murmur3.o
    CC crc/sha1.o
    CC crc/sha256.o
    CC crc/sha3.o
    CC crc/sha512.o
    CC crc/test.o
    CC crc/xxhash.o
    CC lib/axmap.o
    CC lib/bloom.o
    CC lib/flist_sort.o
    CC lib/gauss.o
    CC lib/getrusage.o
    CC lib/hweight.o
    CC lib/ieee754.o
    CC lib/lfsr.o
    CC lib/memalign.o
    CC lib/mountcheck.o
    CC lib/num2str.o
    CC lib/output_buffer.o
    CC lib/pattern.o
    CC lib/prio_tree.o
    CC lib/rand.o
    CC lib/rbtree.o
    CC lib/strntol.o
    CC lib/zipf.o
    CC gettime.o
    CC ioengines.o
    CC init.o
    CC stat.o
    CC log.o
    CC time.o
    CC filesetup.o
    CC eta.o
    CC verify.o
    CC memory.o
    CC io_u.o
    CC parse.o
    CC mutex.o
    CC options.o
    CC smalloc.o
    CC filehash.o
    CC profile.o
    CC debug.o
    CC engines/cpu.o
    CC engines/mmap.o
    CC engines/sync.o
    CC engines/null.o
    CC engines/net.o
    CC engines/ftruncate.o
    CC engines/filecreate.o
    CC server.o
    CC client.o
    CC iolog.o
    CC backend.o
    CC libfio.o
    CC flow.o
    CC cconv.o
    CC gettime-thread.o
    CC helpers.o
    CC json.o
    CC idletime.o
    CC td_error.o
    CC profiles/tiobench.o
    CC profiles/act.o
    CC io_u_queue.o
    CC filelock.o
    CC workqueue.o
    CC rate-submit.o
    CC optgroup.o
    CC helper_thread.o
    CC steadystate.o
    CC engines/libaio.o
    CC engines/posixaio.o
    CC engines/falloc.o
    CC engines/e4defrag.o
    CC engines/splice.o
    CC oslib/strlcat.o
    CC engines/mtd.o
    CC oslib/libmtd.o
    CC oslib/libmtd_legacy.o
    CC engines/pmemblk.o
    CC engines/dev-dax.o
    CC diskutil.o
    CC fifo.o
    CC blktrace.o
    CC cgroup.o
    CC trim.o
    CC engines/sg.o
    CC engines/binject.o
    CC oslib/linux-dev-lookup.o
  LINK fio
  LINK t/fio-genzipf
  LINK t/fio-btrace2fio
  LINK t/fio-dedupe
  LINK t/fio-verify-state
  LINK t/stest
  LINK t/ieee754
  LINK t/axmap
  LINK t/lfsr-test
  LINK t/gen-rand
dl560g10spmem01:/var/work/fio-3.2 # /usr/local/bin/fio --enghelp
Available IO engines:
        cpuio
        mmap
        sync
        psync
        vsync
        pvsync
        pvsync2
        null
        net
        netsplice
        ftruncate
        filecreate
        libaio
        posixaio
        falloc
        e4defrag
        splice
        mtd
        pmemblk
        dev-dax
        sg
        binject
dl560g10spmem01:/var/work/fio-3.2 # /usr/local/bin/fio --filename=3D/dev/da=
x0.0 --rw=3Drandrw --refill_buffers --norandommap --randrepeat=3D0 --ioengi=
ne=3Ddev-dax --bssplit=3D4k/4:8k/7:16k/7:32k/15:64k/65:128k/1:256k/1 --rwmi=
xread=3D5 --iodepth=3D1 --numjobs=3D1 --runtime=3D1800 --group_reporting --=
name=3D4-rand-rw-3xx --size=3D300Gb --name=3D4-rand-rw-3xx
4-rand-rw-3xx: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-256KiB, (W) 4096B-256Ki=
B, (T) 4096B-256KiB, ioengine=3Ddev-dax, iodepth=3D1
4-rand-rw-3xx: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-256KiB, (W) 4096B-256Ki=
B, (T) 4096B-256KiB, ioengine=3Ddev-dax, iodepth=3D1
fio-3.2
Starting 2 processes

Run status group 0 (all jobs):
dl560g10spmem01:/var/work/fio-3.2 #


/dev/pmem1 on /pmem type xfs (rw,relatime,attr2,dax,inode64,noquota)
dl560g10spmem01:/var/work/fio-3.2 # /usr/local/bin/fio --filename=3D/dev/pm=
em1 --rw=3Drandrw --refill_buffers --norandommap --randrepeat=3D0 --ioengin=
e=3Dpmemblk --bssplit=3D4k/4:8k/7:16k/7:32k/15:64k/65:128k/1:256k/1 --rwmix=
read=3D5 --iodepth=3D1 --numjobs=3D1 --runtime=3D1800 --group_reporting --n=
ame=3D4-rand-rw-3xx --allow_mounted_write=3D1 --thread=3D1 --direct=3D1
4-rand-rw-3xx: (g=3D0): rw=3Drandrw, bs=3D(R) 4096B-256KiB, (W) 4096B-256Ki=
B, (T) 4096B-256KiB, ioengine=3Dpmemblk, iodepth=3D1
fio-3.2
Starting 1 thread
pmemblk: unable to open pmemblk pool file /dev/pmem1 (Invalid argument)

Run status group 0 (all jobs):
dl560g10spmem01:/var/work/fio-3.2 #


dl560g10spmem01:/var/work/fio-3.2 # ll /dev/dax0.0
-rw-r--r-- 1 root root 322122547200 Nov 25 22:16 /dev/dax0.0
dl560g10spmem01:/var/work/fio-3.2 # ll /dev/pmem1
brw-rw---- 1 root disk 259, 3 Nov 25 21:51 /dev/pmem1

No error messages in dmesg/messages.

And the libpmem engine still not available.

Anton

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Saturday, November 25, 2017 7:40 PM
To: Gavriliuk, Anton (HPS Ukraine) <anton.gavriliuk@hpe.com>
Subject: Re: fio 3.2

See the BUILDING section of the README. You are missing libaio-dev(el) and =
ditto for pmem. When you run configure, it shows you what it detects and wh=
at it doesn't.

In the future, please send support questions to the reflector, as also desc=
ribed in the documentation, fio@vger.kernel.org. I can't cater to all perso=
nal support requests, and there are plenty of other folks on that list that=
 can help you out, especially on basic questions like this.


On 11/25/2017 08:50 AM, Gavriliuk, Anton (HPS Ukraine) wrote:
> In 3.2 version libaio engine also missed., can't be loaded
>=20
> =EF=BF=BD
>=20
> Anton
>=20
> =EF=BF=BD
>=20
> *From:* Gavriliuk, Anton (HPS Ukraine)
> *Sent:* Saturday, November 25, 2017 9:12 AM
> *To:* 'jens.axboe@oracle.com' <jens.axboe@oracle.com>;=20
> 'jaxboe@fusionio.com' <jaxboe@fusionio.com>; 'axboe@fb.com'=20
> <axboe@fb.com>
> *Subject:* fio 3.2
>=20
> =EF=BF=BD
>=20
> Hello Jens
>=20
> =EF=BF=BD
>=20
> I'm testing persistent memory using latest fio 3.2
>=20
> =EF=BF=BD
>=20
> http://fio.readthedocs.io/en/latest/fio_doc.html#building=20
> <https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__fio.readthedocs.i
> o_en_latest_fio-5Fdoc.html-23building&d=3DDwMFAg&c=3D5VD0RTtNlTh3ycd41b3MU
> w&r=3DcK1a7KivzZRh1fKQMjSm2A&m=3DgF-hXqu35gNKL7tvHVTPbXTfipn8kMan45lnr9z1C
> kA&s=3D9wSt7cGFX26GOxsXLnQ6pALYuxas7yjYsYsV-AWIMhA&e=3D>
>=20
> =EF=BF=BD
>=20
> 1.12.10. I/O engine
>=20
> pmemblk
>=20
> Read and write using filesystem DAX to a file on a filesystem mounted wit=
h DAX on a persistent memory device through the NVML libpmemblk library.
>=20
> dev-dax
>=20
> Read and write using device DAX to a persistent memory device (e.g., /dev=
/dax0.0) through the NVML libpmem library.
>=20
> libpmem
>=20
> Read and write using mmap I/O to a file on a filesystem mounted with DAX =
on a persistent memory device through the NVML libpmem library.
>=20
> =EF=BF=BD
>=20
> dl560g10spmem01:/var/work/fio-3.2 # /usr/local/bin/fio --version
>=20
> fio-3.2
>=20
> dl560g10spmem01:/var/work/fio-3.2 # /usr/local/bin/fio --enghelp
>=20
> Available IO engines:
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD cpuio
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD mmap
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD sync
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD psync
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD vsync
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD pvsync
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD pvsync2
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD null
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD net
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD netsplice
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD =EF=BF=BD=EF=BF=BDftruncate
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD filecreate
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD posixaio
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD falloc
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD e4defrag
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD splice
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD mtd
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD sg
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD binject
>=20
> dl560g10spmem01:/var/work/fio-3.2 # ll /dev|grep dax
>=20
> crw-------=EF=BF=BD 1 root root=EF=BF=BD=EF=BF=BD=EF=BF=BD 243,=EF=BF=BD=
=EF=BF=BD 0 Nov 25 00:12 dax0.0
>=20
> dl560g10spmem01:/var/work/fio-3.2 # ll /dev|grep pmem
>=20
> brw-rw----=EF=BF=BD 1 root disk=EF=BF=BD=EF=BF=BD=EF=BF=BD 259,=EF=BF=BD=
=EF=BF=BD 2 Nov 25 00:35 pmem1
>=20
> brw-rw----=EF=BF=BD 1 root disk=EF=BF=BD=EF=BF=BD=EF=BF=BD 259,=EF=BF=BD=
=EF=BF=BD 0 Nov 25 00:12 pmem2
>=20
> brw-rw----=EF=BF=BD 1 root disk=EF=BF=BD=EF=BF=BD=EF=BF=BD 259,=EF=BF=BD=
=EF=BF=BD 1 Nov 25 00:12 pmem3
>=20
> dl560g10spmem01:/var/work/fio-3.2 # /usr/local/bin/fio=20
> --filename=3D/dev/dax0.0=EF=BF=BD --direct=3D1 --rw=3Drandrw --refill_buf=
fers=20
> --norandommap --randrepeat=3D0 --ioengine=3Ddev-dax=20
> --bssplit=3D4k/4:8k/7:16k/7:32k/15:64k/65:128k/1:256k/1 --rwmixread=3D5=20
> --iodepth=3D1 --numjobs=3D16 --runtime=3D180 --group_reporting=20
> --name=3D4-rand-rw-3xx
>=20
> fio: engine dev-dax not loadable
>=20
> fio: failed to load engine
>=20
> dl560g10spmem01:/var/work/fio-3.2 #
>=20
> =EF=BF=BD
>=20
> I can't access to the 3 persistent memory engines above.
>=20
> =EF=BF=BD
>=20
> May you please help me with loading these engines.
>=20
> =EF=BF=BD
>=20
> =EF=BF=BD
>=20
> *Anton Gavriliuk*
>=20
> Critical Support
>=20
> Performance Engineering
>=20


--
Jens Axboe

