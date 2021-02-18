Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhBRDeI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Feb 2021 22:34:08 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE6EC061574
        for <fio@vger.kernel.org>; Wed, 17 Feb 2021 19:33:28 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id b21so299990pgk.7
        for <fio@vger.kernel.org>; Wed, 17 Feb 2021 19:33:28 -0800 (PST)
Received: from [10.0.0.25] (adsl-76-214-108-127.dsl.ipltin.sbcglobal.net. [76.214.108.127])
        by smtp.gmail.com with ESMTPSA id c9sm3366439pjr.44.2021.02.17.19.33.26
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Feb 2021 19:33:26 -0800 (PST)
From: "Jerry (Jielei) Xu" <jerryxu@arista.com>
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_9C24368D-FC20-49E4-8B4E-DEFFB64BB818"
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Time to execute fio
Message-Id: <312D6D6E-7529-4482-8F01-520BD2857044@arista.com>
Date: Wed, 17 Feb 2021 19:33:25 -0800
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


--Apple-Mail=_9C24368D-FC20-49E4-8B4E-DEFFB64BB818
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hello everyone,

Recently we are running fio testing, starting with general job profile, =
like this one

jerryxu@jerryxu fio_profile % cat direct_io
[direct-io]
rw=3D${MODE}
bs=3D${BS}
size=3D${SIZE}
direct=3D1
ioengine=3Dlibaio
iodepth=3D64
ramp_time=3D10
directory=3D/mnt/flash/fio_testing

And run it like this, and repeat them.

-bash-4.2# date; BS=3D4k SIZE=3D1g MODE=3Drandrw fio =
/mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:09:38 UTC 2020
Run status group 0 (all jobs):
   READ: io=3D524368KB, aggrb=3D185946KB/s, minb=3D185946KB/s, =
maxb=3D185946KB/s, mint=3D2820msec, maxt=3D2820msec
  WRITE: io=3D524208KB, aggrb=3D185889KB/s, minb=3D185889KB/s, =
maxb=3D185889KB/s, mint=3D2820msec, maxt=3D2820msec

Tue Sep 22 01:11:00 UTC 2020
-bash-4.2#

We noticed the following effect: (it=E2=80=99s nvme flash in this test, =
and system is idle)

1. Without file, after each run, we remove the file, then run it again. =
We noticed there is long time spent on creating the file.
    - Do we have estimate on time to create the file?
    - Each run the time is different for creating file
    - If we use allocate=3Dnone,  will it impact performance of disk IO =
or not? If yes, then in what term?
2. With file created, (after first time run, don=E2=80=99t remove the =
file), we don=E2=80=99t have explicit file layout time now.
    - Each run the result is varied, this is idle machine, nothing else =
is run on it. Why is it different each time?
    - Also noticed that time from calling fio and exiting from fio is =
much longer than time spent on IO itself, for 1g/randrw, each run
      It took about 2-3 sec for IO, but whole time spent in fio itself =
is about 1 to 2 minutes, what=E2=80=99s the overhead here? Any estimate?
      (I suspect the same thing for above, but I can=E2=80=99t easily =
put time stamp after file layout.
3. For IO, we noticed some big difference so time, normally for =
1g/randrw, it=E2=80=99s about  2 to 3 sec, all of a sudden, there could =
be a run with only 200 to 300 msec IOs.
    What could be the course? Write amplification?

The test result is attached here.

Thanks

Jerry


--Apple-Mail=_9C24368D-FC20-49E4-8B4E-DEFFB64BB818
Content-Disposition: attachment;
	filename=result_w_o_file
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="result_w_o_file"
Content-Transfer-Encoding: 7bit

=============================== every run, remove the file, everytime layout file again ================
-bash-4.2# 
-bash-4.2# 
-bash-4.2# date; BS=4k SIZE=1g MODE=randrw fio /mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:09:38 UTC 2020
Run status group 0 (all jobs):
   READ: io=524368KB, aggrb=185946KB/s, minb=185946KB/s, maxb=185946KB/s, mint=2820msec, maxt=2820msec
  WRITE: io=524208KB, aggrb=185889KB/s, minb=185889KB/s, maxb=185889KB/s, mint=2820msec, maxt=2820msec

Tue Sep 22 01:11:00 UTC 2020
-bash-4.2# 
-bash-4.2# 
-bash-4.2# 
-bash-4.2# date; BS=4k SIZE=1g MODE=randrw fio /mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:11:21 UTC 2020
Run status group 0 (all jobs):
   READ: io=524884KB, aggrb=209283KB/s, minb=209283KB/s, maxb=209283KB/s, mint=2508msec, maxt=2508msec
  WRITE: io=523692KB, aggrb=208808KB/s, minb=208808KB/s, maxb=208808KB/s, mint=2508msec, maxt=2508msec

Tue Sep 22 01:12:37 UTC 2020
-bash-4.2# 
-bash-4.2# date; BS=4k SIZE=1g MODE=randrw fio /mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:13:31 UTC 2020
Run status group 0 (all jobs):
   READ: io=524388KB, aggrb=16003MB/s, minb=16003MB/s, maxb=16003MB/s, mint=32msec, maxt=32msec
  WRITE: io=524188KB, aggrb=15997MB/s, minb=15997MB/s, maxb=15997MB/s, mint=32msec, maxt=32msec

Tue Sep 22 01:14:46 UTC 2020
-bash-4.2# 
-bash-4.2# date; BS=4k SIZE=1g MODE=randrw fio /mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:16:10 UTC 2020
Run status group 0 (all jobs):
   READ: io=524660KB, aggrb=190370KB/s, minb=190370KB/s, maxb=190370KB/s, mint=2756msec, maxt=2756msec
  WRITE: io=523916KB, aggrb=190100KB/s, minb=190100KB/s, maxb=190100KB/s, mint=2756msec, maxt=2756msec

Tue Sep 22 01:17:35 UTC 2020
-bash-4.2# 
-bash-4.2# 
-bash-4.2# date; BS=4k SIZE=1g MODE=randrw fio /mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:18:52 UTC 2020
Run status group 0 (all jobs):
   READ: io=522820KB, aggrb=1001.2MB/s, minb=1001.2MB/s, maxb=1001.2MB/s, mint=510msec, maxt=510msec
  WRITE: io=525756KB, aggrb=1006.8MB/s, minb=1006.8MB/s, maxb=1006.8MB/s, mint=510msec, maxt=510msec

Tue Sep 22 01:20:06 UTC 2020
-bash-4.2# 
-bash-4.2# 

========================== with file already created, no file layout anymore ============

-bash-4.2# date; BS=4k SIZE=1g MODE=randrw fio /mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:21:48 UTC 2020
Run status group 0 (all jobs):
   READ: io=523660KB, aggrb=253957KB/s, minb=253957KB/s, maxb=253957KB/s, mint=2062msec, maxt=2062msec
  WRITE: io=524916KB, aggrb=254566KB/s, minb=254566KB/s, maxb=254566KB/s, mint=2062msec, maxt=2062msec

Tue Sep 22 01:22:18 UTC 2020
-bash-4.2# 
-bash-4.2# 
-bash-4.2# date; BS=4k SIZE=1g MODE=randrw fio /mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:22:39 UTC 2020
Run status group 0 (all jobs):
   READ: io=523668KB, aggrb=3502.8MB/s, minb=3502.8MB/s, maxb=3502.8MB/s, mint=146msec, maxt=146msec
  WRITE: io=524908KB, aggrb=3510.2MB/s, minb=3510.2MB/s, maxb=3510.2MB/s, mint=146msec, maxt=146msec

Tue Sep 22 01:23:05 UTC 2020
-bash-4.2# 
-bash-4.2# 
-bash-4.2# date; BS=4k SIZE=1g MODE=randrw fio /mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:23:17 UTC 2020
Run status group 0 (all jobs):
   READ: io=525516KB, aggrb=249532KB/s, minb=249532KB/s, maxb=249532KB/s, mint=2106msec, maxt=2106msec
  WRITE: io=523060KB, aggrb=248366KB/s, minb=248366KB/s, maxb=248366KB/s, mint=2106msec, maxt=2106msec

Tue Sep 22 01:23:44 UTC 2020
-bash-4.2# 
-bash-4.2# 
-bash-4.2# date; BS=4k SIZE=1g MODE=randrw fio /mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:24:08 UTC 2020
Run status group 0 (all jobs):
   READ: io=523724KB, aggrb=207087KB/s, minb=207087KB/s, maxb=207087KB/s, mint=2529msec, maxt=2529msec
  WRITE: io=524852KB, aggrb=207533KB/s, minb=207533KB/s, maxb=207533KB/s, mint=2529msec, maxt=2529msec

Tue Sep 22 01:24:35 UTC 2020
-bash-4.2# 
-bash-4.2# 
-bash-4.2# date; BS=4k SIZE=1g MODE=randrw fio /mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:24:57 UTC 2020
Run status group 0 (all jobs):
   READ: io=522552KB, aggrb=203723KB/s, minb=203723KB/s, maxb=203723KB/s, mint=2565msec, maxt=2565msec
  WRITE: io=526024KB, aggrb=205077KB/s, minb=205077KB/s, maxb=205077KB/s, mint=2565msec, maxt=2565msec

Tue Sep 22 01:25:24 UTC 2020
-bash-4.2# 
-bash-4.2# 
-bash-4.2# date; BS=4k SIZE=1g MODE=randrw fio /mnt/flash/fio_profile/direct_io | grep -A 3 "Run statu"; date
Tue Sep 22 01:27:12 UTC 2020
Run status group 0 (all jobs):
   READ: io=523392KB, aggrb=268681KB/s, minb=268681KB/s, maxb=268681KB/s, mint=1948msec, maxt=1948msec
  WRITE: io=525184KB, aggrb=269601KB/s, minb=269601KB/s, maxb=269601KB/s, mint=1948msec, maxt=1948msec

Tue Sep 22 01:27:39 UTC 2020
-bash-4.2# 
-bash-4.2# 


--Apple-Mail=_9C24368D-FC20-49E4-8B4E-DEFFB64BB818--

