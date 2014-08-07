Return-Path: <axboe@kernel.dk>
Message-ID: <53E3EF3E.8090204@kernel.dk>
Date: Thu, 07 Aug 2014 15:27:26 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Spurious verification mismatch?
References: <CALjAwxgC_7JRais+2ahfotYbJQ2ENwgE8KvnBF+2htPfVYEtvA@mail.gmail.com>
In-Reply-To: <CALjAwxgC_7JRais+2ahfotYbJQ2ENwgE8KvnBF+2htPfVYEtvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/05/2014 09:22 AM, Sitsofe Wheeler wrote:
> When trying to use fio from git
> ae7e055f755e77dfa71ae9040250ce8eec238721 (commit dated July 25th) the
> following line always fails at the same point:
> 
> ./fio --randseed=1 --ioengine=libaio --iodepth=1 --bs=64k
> --rw=randwrite --verify=meta --verify_backlog=50 --filename
> /dev/shm/foo --size=8M --time_based --runtime=1m --name=go
> 
> go: (g=0): rw=randwrite, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio, iodepth=1
> fio-2.1.11-10-gae7e
> Starting 1 process
> meta: verify failed at file /dev/shm/foo offset 6291456, length 65536
> fio: pid=55393, err=84/file:io_u.c:1806, func=io_u_queued_complete,
> error=Invalid or incomplete multibyte or wide character
> go: (groupid=0, jobs=1): err=84 (file:io_u.c:1806,
> func=io_u_queued_complete, error=Invalid or incomplete multibyte or
> wide character): pid=55393: Tue Aug  5 15:56:56 2014
> 
> Switching --loops=4 for --time_based --runtime=1m doesn't resulted in
> the same error.
> 
> Is this fio job malformed?

No, the job is fine, it's yet another case where the numberio
verification for meta fails miserably. Try current git, I committed a
one liner for it.


-- 
Jens Axboe


