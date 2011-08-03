Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34221 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1HCUmS convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 3 Aug 2011 16:42:18 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Measuring IOPS
Date: Wed, 3 Aug 2011 22:42:16 +0200
References: <201107291737.40463.Martin@lichtvoll.de> <201108032131.36188.Martin@lichtvoll.de> <x494o1yfdov.fsf@segfault.boston.devel.redhat.com> (sfid-20110803_222903_776209_B9762BAA)
In-Reply-To: <x494o1yfdov.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201108032242.16778.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: fio@vger.kernel.org

Am Mittwoch, 3. August 2011 schrieben Sie:
> Martin Steigerwald <Martin@lichtvoll.de> writes:
> > - ioengine=3Dlibaio
> > - direct=3D1
> > - and then due to direct I/O alignment requirement: bsrange=3D2k-16k
> >=20
> > So I now also fully understand that ioengine=3Dsync just refers to the
> > synchronous nature of the system calls used, not on whether the I/Os
> > are issued synchronously via sync=3D1 or by circumventing the page
> > cache via direct=3D1
> >=20
> > Attached are results that bring down IOPS on read drastically! I
> > first let sequentiell.job write out the complete 2 gb with random
> > data and then ran the iops.job.
>=20
> If you want to measure the maximum iops, then you should consider
> driving iodepths > 1.  Assuming you are testing a sata ssd, try using a
> depth of 64 (twice the NCQ depth).

And additionally?

Does using iodepth > 1 need ioengine=3Dlibaio? Let=EF=BF=BDs see the manpag=
e:

       iodepth=3Dint
              Number  of I/O units to keep in flight against the
              file. Note that increasing iodepth beyond  1  will
              not affect synchronous ioengines (except for small
              degress when verify_async is in use).  Even  async
              engines  my  impose  OS  restrictions  causing the
              desired depth not to be achieved.  This may happen
              on   Linux  when  using  libaio  and  not  setting
              direct=3D1, since buffered IO is not async  on  that
              OS.  Keep  an  eye on the IO depth distribution in
              the fio output to verify that the  achieved  depth
              is as expected. Default: 1.

Okay, yes, it does. I start getting a hang on it. Its a bit puzzling to=20
have two concepts of synchronous I/O around:

1) synchronous system call interfaces aka fio I/O engine

2) synchronous I/O requests aka O_SYNC

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
