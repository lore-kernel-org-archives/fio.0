Return-Path: <mark.kirkwood@catalyst.net.nz>
Message-ID: <544F150D.1080003@catalyst.net.nz>
Date: Tue, 28 Oct 2014 17:01:17 +1300
From: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>
MIME-Version: 1.0
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
References: <5449BBB3.7090109@catalyst.net.nz> <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com> <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz> <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz> <544B0C7F.4080109@catalyst.net.nz> <544B1D50.4010101@kernel.dk> <544B2C19.7070009@catalyst.net.nz> <544BF808.2090800@kernel.dk> <544C2371.1020403@catalyst.net.nz> <544E547C.30009@kernel.dk> <CAM9_UU9j2erdGT5kqKi_+5z5ERFMPO1hHwMk8kaFjLkGm-zp-g@mail.gmail.com> <544E6330.1000202@kernel.dk> <544E63EA.1010204@kernel.dk> <CAM9_UU-35i9uRu9EDQSM-b7CjmxrKYV2Gz8ocrykOYk+2q++hw@mail.gmail.com> <544E6691.106@kernel.dk> <CAM9_UU9_ZHtwv=31DyxkAmog7XJbthiRXi5n+Y0Cfxj4qm3bGQ@mail.gmail.com> <544E6A8D.1040608@kernel.dk> <CAM9_UU8x2uZZUWaPPoy+LHmUhC_3sqKZ9GPsEqDwKUkprg4kdQ@mail.gmail.com> <544EC05D.7040807@catalyst.net.nz> <544EC7F1.6010900@kernel.dk> <544ED37D.6060800@catalyst.net.nz> <CAM9_UU8MHdj+mjAWBziETxPDnwTt0JBuHrQp2Fu9YtF=msae3w@mail.gmail.com>
In-Reply-To: <CAM9_UU8MHdj+mjAWBziETxPDnwTt0JBuHrQp2Fu9YtF=msae3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ketor D <d.ketor@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 28/10/14 16:23, Ketor D wrote:
> Hi Mark,
>        Wish you could test my patch.I get the best performance using this patch.
>
>

It is not clear cut for me (tested reads only):

blocksize k | v8 patched iops | Ketor patch iops | orig iops
------------+-----------------+------------------+-----------
4           | 12265           | 11930            |  11516
128         |  5800           |  7100            |   6550
1024        |  1193           |  1196            |   1248

Cheers

Mark

