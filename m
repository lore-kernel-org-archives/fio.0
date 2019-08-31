Return-Path: <axboe@kernel.dk>
Subject: Re: io_uring engine -- sqthread_poll option can't work as implemented
References: <x49r254apvv.fsf@segfault.boston.devel.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6adaa1ad-93b6-48b1-6fe0-7a0cceab9eda@kernel.dk>
Date: Fri, 30 Aug 2019 21:18:39 -0600
MIME-Version: 1.0
In-Reply-To: <x49r254apvv.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/29/19 10:38 AM, Jeff Moyer wrote:
> Hi,
> 
> sqthread_poll requires registered files in order to work.  That's not
> implemented in fio, and I don't see how one would go about it (but I'm
> not all that familiar with fio's architecture).  We basically need all
> files to be opened before we can register them.  It looks to me as
> though the files are opened on demand, after the io engine is
> initialized.
> 
> Any suggestions?

Leftover from previously, when that requirement wasn't there... Using
it from fio would require a little bit of footwork, but it's not
impossible.

-- 
Jens Axboe


