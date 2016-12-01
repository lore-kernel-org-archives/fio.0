Return-Path: <jazeltq@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxia8JGF2uErqV3BdqLt7YTwZ=qwAKMmU2xJL1FnmcjvKg@mail.gmail.com>
References: <CAKZcxgdhYey+dbUN7T5mW=Ghfw34=OtNrocJxqDH8k4fQ1tTJw@mail.gmail.com>
 <CALjAwxjVK5v+JNo2Ww9m3cfwCyjiEMVzjdrYUpMsht2Q2j1AOA@mail.gmail.com>
 <CAKZcxgc2k=o2_kbYdFmxScxC2Zns+SKi++=rdxvwD2vGj83RZg@mail.gmail.com>
 <CAKZcxgfr_RfHD0XcDV0nMgFhU1nPNEzP0GciE-Unw-i-k3eaSw@mail.gmail.com>
 <CAKZcxgeXnostqxPAGi2ek1x+Tw7_CxrnjVzuy3QrJhwbERewnQ@mail.gmail.com> <CALjAwxia8JGF2uErqV3BdqLt7YTwZ=qwAKMmU2xJL1FnmcjvKg@mail.gmail.com>
From: Jaze Lee <jazeltq@gmail.com>
Date: Thu, 1 Dec 2016 18:03:27 +0800
Message-ID: <CAKZcxgeOzDaJ5vscKZGE2vH=YqEaOwzEyS7j2o6fj0EpvV3z1A@mail.gmail.com>
Subject: Re: fio assert
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hello,
  Dose this issue can be fixed? Or the only method is to use offload
to workaround.


2016-11-03 15:31 GMT+08:00 Sitsofe Wheeler <sitsofe@gmail.com>:
> On 3 November 2016 at 01:58, Jaze Lee <jazeltq@gmail.com> wrote:
>> Is there some news for this bug ?
>>
>> 2016-11-02 11:50 GMT+08:00 Jaze Lee <jazeltq@gmail.com>:
>>> I found this is not related with rbd engine. If use libaio, and test
>>> raw device. It will also happen.
>>> the fio script is
>>>
>>> [global]
>>> ioengine=3Dlibaio
>>> filename=3D/dev/sda
>>> direct=3D1
>>> group_reporting
>>> iodepth=3D32
>>> thread
>>>
>>> [fio_iops_test]
>>> description=3Dfio_iops_test
>>> runtime=3D600
>>> bs=3D4K
>>> rw=3Drandread
>>> write_lat_log=3Dcpuiops
>>> rate_iops=3D2000
>
> Can you make sure that you keep the fio mailing list CC'd on your
> mails rather than just replying to me directly? I'm just another fio
> user like you...
>
> I too can reproduce the problem with a slightly modified version of
> your job file:
> [fio_iops_test]
> ioengine=3Dlibaio
> direct=3D1
> filename=3D/dev/nullb0
> iodepth=3D2
> bs=3D4K
> rw=3Dread
> write_lat_log=3D/dev/null
> rate_iops=3D2000
>
> Within a second or two of running it the following assert is printed:
> fio: stat.c:2004: get_cur_log: Assertion `iolog->pending->nr_samples <
> iolog->pending->max_samples' failed.
>
> Doing any of the following stops the assertion from triggering:
> setting the iodepth to 1, removing the write_lat_log parameter,
> removing the rate_iops parameter or adding the io_submit_mode=3Doffload
> parameter.
>
> The problem seems to be due to the rate limiting somehow forcing iolog
> growth pressure but there is an inability to grow the iolog at the
> point we notice we need more room within stats. Normally the iolog
> growing can be deferred until next submission but I guess when you
> have to average over the samples in it (so as to work out the write
> latency for a given period) this is an issue because the logging areas
> aren't prepared for the change in size.
>
> You could hack the fio code to force a bigger default iolog size so it
> doesn't have to grow it later but a better way would be to use the
> io_submit_mode=3Doffload parameter
> (https://github.com/axboe/fio/blob/fio-2.15/HOWTO#L888 ) which
> decouples the submission from the completion/logging. Perhaps fio
> could put up a warning suggesting its use if you use rate_iops and one
> of the parameters that force averaging together but there could be
> other ways of triggering the same issue...
>
> --
> Sitsofe | http://sucs.org/~sits/



--=20
=E8=B0=A6=E8=B0=A6=E5=90=9B=E5=AD=90

