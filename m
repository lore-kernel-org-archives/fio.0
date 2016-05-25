Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] Fix occasional hangs on mutexes
References: <1464102202-16724-1-git-send-email-jack@suse.cz>
 <1464102202-16724-2-git-send-email-jack@suse.cz>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5745FC91.5010408@kernel.dk>
Date: Wed, 25 May 2016 13:27:13 -0600
MIME-Version: 1.0
In-Reply-To: <1464102202-16724-2-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/24/2016 09:03 AM, Jan Kara wrote:
> When running xfstest generic/299 using fio on my test machine using
> ramdisk as a backing store, I have noticed that fio often hangs waiting
> for td->io_u_lock. After some debugging I have found out the reason is
> that mutexes are created as process-private by default and but this
> mutex is actually manipulated from several processes. The hang is not
> obvious immediately as the mutex is located in shared memory and thus
> while the locking is resolved in userspace, everything works as
> expected. Only once we use kernel futexes, the process is not properly
> woken up when futex is released.
>
> Fix the problem by marking all mutexes and conditional variables that
> are located in shared memory as shared.

Thanks Jan, applied both 1 and 2.

Would be nice to factor out the cv/mutex init code, so we don't have to 
essentially copy/paste it wherever we want to have process shared 
mutexes or cond vars.

-- 
Jens Axboe


