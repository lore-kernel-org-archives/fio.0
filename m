Return-Path: <radha@google.com>
MIME-Version: 1.0
In-Reply-To: <20090219074712.GD30821@kernel.dk>
References: <66dfd3fe0902181512o5a88da43waaf09834bd6d37ac@mail.gmail.com>
	 <20090219074712.GD30821@kernel.dk>
Date: Thu, 19 Feb 2009 10:10:32 -0800
Message-ID: <66dfd3fe0902191010l64a2d915o973c0a3b486e0143@mail.gmail.com>
Subject: Re: Disabling verify when norandommap is given
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Yes, that makes sense for a randwrite operation.
But is it acceptable to allow norandommap with verify for
read/randomread only operations with no writes involved. The case Iam
specifically interested in is doing sequential writes followed by
sequential reads (with verify) and then randomaccess reads (with
verify). For a small enough block size on a large enough drive the
norandommap takes up too much memory.
Thanks
-radha

On Wed, Feb 18, 2009 at 11:47 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Feb 18 2009, Radha Ramachandran wrote:
>> Hi,
>> Is there a reason why there is a hard rule to disable verify when
>> norandommap option is also set?
>
> Without a map of the blocks that have been written already, you might
> overwrite full or partial blocks before you are done. That would cause
> verify to fail. See the 'norandommap' explanation in the HOWTO as well.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

