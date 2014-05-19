Return-Path: <axboe@kernel.dk>
Message-ID: <537A5CFE.4090800@kernel.dk>
Date: Mon, 19 May 2014 13:35:26 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fix a bug of rbd engine when specify invalidate=1 or fadvise_hint=1
References: <CA+8ZFngfLhzUopzPznyQ-ZwZgqMuDiEPhUpK5c20HkWNe0nz6w@mail.gmail.com>
In-Reply-To: <CA+8ZFngfLhzUopzPznyQ-ZwZgqMuDiEPhUpK5c20HkWNe0nz6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "xan.peng" <xanpeng@gmail.com>, daniel.gollub@gmail.com, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-05-19 11:38, xan.peng wrote:
> When specify invalidate=1 or fadvise_hint=1, fio will call
> posix_fadvise(2), which will return -EBADF and prevent fio librbd
> engine acting normally.
> Here is the call path: ... > td_io_open_file() >
> file_invalidate_cache() > __file_invalidate_cache() > posix_fadvise(fd
> = -1) > ...
>
> The patch work-around this problem by setting file type to
> FIO_TYPE_CHAR in fio_rbd_open().

Might be better to add a new type for this, like FIO_TYPE_SPECIAL or 
something. Otherwise we could risk running into other cases, where fio 
then thinks it really is a char device.

-- 
Jens Axboe


