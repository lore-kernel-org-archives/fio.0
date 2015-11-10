Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36414 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbbKJRib convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 10 Nov 2015 12:38:31 -0500
Received: by lfs39 with SMTP id 39so2345653lfs.3
        for <fio@vger.kernel.org>; Tue, 10 Nov 2015 09:38:29 -0800 (PST)
Received: from [192.168.1.200] ([82.208.124.106])
        by smtp.gmail.com with ESMTPSA id m17sm714532lfb.16.2015.11.10.09.38.28
        for <fio@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 10 Nov 2015 09:38:28 -0800 (PST)
From: GrAnt <626542@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Subject: Aggregate values in logs
Message-Id: <94806C6A-BFE4-4B3A-BE4C-BAD60A294460@gmail.com>
Date: Tue, 10 Nov 2015 20:38:25 +0300
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello!

How to get aggregate values in log (_bw,_lat,_iops) files?
I use job with:

> group_reporting=3D1
> disable_lat=3D0
> disable_clat=3D0
> disable_slat=3D0
> numjobs=3D4
> per_job_logs=3D0

After benchmarking I=EF=BF=BDve got output (normal) with aggregate (for all=
 4 jobs):

read : io=3D148620MB, bw=3D253474KB/s, iops=3D247, runt=3D600404msec

But in logs there are stats only about one job, job_bw.log:

> 221, 3091, 0, 1048576
> 934, 68936, 0, 1048576
> 1477, 60457, 0, 1048576
> 2182, 60457, 0, 1048576
> 2714, 61709, 0, 1048576
> 3371, 74926, 0, 1048576
> 4130, 64844, 0, 1048576
> 4644, 63750, 0, 1048576
> 5184, 60794, 0, 1048576
> ..

May be I should multiply values in second column by 4? :) =20

Bye.
--
Regards, GrAnt

