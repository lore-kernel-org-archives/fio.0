Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fio: fix ignore_error regression
References: <20160203232302.GA4500@localhost.localdomain>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56B29464.5060501@kernel.dk>
Date: Wed, 3 Feb 2016 16:59:32 -0700
MIME-Version: 1.0
In-Reply-To: <20160203232302.GA4500@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Eric Whitney <enwlinux@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/03/2016 04:23 PM, Eric Whitney wrote:
> Commit e9d512d8e7d2 introduced a regression affecting handling for
> the ignore_error parameter.  The common code for io_u event handling
> pulled from do_io() and do_verify() into io_queue_event() does not
> check for and process errors that are to be ignored in the main I/O
> path as I/Os are completed.  Prior to that commit, do_io() called
> break_on_this_error() to handle that case.
>
> The change causes fio to return a non-zero exit status after
> encountering an error it should ignore while performing I/O, even
> though the job does run to completion. This regression causes
> failures for some fstests that use fio, including ext4/302, ext4/303,
> and generic/300.
>
> This patch restores the original error handling behavior.

Thanks Eric, good catch! Applied.

-- 
Jens Axboe


