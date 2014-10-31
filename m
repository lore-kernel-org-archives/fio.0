Return-Path: <mark.kirkwood@catalyst.net.nz>
Message-ID: <54534E48.8080505@catalyst.net.nz>
Date: Fri, 31 Oct 2014 21:54:32 +1300
From: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>
MIME-Version: 1.0
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
References: <5449BBB3.7090109@catalyst.net.nz> <CAM9_UU-35i9uRu9EDQSM-b7CjmxrKYV2Gz8ocrykOYk+2q++hw@mail.gmail.com> <544E6691.106@kernel.dk> <CAM9_UU9_ZHtwv=31DyxkAmog7XJbthiRXi5n+Y0Cfxj4qm3bGQ@mail.gmail.com> <544E6A8D.1040608@kernel.dk> <CAM9_UU8x2uZZUWaPPoy+LHmUhC_3sqKZ9GPsEqDwKUkprg4kdQ@mail.gmail.com> <544EC05D.7040807@catalyst.net.nz> <544EC7F1.6010900@kernel.dk> <544ED37D.6060800@catalyst.net.nz> <CAM9_UU8MHdj+mjAWBziETxPDnwTt0JBuHrQp2Fu9YtF=msae3w@mail.gmail.com> <79432849-2F58-4738-82E1-E4D8AB10A6AE@kernel.dk> <CAM9_UU9G5vQ68UxMakte-Wb5B9_KBo24ov7=hNHpYqEtko2nQg@mail.gmail.com> <544FB2F2.2060703@kernel.dk> <CAM9_UU_o8kS1wJnDKTvd8+qkm9=93yfW3THr_8ni8C+5=TH6tg@mail.gmail.com> <544FCDBD.7070106@kernel.dk> <CAM9_UU-gyExbAEo608vGnjqBk56A_VRZc44HkywUuLmXoEZ4Cg@mail.gmail.com> <CAM9_UU8=MtUnQiembBfr8YQiDOD7TNey=mp8_H6gySenRVHy6A@mail.gmail.com> <5450FA47.2030203@kernel.dk> <5451EC63.9070600@catalyst.net.nz> <CAM9_UU_NV+Ra+A0K5mES_A08HiaOEtMjuj2hxtGd4eW8cNoxWg@mail.gmail.com
 >
In-Reply-To: <CAM9_UU_NV+Ra+A0K5mES_A08HiaOEtMjuj2hxtGd4eW8cNoxWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ketor D <d.ketor@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 30/10/14 21:04, Ketor D wrote:
> Hi Mark,
>        Could you do a fio test in your env with the busy_poll=1 ?
> I am very interested in the busy_poll result. Thanks!
>

Sure:

blocksize k | head iops     |  head iops (busy_pool=1)
------------+---------------+--------------------------
4           |  11114        |  12608
128         |   4551        |   6422
1024        |   1195        |   1175
4096        |    320        |    316

So looks like the busy_pool=1 improves performance for small and mid 
range blocksizes but is a little slower at the larger end.

However there are a lot of variables here - I'm using iodepth=32 for 
instance, and altering that may change the pattern I'm seeing, also a 
system with more osd's may bring out different behaviours as it runs the 
fio client out of available cpu power in the smaller block sizes.

Regards

Mark



