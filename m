Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:45919 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZDVRkn (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 Apr 2009 13:40:43 -0400
Date: Wed, 22 Apr 2009 19:40:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Recent changes
Message-ID: <20090422174041.GZ4593@kernel.dk>
References: <20090422054614.GT4593@kernel.dk> <622307.79920.qm@web63807.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <622307.79920.qm@web63807.mail.re1.yahoo.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Girish Satihal <girish.satihal@yahoo.com>
Cc: fio@vger.kernel.org

On Wed, Apr 22 2009, Girish Satihal wrote:
> Hi Jens,
> Running the fio on the partition mounted with filesystem was the
> intention to=EF=BF=BDcompare the functinality of fio with other performan=
ce
> benchmarking tool called IOmeter which is used for Windows. We use two
> different performance test tools, one is IOmeter for Windows and fio
> for Linux.=20

OK, but that doesn't make a lot of sense. The file system is going to be
very unhappy if you scribble random data to the device while it is
mounted. So either you should keep the device unmounted and run the test
on the raw device (or partition), OR you mount the device and run the
tests on files hosted on that device. With fio, that would either be:

filename=3D/dev/cciss/c0d0p1

OR

directory=3D/where/c0d0p1/is/mounted

> Also, recently we got a customer issue who had very bad performance
> numbers for the test they conducted on ext2 filesystem and wanted us
> to try the same. They dont use fio. They have thier=EF=BF=BDown propriete=
ry
> tool for performance measure. So it was just an investigation for us
> to run fio=EF=BF=BDon partition with filesystem instead of keep it
> raw.=EF=BF=BDSince we did not find any problem with=EF=BF=BDRandom Writes=
 but only
> problem with Seqential Writes thought of reporting to you and get the
> solution.

Thanks for reporting, you should always do that. I'm just trying to make
sense of what you want to accomplish.

> I am not bothered about the contents of the device. I was just wanted
> to compare the performance numbers between the Raw partition and the
> filesystem partition.

Typically the only difference will be if the device defaults to a small
block sizes. For buffered IO, one may find that the umounted partition
has 1kb default block size, while once it's mounted, the file system
will set the soft block size to it's own size (typically 4kb). So if
that makes your difference, you should just mount and immediately umount
the partition. That will accomplish the same, and you don't risk
panic'ing the file system due to it becoming corrupt while you run the
test.

> If you want I can look into the erroe messages=EF=BF=BDlogged in=EF=BF=BD=
dmesg.

Please do!

--=20
Jens Axboe

