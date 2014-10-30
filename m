Return-Path: <axboe@kernel.dk>
Message-ID: <5451A8A3.8020106@kernel.dk>
Date: Wed, 29 Oct 2014 20:55:31 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
References: <5449BBB3.7090109@catalyst.net.nz> <544E63EA.1010204@kernel.dk> <CAM9_UU-35i9uRu9EDQSM-b7CjmxrKYV2Gz8ocrykOYk+2q++hw@mail.gmail.com> <544E6691.106@kernel.dk> <CAM9_UU9_ZHtwv=31DyxkAmog7XJbthiRXi5n+Y0Cfxj4qm3bGQ@mail.gmail.com> <544E6A8D.1040608@kernel.dk> <CAM9_UU8x2uZZUWaPPoy+LHmUhC_3sqKZ9GPsEqDwKUkprg4kdQ@mail.gmail.com> <544EC05D.7040807@catalyst.net.nz> <544EC7F1.6010900@kernel.dk> <544ED37D.6060800@catalyst.net.nz> <CAM9_UU8MHdj+mjAWBziETxPDnwTt0JBuHrQp2Fu9YtF=msae3w@mail.gmail.com> <79432849-2F58-4738-82E1-E4D8AB10A6AE@kernel.dk> <CAM9_UU9G5vQ68UxMakte-Wb5B9_KBo24ov7=hNHpYqEtko2nQg@mail.gmail.com> <544FB2F2.2060703@kernel.dk> <CAM9_UU_o8kS1wJnDKTvd8+qkm9=93yfW3THr_8ni8C+5=TH6tg@mail.gmail.com> <544FCDBD.7070106@kernel.dk> <CAM9_UU-gyExbAEo608vGnjqBk56A_VRZc44HkywUuLmXoEZ4Cg@mail.gmail.com> <CAM9_UU8=MtUnQiembBfr8YQiDOD7TNey=mp8_H6gySenRVHy6A@mail.gmail.com> <5450FA47.2030203@kernel.dk> <CAM9_UU-BWHSk713O9v9RuZd1PRfTfG-Vq9nox0YQO3MhV06YEA@mail.gmail.com>
In-Reply-To: <CAM9_UU-BWHSk713O9v9RuZd1PRfTfG-Vq9nox0YQO3MhV06YEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ketor D <d.ketor@gmail.com>
Cc: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-10-29 20:50, Ketor D wrote:
> Hi Jens,
>
> The current code runs good!
>
> Test Conf: jobs=1 iodepth=1 bs=4k
>
> if busy_poll = 1, IOPS is 38989.
> if busy_poll = 0, IOPS is 33031.
>
> And busy_poll=0 test result looks no difference from the old code than
> do not have sorted events wait.

Good to hear! I think we can safely say that we've pushed rbd as far as 
we can. At least on the fio side. Still appears to be some suboptimal 
parts of the librbd API. And the kernel rbd driver could definitely be 
improved a lot as well. Using busy_poll on the user side gets rid of a 
sleep/wakeup cycle at that end, but the kernel driver still punts and 
offloads any work item to a work queue...

Thanks for all your testing through this, really appreciated!

-- 
Jens Axboe


