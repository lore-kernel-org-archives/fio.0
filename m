Return-Path: <axboe@kernel.dk>
Message-ID: <544E547C.30009@kernel.dk>
Date: Mon, 27 Oct 2014 08:19:40 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk> <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com> <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz> <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz> <544B0C7F.4080109@catalyst.net.nz> <544B1D50.4010101@kernel.dk> <544B2C19.7070009@catalyst.net.nz> <544BF808.2090800@kernel.dk> <544C2371.1020403@catalyst.net.nz>
In-Reply-To: <544C2371.1020403@catalyst.net.nz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org
Cc: "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/25/2014 04:25 PM, Mark Kirkwood wrote:
> On 26/10/14 08:20, Jens Axboe wrote:
>> On 10/24/2014 10:50 PM, Mark Kirkwood wrote:
>>> On 25/10/14 16:47, Jens Axboe wrote:
>>>>
>>>> Since you're running rbd tests... Mind giving this patch a go? I don't
>>>> have an easy way to test it myself. It has nothing to do with this
>>>> issue, it's just a potentially faster way to do the rbd completions.
>>>>
>>>
>>> Sure - but note I'm testing this on my i7 workstation (4x osd's running
>>> on 2x Crucial M550) so not exactly server grade :-)
>>>
>>> With that in mind, I'm seeing slightly *slower* performance with the
>>> patch applied: e.g: for 128k blocks - 2 runs, 1 uncached and the next
>>> cached.
>>
>> Yeah, that doesn't look good. Mind trying this one out? I wonder if we
>> doubly wait on them - or perhaps rbd_aio_wait_for_complete() isn't
>> working correctly. If you try this one, we should know more...
>>
>> Goal is, I want to get rid of that usleep() in getevents.
>>
> 
> Testing with v3 patch applied hangs. I did wonder if we had somehow hit
> a new variant of the cache issue - so reran with it disabled in
> ceph.conf. Result is the same:
> 
> $ fio read-test.fio
> rbd_thread: (g=0): rw=read, bs=128K-128K/128K-128K/128K-128K,
> ioengine=rbd, iodepth=32
> fio-2.1.13-88-gb2ee7
> Starting 1 process
> rbd engine: RBD version: 0.1.8
> Jobs: 1 (f=1): [R(1)] [0.1% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta
> 01h:25m:15s]

There were, unfortunately, still two bugs left in -v3. I just posted an
updated one, please try that and see if it works for you.

-- 
Jens Axboe


