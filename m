Return-Path: <d.ketor@gmail.com>
MIME-Version: 1.0
In-Reply-To: <544E6A8D.1040608@kernel.dk>
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk>
 <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com>
 <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz>
 <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz>
 <544B0C7F.4080109@catalyst.net.nz> <544B1D50.4010101@kernel.dk>
 <544B2C19.7070009@catalyst.net.nz> <544BF808.2090800@kernel.dk>
 <544C2371.1020403@catalyst.net.nz> <544E547C.30009@kernel.dk>
 <CAM9_UU9j2erdGT5kqKi_+5z5ERFMPO1hHwMk8kaFjLkGm-zp-g@mail.gmail.com>
 <544E6330.1000202@kernel.dk> <544E63EA.1010204@kernel.dk> <CAM9_UU-35i9uRu9EDQSM-b7CjmxrKYV2Gz8ocrykOYk+2q++hw@mail.gmail.com>
 <544E6691.106@kernel.dk> <CAM9_UU9_ZHtwv=31DyxkAmog7XJbthiRXi5n+Y0Cfxj4qm3bGQ@mail.gmail.com>
 <544E6A8D.1040608@kernel.dk>
From: Ketor D <d.ketor@gmail.com>
Date: Tue, 28 Oct 2014 00:20:39 +0800
Message-ID: <CAM9_UU8x2uZZUWaPPoy+LHmUhC_3sqKZ9GPsEqDwKUkprg4kdQ@mail.gmail.com>
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

V8 patch runs good.

The iops is 33032. If I just comment the usleep(100) in the master, I
can get iops 35245.
The CPU usage about the two test is same 120%.
So maybe this patch could be better!

Belong to the master, this patch is perfect enough!!


2014-10-27 23:53 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
> On 10/27/2014 09:45 AM, Ketor D wrote:
>> The return code is 0 if success.I mod the code a bit and then run fio very well.
>> I think if you fix this bug, the path will be nearly pefect!!
>>
>> ret = rbd_aio_get_return_value(fri->completion);
>> //printf("ret=%ld\n", ret);
>> //if (ret != (int) io_u->xfer_buflen) {
>> if (ret != 0) {
>> if (ret >= 0) {
>> io_u->resid = io_u->xfer_buflen - ret;
>> io_u->error = 0;
>> } else
>> io_u->error = ret;
>> }
>
> Weird, so it does not do partial completions I assume. Modified -v8 to
> take that into account, hopefully this just works out-of-the-box.
>
> What does the performance numbers look like for your sync test with this?
>
> --
> Jens Axboe
>

