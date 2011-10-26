Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.104.106.3]:39145 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab1JZHvk (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 26 Oct 2011 03:51:40 -0400
Message-ID: <4EA7BC01.2080500@kernel.dk>
Date: Wed, 26 Oct 2011 09:51:29 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix segfault with verify_async
References: <CAAUT-yMxJ5_m4VPKohuoLj7CHAqpdOT2_17NZ5F86GM-1+xW-A@mail.gmail.com>
In-Reply-To: <CAAUT-yMxJ5_m4VPKohuoLj7CHAqpdOT2_17NZ5F86GM-1+xW-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: fio@vger.kernel.org

On 2011-10-25 22:23, Steven Lang wrote:
> At some point the filename was added to the report on verify failures,
> however this broke verify_async, as the file pointer on the io_u is
> set to NULL before the verify thread sees the io_u.  The result is a
> segfault when there is a verify mismatch.
> 
> This patch changes the semantics of a deferred free (IO_U_F_FREE_DEF)
> to have already called put_file, but not set the file pointer to NULL.
>  This is safe to do as the file list is only freed after all the
> verify threads have been terminated.

Thanks Steven, good catch. Applied.

-- 
Jens Axboe

