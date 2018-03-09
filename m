Return-Path: <fio-owner@vger.kernel.org>
Received: from m50-135.163.com ([123.125.50.135]:37755 "EHLO m50-135.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751188AbeCIG3Z (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Mar 2018 01:29:25 -0500
From: "Vaughan" <cxt9401@163.com>
References: <000801d3afb8$1ffb6a10$5ff23e30$@163.com> <CALjAwxgYcdTe68JPjo6fJHOYc=nD_Tb8Tyd995D1ONbQx3Lvjg@mail.gmail.com> <000101d3b070$6b165dd0$41431970$@163.com> <CALjAwxid8oNmnwg98UNghod6jV2cKW7X_N+JOGtJu4k0ghWihw@mail.gmail.com>
In-Reply-To: <CALjAwxid8oNmnwg98UNghod6jV2cKW7X_N+JOGtJu4k0ghWihw@mail.gmail.com>
Subject: =?utf-8?Q?=E7=AD=94=E5=A4=8D:_=E7=AD=94=E5=A4=8D:_How_to_ensure_split_veri?=
        =?utf-8?Q?fication_will_generate_the_same_?=
        =?utf-8?Q?configs_as_write_phase=3F?=
Date: Fri, 9 Mar 2018 14:11:56 +0800
Message-ID: <000001d3b76d$8c3f8e10$a4beaa30$@163.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: zh-cn
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Sitsofe Wheeler' <sitsofe@gmail.com>
Cc: 'fio' <fio@vger.kernel.org>

> It looks that way - it seems like thread_number is incremented for =
each job in
> get_new_job() so this would affect the random seeds generated in =
different sections of the same job file.
>  I think what you've pointed out will make jobs like:
>=20
> fio --stonewall --verify=3Dcrc32c --size=3D24k --bsrange=3D512-4k =
--filename=3D/tmp/fio.tmp --name=3Dwrite-phase --rw=3Drandwrite =
--do_verify=3D0 --name=3Dverify-phase --rw=3Drandread --do_verify=3D1
>=20
> fail because the random ordering of block sizes now depends on the job =
number too.
Yes, I agree with you. So the right way should be verify it with the =
original write jobfile and appending "--verify_only".

Can you further explain the usage of  --verify_state_save =
--verify_backlog --verify_backlog_batch options?

I need to split verify tera-byte size of data. According to the HOWTO of =
fio to avoid memory exhaustion, verify_backlog should be used. so I do =
the write job with "--verify_state_save=3D1 --verify_backlog=3D1 =
--verify_backlog_batch=3D10240" in cmd line and do a split verify by =
appending "--verify_only" with the same write command options. But it =
seems it just verify the 10240 ios, not the same size as write job.
Only if I verify without "--verify_state_save=3D1 --verify_backlog=3D1 =
--verify_backlog_batch=3D10240", it verify the whole size I write. I get =
the conclusion by run the write work and verify work with =
"write_iolog=3Dstr" and compare the iolog, and also "ios=3D" in "Disk =
stats" section of both fio output.

Another question about write process with "rw=3Drandwrite" and =
"bsrange=3D". If run it with "ioengine=3Dlibaio iodepth=3D16", will this =
async write get any overlap?

Thanks,
Vaughan


