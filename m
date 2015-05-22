Return-Path: <axboe@kernel.dk>
Message-ID: <555E8165.6070608@kernel.dk>
Date: Thu, 21 May 2015 19:07:49 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Urgent problem while using Fio to test random write performance
References: <555D9487.3040104@cnnic.cn>	<555DEA42.8020209@nellans.org> <CALjAwxjz2qXivBru2HEch3Rsg_40rmZMvmD-fVknz6Ny1mrqqA@mail.gmail.com>
In-Reply-To: <CALjAwxjz2qXivBru2HEch3Rsg_40rmZMvmD-fVknz6Ny1mrqqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, David Nellans <david@nellans.org>
Cc: Nan WANG <wangnan@cnnic.cn>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/21/2015 02:39 PM, Sitsofe Wheeler wrote:
> On 21 May 2015 at 15:22, David Nellans <david@nellans.org> wrote:
>> you're randwrite to a raw partition. if you had a filesystem on that
>> partition you were trying to use, then well, your data is gone/corrupted.
>> without a filesystem on it, i'm not sure how you'd think that your disc
>> usage has become "100%" without some xgui widgit warning you, so seems
>> likely you did something you didn't mean to with regards to writing to
>> /dev/sdb1 directly
>>
>> if you use fio on devices/partitions with a filesystem, you need to have it
>> write to files or it will trash your filesystem
>
> It's unlikely but it wasn't mentioned which partition became 100%
> full. You should also make sure that /dev/sdb1 really exists as a
> block device (e.g. via using file) otherwise you'll make/fill a
> standard file called /dev/sdb1 .

That's true, though on modern systems that will fail since /dev is 
mounted on devtmpfs which doesn't support O_DIRECT. In general, 
allow_file_create=0 can be used to turn off file creation if you expect 
to run on block devices. This can avoid problems like this.


-- 
Jens Axboe


