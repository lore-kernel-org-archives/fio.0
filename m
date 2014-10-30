Return-Path: <d.ketor@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5450FA47.2030203@kernel.dk>
References: <5449BBB3.7090109@catalyst.net.nz> <CAM9_UU9j2erdGT5kqKi_+5z5ERFMPO1hHwMk8kaFjLkGm-zp-g@mail.gmail.com>
 <544E6330.1000202@kernel.dk> <544E63EA.1010204@kernel.dk> <CAM9_UU-35i9uRu9EDQSM-b7CjmxrKYV2Gz8ocrykOYk+2q++hw@mail.gmail.com>
 <544E6691.106@kernel.dk> <CAM9_UU9_ZHtwv=31DyxkAmog7XJbthiRXi5n+Y0Cfxj4qm3bGQ@mail.gmail.com>
 <544E6A8D.1040608@kernel.dk> <CAM9_UU8x2uZZUWaPPoy+LHmUhC_3sqKZ9GPsEqDwKUkprg4kdQ@mail.gmail.com>
 <544EC05D.7040807@catalyst.net.nz> <544EC7F1.6010900@kernel.dk>
 <544ED37D.6060800@catalyst.net.nz> <CAM9_UU8MHdj+mjAWBziETxPDnwTt0JBuHrQp2Fu9YtF=msae3w@mail.gmail.com>
 <79432849-2F58-4738-82E1-E4D8AB10A6AE@kernel.dk> <CAM9_UU9G5vQ68UxMakte-Wb5B9_KBo24ov7=hNHpYqEtko2nQg@mail.gmail.com>
 <544FB2F2.2060703@kernel.dk> <CAM9_UU_o8kS1wJnDKTvd8+qkm9=93yfW3THr_8ni8C+5=TH6tg@mail.gmail.com>
 <544FCDBD.7070106@kernel.dk> <CAM9_UU-gyExbAEo608vGnjqBk56A_VRZc44HkywUuLmXoEZ4Cg@mail.gmail.com>
 <CAM9_UU8=MtUnQiembBfr8YQiDOD7TNey=mp8_H6gySenRVHy6A@mail.gmail.com> <5450FA47.2030203@kernel.dk>
From: Ketor D <d.ketor@gmail.com>
Date: Thu, 30 Oct 2014 10:50:53 +0800
Message-ID: <CAM9_UU-BWHSk713O9v9RuZd1PRfTfG-Vq9nox0YQO3MhV06YEA@mail.gmail.com>
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

The current code runs good!

Test Conf: jobs=1 iodepth=1 bs=4k

if busy_poll = 1, IOPS is 38989.
if busy_poll = 0, IOPS is 33031.

And busy_poll=0 test result looks no difference from the old code than
do not have sorted events wait.



2014-10-29 22:31 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
> On 2014-10-29 01:15, Ketor D wrote:
>>
>> Hi, Jens,
>>
>> There is cmdline parse bug in the fio rbd test.
>>
>> I have fixed this and create a pull request on the github.
>>
>> Please review.
>>
>> After fix the bugs, the fio test can run.
>
>
> I merged your two pull requests (thanks!) and committed a polished variant
> of the sort patch. Ketor and Mark, would you mind both running a quick
> benchmark on the current -git head?
>
> --
> Jens Axboe
>

