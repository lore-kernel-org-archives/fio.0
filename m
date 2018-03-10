Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] helper_thread: Initialize all helper_data members before
 using it
References: <20180310004622.5795-1-bart.vanassche@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e73248ca-0267-47d0-7676-aced6dd5aadf@kernel.dk>
Date: Fri, 9 Mar 2018 21:34:31 -0700
MIME-Version: 1.0
In-Reply-To: <20180310004622.5795-1-bart.vanassche@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/9/18 5:46 PM, Bart Van Assche wrote:
> This patch avoids that Valgrind reports the following:
> 
> ==10492== Thread 2:
> ==10492== Conditional jump or move depends on uninitialised value(s)
> ==10492==    at 0x480295: helper_thread_main (helper_thread.c:89)
> ==10492==    by 0x57B961A: start_thread (pthread_create.c:465)
> ==10492==    by 0x5CEC98E: clone (clone.S:95)

Applied, thanks.

-- 
Jens Axboe


