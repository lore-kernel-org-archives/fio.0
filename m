Return-Path: <mark.kirkwood@catalyst.net.nz>
Message-ID: <5449EEF1.1060407@catalyst.net.nz>
Date: Fri, 24 Oct 2014 19:17:21 +1300
From: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>
MIME-Version: 1.0
Subject: Re: fio rbd hang for block sizes > 1M
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk>
In-Reply-To: <5449E50E.7000808@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: "d.gollub@telekom.de >> Daniel Gollub" <d.gollub@telekom.de>, "xan.peng" <xanpeng@gmail.com>
List-ID: <fio@vger.kernel.org>

On 24/10/14 18:35, Jens Axboe wrote:
> CC'ing relevant parties, leaving email intact.
>

Note that the 'Killed' is because I killed the run - it hangs and 
appears to be non interruptable. I missed that when pasting, sorry!

>> $ fio read-test.fio     # attached
>> rbd_thread: (g=0): rw=read, bs=2M-2M/2M-2M/2M-2M, ioengine=rbd,
>> iodepth=32
>> fio-2.1.13-88-gb2ee7
>> Starting 1 process
>> rbd engine: RBD version: 0.1.8
>> Killed1 (f=1): [R(1)] [inf% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
>> 1158050441d:06h:59m:33s]


