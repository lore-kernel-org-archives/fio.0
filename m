Return-Path: <d.ketor@gmail.com>
MIME-Version: 1.0
In-Reply-To: <544E6691.106@kernel.dk>
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk>
 <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com>
 <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz>
 <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz>
 <544B0C7F.4080109@catalyst.net.nz> <544B1D50.4010101@kernel.dk>
 <544B2C19.7070009@catalyst.net.nz> <544BF808.2090800@kernel.dk>
 <544C2371.1020403@catalyst.net.nz> <544E547C.30009@kernel.dk>
 <CAM9_UU9j2erdGT5kqKi_+5z5ERFMPO1hHwMk8kaFjLkGm-zp-g@mail.gmail.com>
 <544E6330.1000202@kernel.dk> <544E63EA.1010204@kernel.dk> <CAM9_UU-35i9uRu9EDQSM-b7CjmxrKYV2Gz8ocrykOYk+2q++hw@mail.gmail.com>
 <544E6691.106@kernel.dk>
From: Ketor D <d.ketor@gmail.com>
Date: Mon, 27 Oct 2014 23:45:01 +0800
Message-ID: <CAM9_UU9_ZHtwv=31DyxkAmog7XJbthiRXi5n+Y0Cfxj4qm3bGQ@mail.gmail.com>
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

The return code is 0 if success.I mod the code a bit and then run fio very well.
I think if you fix this bug, the path will be nearly pefect!!

ret = rbd_aio_get_return_value(fri->completion);
//printf("ret=%ld\n", ret);
//if (ret != (int) io_u->xfer_buflen) {
if (ret != 0) {
if (ret >= 0) {
io_u->resid = io_u->xfer_buflen - ret;
io_u->error = 0;
} else
io_u->error = ret;
}

2014-10-27 23:36 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
> On 10/27/2014 09:29 AM, Ketor D wrote:
>> I just found the aio_get_return and aio_release bug, then you fix it. So fast!
>>
>> But the test looks bad.
>>
>> The write bytes is always zero..........
>
> Looks like I need to setup a local test here, haven't run ceph/rbd
> before... Can you put a debug printf() in _fio_rbd_finish_aiocb() and
> dump what rbd_aio_get_return_value() returns?
>
> --
> Jens Axboe
>

