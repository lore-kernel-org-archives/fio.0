Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34142 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab1HCUNi convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 3 Aug 2011 16:13:38 -0400
Received: from merkaba.localnet (ppp-88-217-100-84.dynamic.mnet-online.de [88.217.100.84])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 9AF01197
	for <fio@vger.kernel.org>; Wed,  3 Aug 2011 22:13:37 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: On I/O engines
Date: Wed, 3 Aug 2011 22:13:36 +0200
MIME-Version: 1.0
Content-Type: Text/Plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201108032213.36977.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi!

In order to understand I/O engines better, I like to summarize what I=20
think to know at the moment. Maybe this can be a starting point for some=20
additional documentation:

=3D=3D=3D sync, psync, vsync =3D=3D=3D

- all these are using synchronous Linux (POSIX) system calls
- is used by regular applications
- synchronous just refers to the system call interface: i.e. the when the=20
system call returns to the application
- as far as I understand it returns when the I/O request is told to be=20
completed
- it does not imply synchronous I/O aka O_SYNC which is way slower and=20
enabled by sync=3D1
- thus it does not guarantee that the I/O has been physically written to=20
the underlying device (see open(2))
- thus is only guarantees that the I/O request has been dealt with? what=20
does this exactly mean?
- does it mean that this is I/O in the context of the process?
- it can be used with direct=3D1 to circumvent the pagecache


difference is the kind of system call used:
- sync uses read/write which read/write count bytes into from/to a buffer. =

Uses current file offset, changeable via fseek (or lseek, I did not find a =

manpage for fseek)
- psync uses pread/pwrite which read/write count bytes from given offset
- vsync uses readv/writev which read/writes count, i.e. mutiple buffers of =

given length in one call (struct iovec)

I am not sure on what performance difference to expect. I bet that=20
sync/psync should perform roughly the same.


=3D=3D=3D libaio =3D=3D=3D

- this uses Linux asynchronous I/O calls[1]
- it uses libaio for that
- who else uses libaio? It systems application that are near to the=20
system:

martin@merkaba:~> apt-cache rdepends libaio1
libaio1
Reverse Depends:
  fio
  qemu-kvm
  libdbd-oracle-perl
  zfs-fuse
  stressapptest
  qemu-kvm
  qemu-utils
  qemu-system
  multipath-tools
  ltp-kernel-test
  libaio1-dbg
  libaio-dev
  fio
  drizzle
  blktrace

- these calls allow applications to offload I/O calls to the background
- according to [1] this is only supported for direct I/O
- using anything else let it fall back to synchronous call behavior
- thus one sees this in combination with direct=3D1 in fio jobs
- does this mean that this is I/O outside the context of the process?


Question:
- what difference is between the following two other than the second one=20
seems to be more popular in example job files?
1) ioengine=3Dsync + direct=3D1
2) ioengine=3Dlibaio + direct=3D1

Current answer: It is that fio can issue further I/Os while the Linux=20
kernels handles the I/O.



=3D=3D=3D other I/O engines relevant to Linux =3D=3D=3D
There seem to be some other I/O engines relevant to Linux and mass storage =

I/O:

=3D=3D mmap =3D=3D
- maps the memory into files and uses memcpy
- used by quite some applications
- what else to note?

=3D=3D syslet-rw =3D=3D
- make regular read/write asynchronous
- where is this used?
- what else to note?

Any others?


Is what I wrote correct so far?


I think I=EF=BF=BDd like to write something up about the different I/O conc=
epts in=20
Linux, if such a document doesn=EF=BF=BDt exist yet.


[1] http://lse.sourceforge.net/io/aio.html

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
