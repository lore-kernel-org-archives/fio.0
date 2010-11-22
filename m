Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:60044 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173Ab0KVSj2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Nov 2010 13:39:28 -0500
Message-ID: <4CEAB8DB.7040304@fusionio.com>
Date: Mon, 22 Nov 2010 19:39:23 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Inappropriate ioctl error on Solaris with direct=1
References: <20101116131407.GY28050@sebastiankayser.de> <4CE3905E.7030709@fusionio.com> <20101122150628.GE28050@sebastiankayser.de>
In-Reply-To: <20101122150628.GE28050@sebastiankayser.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sebastian Kayser <sebastian@skayser.de>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2010-11-22 16:06, Sebastian Kayser wrote:
> * Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 2010-11-16 14:14, Sebastian Kayser wrote:
>>> I would like to provide fio packages for Solaris 10 (via opencsw.org).
>>> Building 1.44.2 worked fine, but when running fio with direct=1, it
>>> fails with an ioctl error. Is this to be expected?
>>>
>>> [...]
>>>
>>> # truss -ftopen,ioctl fio --name=test --size=1g --rw=write --filename=foo --runtime=60 --direct=1
>>> ...
>>> 2472:   ioctl(1, TCGETA, 0x08045814)                    = 0
>>> test: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
>>> 2472:   open64("/tmp/.fio_mutex.psaa1e", O_RDWR|O_CREAT|O_EXCL, 0600) = 8
>>> 2472:   open64("/tmp/.fio_mutex.qsaa1e", O_RDWR|O_CREAT|O_EXCL, 0600) = 9
>>> Starting 1 process
>>> test: Laying out IO file(s) (1 file(s) / 1024MB)
>>> 2472:   open64("foo", O_WRONLY|O_CREAT, 0644)           = 10
>>> 2473:   open64("foo", O_RDWR|O_CREAT, 0600)             = 7
>>> 2473:   ioctl(7, _ION('f', 76, 0), 0x00000001)          Err#25 ENOTTY
>>> fio: pid=2473, err=25/file:ioengines.c:404, func=fio_set_odirect, error=Inappropriate ioctl for device
>>
>> Not sure what the situation is on Solaris, but at least on Linux the
>> file system has to support direct IO. What file system do you have on
>> /tmp? Does it work if you place the files somewhere else?
> 
> The above test was carried out on ZFS. I now also tested on UFS where
> direct=1 work just fine. Thanks for the pointer, will go out and look
> into the ZFS + direct I/O details. Would it be asked too much to have
> fio emit an error message hinting towards the "FS needs to be direct I/O
> aware" caveat?

Yes it really should. It does on Linux, but it's in different places.
I'll add that to the Solaris bits as well.

>>> On a related note: do you guys have access to Solaris systems? If not, we
>>> do happily provide access to our build farm (Solaris 8/9/10, x86/SPARC,
>>> equipped with gcc3/4 and Sun Studio 11/12) for upstream mainainers [1]. So
>>> just let me know, if this sounds beneficial to you.
>>
>> I used to have a small T2 box on my desk that could boot into Solaris,
>> that's where I did the initial port and testing. But I don't anymore.
>> But to be honest, I would rather rely on someone trusted to tell me that
>> it works on platform XYZ, I just don't have the resources to run a full
>> battery of tests on all the platforms that fio supports every time I do
>> a release.
> 
> Understood. Feel free to let us know in case you find yourself in need
> of Solaris access anyway.

Thanks, will do.

-- 
Jens Axboe

