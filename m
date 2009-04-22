Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:50499 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbZDVFqP (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 Apr 2009 01:46:15 -0400
Date: Wed, 22 Apr 2009 07:46:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Recent changes
Message-ID: <20090422054614.GT4593@kernel.dk>
References: <20090421191545.GO4593@kernel.dk> <669351.35730.qm@web63805.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <669351.35730.qm@web63805.mail.re1.yahoo.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Girish Satihal <girish.satihal@yahoo.com>
Cc: fio@vger.kernel.org

On Tue, Apr 21 2009, Girish Satihal wrote:
> Hi Jens,
> The reason for saying ext3, is I run fdisk on /dev/cciss/c1d0 and created=
 a primary partition.
> =EF=BF=BD
> Then I created a ext3 filesystem on this partition by running mkefs and m=
ounted this partition on /mnt folder. Then I run fio on this partition.

You run fio on the partition, or on the mount point? Your fio job file
indicates that you run fio on the full device, not even just the
partition. This has _nothing_ to do with ext3. Irregardless of whether
you run fio on the partition or the device, your file system will be
hosed. Perhaps things go bad because ext3 turns your device read-only on
errors. Did you get any errors logged in dmesg?

> We earlier use to run fio on raw partition. But now we tried running fio =
on a partition which has ext3 filesystem.

Why would the content of the device matter?

> When I run fio on raw filesystem I dont get any errors for Sequential Wri=
tes, but when I run fio test on this ext3 filesystem then I am getting the =
errors for Sequential Writes=EF=BF=BDwhat I mentioned u earlier.

Lets back up a bit... What are you trying to test? Running fio on a
device/partition that is mounted with a file system is just a crazy
thing to do. Why would you do that?


> =EF=BF=BD
> Thanks,
> =EF=BF=BDGirish=EF=BF=BD
>=20
> --- On Wed, 4/22/09, Jens Axboe <jens.axboe@oracle.com> wrote:
>=20
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: Recent changes
> To: "Girish Satihal" <girish.satihal@yahoo.com>
> Cc: fio@vger.kernel.org
> Date: Wednesday, April 22, 2009, 12:45 AM
>=20
> On Tue, Apr 21 2009, Girish Satihal wrote:
> > Hi Jens,
> > I guess I did not understand your question for which I am very sorry.
>=20
> Don't apologize for that. But if there's something I write you
> don't
> understand, do just ask for an explanation.
>=20
> > As per my understanding I have sent you the job file which was
> > input file to fio for the performance testing.  As only the problem
> > with Seqential Writes, I have cut down the job file to only Write
> > parameters where the issue is being seen. The problem is seen with all
> > block size and IO depths of Sequential Writes.  Please let me know
> > if this would help you or still you arelooking for anything else.
>=20
> So my current question is why you are mentioning ext3? The test case you
> provided is reading and writing directly to the CCISS device, not a file
> inside a file system hosted on that device.
>=20
> Also, please try a make clean && make && make install in your
> fio
> directory. Sometimes things get hosed when updates are pulled, which may
> explain why yours is acting up.
>=20
> --=20
> Jens Axboe
>=20
>=20
>=20
>=20
>      =20
--=20
Jens Axboe

