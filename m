Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v5] engines: Add Network Block Device (NBD) support using
 libnbd.
References: <20190802161125.14199-1-rjones@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b2d1373f-bf3b-54a5-0f2f-d9e48cc3f05c@kernel.dk>
Date: Fri, 2 Aug 2019 10:42:40 -0600
MIME-Version: 1.0
In-Reply-To: <20190802161125.14199-1-rjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Richard W.M. Jones" <rjones@redhat.com>, fio@vger.kernel.org
Cc: eblake@redhat.com
List-ID: <fio@vger.kernel.org>

On 8/2/19 10:11 AM, Richard W.M. Jones wrote:
> This commit adds a new engine for testing Network Block Devices
> directly.  It requires libnbd (https://github.com/libguestfs/libnbd).
> 
> To see how to test nbdkit or qemu-nbd read examples/nbd.fio.

Applied, thanks.

Can you send a followup patch with some documentation in fio.1
and HOWTO? The nbd 'uri' option should be documented there as well,
under engine options.

-- 
Jens Axboe


