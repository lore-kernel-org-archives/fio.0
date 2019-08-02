Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3] engines: Add Network Block Device (NBD) support using
 libnbd.
References: <20190802110925.1724-1-rjones@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <85fba6db-530c-eaec-8be4-0cb17f7ade61@kernel.dk>
Date: Fri, 2 Aug 2019 07:30:21 -0600
MIME-Version: 1.0
In-Reply-To: <20190802110925.1724-1-rjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Richard W.M. Jones" <rjones@redhat.com>, fio@vger.kernel.org
Cc: eblake@redhat.com
List-ID: <fio@vger.kernel.org>

On 8/2/19 5:09 AM, Richard W.M. Jones wrote:
> libnbd also supports full asynchronous access.  However I couldn't
> work out how the ->getevents and ->event callbacks are supposed to
> work in fio engines.  If someone could take some time to explain to me
> how those are supposed to be used then I could get a much higher
> performance asynch engine working here.

fio calls ->getevents() when it needs to get some completions.
->getevents() returns the number of events completed. If that number is
4, for instance, then fio will call ->event() with 0..3 to retrieve the
io_u associated with each of those 4 completions.

Also see engines/skeleton_external.c, it is pretty well commented.

-- 
Jens Axboe


