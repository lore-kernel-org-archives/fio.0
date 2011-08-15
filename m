Return-Path: <zhu.yanhai@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4E45AF96.4070606@kernel.dk>
References: <1313175153-5355-1-git-send-email-yjhong@google.com> <4E45AF96.4070606@kernel.dk>
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Mon, 15 Aug 2011 11:56:08 +0800
Message-ID: <CAC8teKW=oXw5LSsH_4rVdOtCkunoSEDo-jS_FUbVgFgjnrzzjw@mail.gmail.com>
Subject: Re: [PATCH] stats: Add a function to report completion latency percentiles
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Yu-ju Hong <yjhong@google.com>, fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Eric Gouriou <egouriou@google.com>, Yu-Ju Hong <yuju.hong@gmail.com>
List-ID: <fio@vger.kernel.org>

Hi,
This commit breaks the calculation of iops.
Before this commit, the iops from group_report is 1467, see below:

chenyun@test023057.sqa.cm4 fio]$ sudo ./fio ~/iotest/readdev
thread16: (g=3D0): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodept=
h=3D1
...
thread16: (g=3D0): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodept=
h=3D1
fio 1.57
Starting 10 threads
Jobs: 10 (f=3D10): [rrrrrrrrrr] [100.0% done] [5929K/0K /s] [1447 /0
iops] [eta 00m:00s]
thread16: (groupid=3D0, jobs=3D10): err=3D 0: pid=3D19538
  read : io=3D176212KB, bw=3D5871.6KB/s, iops=3D1467 , runt=3D 30011msec
[cut here]


After this commit, the reported iops is 266, which is only one thread's out=
put,
not group_reporting, see below:

[chenyun@test023057.sqa.cm4 fio]$ sudo ./fio ~/iotest/readdev
thread16: (g=3D0): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodept=
h=3D1
...
thread16: (g=3D0): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodept=
h=3D1
fio 1.57
Starting 10 threads
Jobs: 10 (f=3D10): [rrrrrrrrrr] [100.0% done] [6033K/0K /s] [1473 /0
iops] [eta 00m:00s]
thread16: (groupid=3D0, jobs=3D10): err=3D 0: pid=3D19692
  read : io=3D351720KB, bw=3D1065.7KB/s, iops=3D266 , runt=3D330046msec
[cut here]

Thanks,
Zhu Yanhai


2011/8/13 Jens Axboe <axboe@kernel.dk>:
> On 2011-08-12 20:52, Yu-ju Hong wrote:
>> =C2=A0 =C2=A0 This patch introduces two new options:
>> =C2=A0 =C2=A0 1) Specifying --clat_percentiles enables the reporting of
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0completion latency percentiles.
>> =C2=A0 =C2=A0 2) --percentile_list allows the user to customize the
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0list of percentiles to report.
>
> Good feature, applied. The usage of done and !done for 'first' and
> 'curr' is a little odd, at least it could warrant a comment. But
> otherwise looks good.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>

