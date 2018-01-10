Return-Path: <fio-owner@vger.kernel.org>
Received: from m14-6.163.com ([220.181.14.6]:37922 "EHLO m14-6.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751694AbeAJLTV (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Jan 2018 06:19:21 -0500
Date: Wed, 10 Jan 2018 19:04:07 +0800
From: "shadow_lin" <shadow_lin@163.com>
Message-ID: <b0da74b.48c6.160dfbddb65.Coremail.shadow_lin@163.com>
Subject: Newbie question about fio
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi all,
=09I am new to fio and I have some question about how to use fio that I can=
't find on google=E3=80=82

=091.For read test fio will lay out a file for the test. how the file is ge=
nerated? will the block size or rw mode effect the file?
=09  Can I use 4m seq write test to generate file for the 4k rand read test=
 as long as the file size is the same or larger than the read test and the =
filename matches?

=09  If I ran fio on a block device(like /dev/sdb1),how would fio lay out d=
ata for read test?
       =09  In filesysterm i can change the filename to let fio lay out a n=
ew file,but I can't do that with a block device.
=09  I did some test to find that if I do some write test on a block device=
 then do read test if fio read beyond the data where write test has wrote,t=
he result would be inaccurate(speed be much faster than it should be)

=092.Fio can use filename and directory to set the where the test is perfor=
med. For multi-thread test fio will only generate one file in filename mode=
 but many files if in directory mode.

=09If I want to test against a block device I can only use filename to tell=
 fio where to perform the test

=09I can understand in directory mode that each thread will read or write t=
o a file and if i increase the numjobs to increase thread number
 =09the total filesize increased so the test will cost more time.

=09But in filename mode there is only one file and if I increase the numjob=
s to increase thread number the filesize won't change,
         but the test still cost more time(I thought differernt thread woul=
d write or read different part of the file so the time cost would be smalle=
r,but the test result showed that I am wrong), how each thread read or writ=
e to the same file?

=09for the same enviroment would the result be different for using filename=
 or directory?which one would be more accurate?or It fully depend on how I =
want to simluate the workload?

Thanks=20


2018-01-10
lin.yunfan
