Return-Path: <fio-owner@vger.kernel.org>
Received: from web55002.mail.re4.yahoo.com ([206.190.58.136]:30863 "HELO
	web55002.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753409Ab0AEBxI convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Mon, 4 Jan 2010 20:53:08 -0500
Message-ID: <31699.35262.qm@web55002.mail.re4.yahoo.com>
Date: Mon, 4 Jan 2010 17:53:05 -0800 (PST)
From: john smith <whalajam@yahoo.com>
Subject: Re: io scheduler merges control
In-Reply-To: <1262615647.3908.3.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: fio@vger.kernel.org

Alan,

I've tried 'echo "1"> /sys/block/<dsf>/queue/nomerges' but fio/sequential-r=
eads merges still occur and apparently they are only the simple ones that c=
an't be disabled.

1) What can I change in the kernel to disable ALL the merges (including the=
 simple ones)?
(I tried setting iosched_cfq.ops.elevator_merge_fn, elevator_merged_fn, ele=
vator_merge_req_fn, elevator_allow_merge_fn =3D 0 but still fio reported me=
rges)

2) One other question I have is why one driver benefits of the io scheduler=
 merges and the other doesn't?=20
(Note that HDD's don't have any other io activity - aside from fio - and bo=
th are doing the same 512B sequential reads)

3) The third question is why the number of fio reported "merge"(s) is great=
er than the number of the "ios"?

thanks,
John

--- On Mon, 1/4/10, Alan D. Brunelle <Alan.Brunelle@hp.com> wrote:

> From: Alan D. Brunelle <Alan.Brunelle@hp.com>
> Subject: Re: io scheduler merges control
> To: "john smith" <whalajam@yahoo.com>
> Cc: fio@vger.kernel.org
> Date: Monday, January 4, 2010, 6:34 AM
> On Thu, 2009-12-24 at 11:12 -0800,

> john smith wrote:
> > IOPS-reported numbers for a test vary (more than 30%
> in my case) from one run to another depending on kernel io
> scheduler merges (reported in "Disk
> stats/merges=3Dreads/writes") making it hard to
> measure/compare performance of block drivers, for instance.
> >=20
> > I don't see any way to turn off kernel io scheduler
> merges (cfq or others)
> > and I'd ask if you would consider adding support for
> it, disabling the merges per individual device, using sys-fs
> maybe?
> >=20
> > If you do, adding an option to fio for controlling the
> merges would be useful too,
> >=20
> > thanks,
> > John
>=20
> Hi John -=20
>=20
> FYI: there is /sys/block/*/queue/nomerges - when set to one
> ('echo 1
> > /sys/block/<dsf>/queue/nomerges) - a lot of the
> merging attempts are
> not performed. [Note, _some_ simple merge attempts _are_
> still attempted
> regardless of its setting...]
>=20
> Regards,
> Alan
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe
> fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=EF=BF=BD http://vger.kernel.org/majordomo-info.html
>=20


     =20
