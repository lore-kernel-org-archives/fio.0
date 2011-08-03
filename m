Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53553 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1HCUub convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 3 Aug 2011 16:50:31 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Measuring IOPS
Date: Wed, 3 Aug 2011 22:50:29 +0200
References: <201107291737.40463.Martin@lichtvoll.de> <x494o1yfdov.fsf@segfault.boston.devel.redhat.com> <201108032242.16778.Martin@lichtvoll.de> (sfid-20110803_224834_033116_69EEA2DA)
In-Reply-To: <201108032242.16778.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201108032250.30096.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: fio@vger.kernel.org

Am Mittwoch, 3. August 2011 schrieb Martin Steigerwald:
> Am Mittwoch, 3. August 2011 schrieben Sie:
> > Martin Steigerwald <Martin@lichtvoll.de> writes:
[...]
> Does using iodepth > 1 need ioengine=3Dlibaio? Let=EF=BF=BDs see the manp=
age:
>=20
>        iodepth=3Dint
>               Number  of I/O units to keep in flight against the
>               file. Note that increasing iodepth beyond  1  will
>               not affect synchronous ioengines (except for small
>               degress when verify_async is in use).  Even  async
>               engines  my  impose  OS  restrictions  causing the
>               desired depth not to be achieved.  This may happen
>               on   Linux  when  using  libaio  and  not  setting
>               direct=3D1, since buffered IO is not async  on  that
>               OS.  Keep  an  eye on the IO depth distribution in
>               the fio output to verify that the  achieved  depth
>               is as expected. Default: 1.
>=20
> Okay, yes, it does. I start getting a hang on it. Its a bit puzzling to
> have two concepts of synchronous I/O around:
>=20
> 1) synchronous system call interfaces aka fio I/O engine
>=20
> 2) synchronous I/O requests aka O_SYNC

But isn=EF=BF=BDt this a case for iodepth=3D1 if buffered I/O on Linux is=20
synchronous? I bet most regular applications except some databases use=20
buffered I/O.

--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
