Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:51804 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897Ab1COU2U (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 15 Mar 2011 16:28:20 -0400
Message-ID: <4D7FCBDE.2080206@fusionio.com>
Date: Tue, 15 Mar 2011 21:28:14 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: memory caching
References: <C9A519EC.108B4%hussein@cscs.ch>
In-Reply-To: <C9A519EC.108B4%hussein@cscs.ch>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "N. Harake" <hussein@cscs.ch>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-03-15 13:36, N. Harake wrote:
>=20
> I noticed when I am using --sync=3D1, IOPS go down to 15K and throughput =
to
> 53MB (That=EF=BF=BDs horrible for the HW I am using), removing --sync I g=
ot 150K
> IOPS and almost 800MB, which make more sense. What does --sync does, and
> hope what I am doing should be enough to avoid any kind of memory caching=
..
>=20
> Regards
> H. N. Harake
>=20
> fio --name=3Djob --directory=3D/lvm --size=3D1G --iodepth=3D1 --sync=3D1
> --filesize=3D1G --direct=3D1 --numjobs=3D64 --bs=3D4096 --rw=3Drandwrite
> --group_reporting

If your goal is to maximize iops for testing, use the raw block device.
Use direct=3D1, and ioengine=3Dlibaio. Set depth large, ala:

--iodepth=3D128 --iodepth_batch_complete=3D8 --iodepth_batch_submit=3D8


--=20
Jens Axboe

