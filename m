Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20160727142537.GA26856@kernel.dk>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
 <1469626640-13335-4-git-send-email-kusumi.tomohiro@gmail.com> <20160727142537.GA26856@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Wed, 27 Jul 2016 23:44:24 +0900
Message-ID: <CAHndrBnUn+-6k_Rt4aYyP_h2Ao7dc+kNWoOgXDK5-Dt9e85-cg@mail.gmail.com>
Subject: Re: [PATCH 04/15] Add FIO_HAVE_BLKDEV_INVALIDATE_CACHE to selectively
 support pagecache invalidation
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

ah ok, sorry about that.
this option does cover regfiles..

2016-07-27 23:25 GMT+09:00 Jens Axboe <axboe@kernel.dk>:
> On Wed, Jul 27 2016, Tomohiro Kusumi wrote:
>> Most kernels either don't provide a way to invalidate the cache
>> or don't need to provide one as "block device" no longer exist
>> as a file type after being replaced by character device.
>> Linux (incl Android) is the only supported OS that actually does
>> something via ioctl.
>>
>> This commit adds FIO_HAVE_BLKDEV_INVALIDATE_CACHE. If this macro
>> is undefined, cache invalidation for block device isn't supported.
>> Only Linux supports it as mentioned above. It's better to do this
>> like other OS specific features, because having blockdev_invalidate_cache()
>> implementation which only pretends as if it has invalidated cache
>> (by returning either 0 or EINVAL) could be misleading for users.
>>
>> The drawback is this commit requires users to fix config files
>> (remove invalidate=) in order to use them on other platforms
>> that were portable till then.
>
> This seems to equate invalidate with only working on a block device,
> which is not true. And for files, it'll work fine on non-linux as well,
> using the fadvise functions.
>
> --
> Jens Axboe
>

