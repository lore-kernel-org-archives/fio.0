Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46984 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbcHHPwD (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 8 Aug 2016 11:52:03 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcsf-fio@m.gmane.org>)
	id 1bWmqF-0005U0-2c
	for fio@vger.kernel.org; Mon, 08 Aug 2016 17:51:51 +0200
From: Saeed <ionictea@gmail.com>
Subject: Re: fio2gnuplot iop graphs not showing any output
Date: Mon, 8 Aug 2016 10:51:43 -0500
Message-ID: <noa9qf$grl$1@blaine.gmane.org>
References: <no67l1$l4$1@blaine.gmane.org> <1419631133.185964.1470640850603.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Erwan,

I used 'fio2gnuplot -p logfile -g' to generate the graphs.  Below are=20
the links to the output

log files: https://drive.google.com/open?id=3D0B4T-E3kb36RYSnYyd2c4aWl3VUU
actual graph generated:=20
https://drive.google.com/open?id=3D0B4T-E3kb36RYNkN5N0s4SHJrcEE



On 2016-08-08 07:20:50 +0000, Erwan Velu said:

> Hey,
>=20
> Can you please share with us the output file you get & the exact=20
> command line you use ?
>=20
> ----- Mail original -----
> De: "Saeed" <ionictea@gmail.com>
> =EF=BF=BD: fio@vger.kernel.org
> Envoy=EF=BF=BD: Dimanche 7 Ao=EF=BF=BDt 2016 04:50:10
> Objet: fio2gnuplot iop graphs not showing any output
>=20
> Is there any trick to getting fio2gnuplot to plot graphs with data for
> the iop logs?  Its not plotting any data for me currently even thgh the
> job averages about 100k iops in the results output and when it plots
> graphs gnuplot takes a very long time complete the job.
>=20
> [global]
> bs=3D4k
> ioengine=3Dlibaio
> iodepth=3D1
> size=3D5g
> direct=3D1
> filename=3D/dev/sde
> group_reporting
> numjobs=3D1
> per_job_logs=3D0
> write_bw_log=3Dbw
> write_iops_log=3Diops
> write_lat_log=3Dlat
> [read]
> rw=3Dread
> time_based=3D1
> runtime=3D180



