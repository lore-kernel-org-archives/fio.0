Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] Add FIO_HAVE_FS_STAT/get_fs_free_size() support for
 NetBSD
References: <1476713861-8325-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3b4780c3-d995-fa7e-bf71-467d5e85fec3@kernel.dk>
Date: Mon, 17 Oct 2016 08:13:59 -0600
MIME-Version: 1.0
In-Reply-To: <1476713861-8325-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/17/2016 08:17 AM, Tomohiro Kusumi wrote:
> This commit is NetBSD version of 60f840a8 in 2015.
> This is the same as 60f840a8, as it uses POSIX statvfs.
>
> (Note that the function was renamed with _free in c08ad04c)

Applied this, and 2-4/4. Thanks!

-- 
Jens Axboe


