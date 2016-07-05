Return-Path: <fio-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60193 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbcGEWJT (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 5 Jul 2016 18:09:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1bKYWr-0005NX-Hq
	for fio@vger.kernel.org; Wed, 06 Jul 2016 00:09:17 +0200
Received: from cpe-24-55-26-223.austin.res.rr.com ([24.55.26.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Wed, 06 Jul 2016 00:09:17 +0200
Received: from ionictea by cpe-24-55-26-223.austin.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <fio@vger.kernel.org>; Wed, 06 Jul 2016 00:09:17 +0200
From: Saeed Tea <ionictea@gmail.com>
Subject: Re: fio2gnuplot issue
Date: Tue, 5 Jul 2016 17:09:10 -0500
Message-ID: <nlhb66$rd6$1@ger.gmane.org>
References: <nlha7f$a7q$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is with fio 2.12

On 2016-07-05 21:52:47 +0000, Saeed Tea said:

> I'm trying generate graphs with logs create by fio using fio2gnu and=20
> keep getting this error when generating graphs for iops or bandwidth:
>=20
> 1 files Selected with pattern '*_iops.log'
> |-> 4k.results_iops.log
>=20
> Running gnuplot Rendering
> "/usr/share/fio//math.gpm", line 25: no datablock named $1
>=20
> "/usr/share/fio//graph2D.gpm", line 25: no datablock named $1
>=20
>=20
> Rendering traces are available in the current directory
>=20
> Checking the directory listing only shows this file:
>=20
> $3.png
>=20
> Am I missing something in fio profile??=EF=BF=BD Here's a snippet:
>=20
> [global]
> rw=3Drandread
> ioengine=3Dposixaio
> iodepth=3D64
> size=3D10g
> direct=3D0
> buffered=3D1
> startdelay=3D5
> ramp_time=3D5
> runtime=3D20
> time_based
> disk_util=3D0
> clat_percentiles=3D0
> write_bw_log=3D4k.results
> write_iops_log=3D4k.results
> write_lat_log=3D4k.results
> per_job_logs=3D0



