Return-Path: <d.ketor@gmail.com>
MIME-Version: 1.0
In-Reply-To: <544FCDBD.7070106@kernel.dk>
References: <5449BBB3.7090109@catalyst.net.nz> <544B1D50.4010101@kernel.dk>
 <544B2C19.7070009@catalyst.net.nz> <544BF808.2090800@kernel.dk>
 <544C2371.1020403@catalyst.net.nz> <544E547C.30009@kernel.dk>
 <CAM9_UU9j2erdGT5kqKi_+5z5ERFMPO1hHwMk8kaFjLkGm-zp-g@mail.gmail.com>
 <544E6330.1000202@kernel.dk> <544E63EA.1010204@kernel.dk> <CAM9_UU-35i9uRu9EDQSM-b7CjmxrKYV2Gz8ocrykOYk+2q++hw@mail.gmail.com>
 <544E6691.106@kernel.dk> <CAM9_UU9_ZHtwv=31DyxkAmog7XJbthiRXi5n+Y0Cfxj4qm3bGQ@mail.gmail.com>
 <544E6A8D.1040608@kernel.dk> <CAM9_UU8x2uZZUWaPPoy+LHmUhC_3sqKZ9GPsEqDwKUkprg4kdQ@mail.gmail.com>
 <544EC05D.7040807@catalyst.net.nz> <544EC7F1.6010900@kernel.dk>
 <544ED37D.6060800@catalyst.net.nz> <CAM9_UU8MHdj+mjAWBziETxPDnwTt0JBuHrQp2Fu9YtF=msae3w@mail.gmail.com>
 <79432849-2F58-4738-82E1-E4D8AB10A6AE@kernel.dk> <CAM9_UU9G5vQ68UxMakte-Wb5B9_KBo24ov7=hNHpYqEtko2nQg@mail.gmail.com>
 <544FB2F2.2060703@kernel.dk> <CAM9_UU_o8kS1wJnDKTvd8+qkm9=93yfW3THr_8ni8C+5=TH6tg@mail.gmail.com>
 <544FCDBD.7070106@kernel.dk>
From: Ketor D <d.ketor@gmail.com>
Date: Wed, 29 Oct 2014 02:43:03 +0800
Message-ID: <CAM9_UU-gyExbAEo608vGnjqBk56A_VRZc44HkywUuLmXoEZ4Cg@mail.gmail.com>
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Yeah, the new wait strategy looks better.

I will test the patch soon.

2014-10-29 1:09 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
> On 2014-10-28 09:49, Ketor D wrote:
>>
>> Cannot get the new commited code from github now.
>> When I get the newest code, I will test.
>
>
> So here's another idea, applies on top of current -git. Basically it makes
> rbd wait for the oldest event, not just the first one in the array of all
> ios. This is the saner thing to do, as hopefully the oldest event will be
> the one to complete first. At least it has a much higher chance of being the
> right thing to do, than just waiting on a random event.
>
> Completely untested, so you might have to fiddle a bit with it to ensure
> that it actually works...
>
> --
> Jens Axboe
>

