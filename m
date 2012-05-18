Return-Path: <asias@redhat.com>
Message-ID: <4FB6583B.4050708@redhat.com>
Date: Fri, 18 May 2012 22:10:03 +0800
From: Asias He <asias@redhat.com>
MIME-Version: 1.0
Subject: Re: Why fio triggers reading of device serial number
References: <4FB5EA0D.7030402@redhat.com> <4FB5EC0B.7010304@redhat.com> <4FB61DD8.7020800@kernel.dk>
In-Reply-To: <4FB61DD8.7020800@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/18/2012 06:00 PM, Jens Axboe wrote:
> On 05/18/2012 08:28 AM, Asias He wrote:
>> Hi, List
>>
>> I noticed that fio triggers reading of device serial number when fio
>> starts (one read) and stops (lots of read). I was wondering if fio was
>> reading the sysfs attribute directly in fio's code,
>> e.g./sys/block/vda/serial, or it triggered something which make udevd to
>> read it.
>>
>> trace-cmd shows it seems udevd is reading:
>>
>> udevd-6856  [006] xxx: function:    dev_attr_show
>> udevd-6856  [006] xxx: function:        virtblk_serial_show
>>
>> Any ideas? Thanks.
>
> Probably mtime changing of the special file inode, causing some udev
> rule to attempt to re-read the id/serial. Fio doesn't read the serial
> number.

OK. Thanks, Jens.

-- 
Asias

