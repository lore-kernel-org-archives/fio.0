Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] Use in-place path separator "/" for Linux specific
 code
References: <1469804760-17333-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bcf4ea16-f7a0-8a8b-e04c-7a7d4f90e03a@kernel.dk>
Date: Fri, 29 Jul 2016 09:02:47 -0600
MIME-Version: 1.0
In-Reply-To: <1469804760-17333-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 07/29/2016 09:05 AM, Tomohiro Kusumi wrote:
> diskutil,cgroup,blktrace related code fully depend on Linux kernel,
> so sprintf variants can use in-place path separator "/" instead of
> FIO_OS_PATH_SEPARATOR.
>
> In fact these Linux specific files are mix of two types within the
> same file depending on who wrote them, where they were originally
> using "/".

Thanks, applied this and the other 3.

-- 
Jens Axboe


