Return-Path: <axboe@kernel.dk>
Date: Wed, 5 Feb 2014 11:27:18 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fix rand_seed mismatches in verify phase
Message-ID: <20140205182718.GG27534@kernel.dk>
References: <1391463077-14292-1-git-send-email-puthik@chromium.org>
 <CANEJEGuTmYm2k1M3BUmoxCVD99wCTyLjyRrT9HS=MMFBStrA5A@mail.gmail.com>
 <CANCcNXcmQNNcgFthc+JENyz3noH8HY2JsLjNG7ZBk5_soZGf_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANCcNXcmQNNcgFthc+JENyz3noH8HY2JsLjNG7ZBk5_soZGf_g@mail.gmail.com>
To: Puthikorn Voravootivat <puthik@chromium.org>
Cc: Grant Grundler <grundler@chromium.org>, FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

On Tue, Feb 04 2014, Puthikorn Voravootivat wrote:
> I tried to run the same test with fio 2.1.3 and saw the same error.
> This error always occurs when rw=read or randread and verify_backlog=1
> 
> Here is an example job file and error message.
> 
> Job file:
> [md5-sync-1-0-1-1-1]
> filename=test213/fio/md5-sync-1-0-1-1-1
> loops=1
> direct=0
> iodepth=1
> ioengine=sync
> verify=md5
> size=1m
> bs=4k
> rw=read
> verifysort=1
> verify_backlog=1
> 
> Error message:
> verify: bad magic header 869, wanted acca at file
> test213/fio/md5-sync-1-0-1-1-1 offset 585728, length 2290190

This is indeed breakage between 2.1.2 and 2.1.3. I ran a bisect on it,
it reveals:

20876c53b5d32f2da9049af5e7fb102133946981 is the first bad commit
commit 20876c53b5d32f2da9049af5e7fb102133946981
Author: Juan Casse <jcasse@chromium.org>
Date:   Mon Sep 16 09:22:10 2013 -0700

    Add condition to stop issuing io in do_io().
    
    Problem:
    When specifying iodepth > 1 while doing random async io
    without a random map (and using the default random generator), the
    main while loop in do_io() will issue extra io in the amount of io
    allowed to accumulate in the queue. For example, a job with size=24k
    and bs=8k will perform 4 io instead of the expected 3.
    
    Reason:
    The above behavior occurs because the while loop in do_io()
    will continue until the amount of "completed io" >= size, but io
    in the queue are not accounted for because they have not been
    completed by io_u_queued_complete().
    
    Exceptions:
    The above behavior does not manifest itself when:
        using random_generator=lfsr bacause lfsr knows when to stop
        generating, and get_io_u() inside the while loop returns NULL,
        breaking out of the loop.
        using random map because random map ensures that all blocks
        are hit, and after they are all hit, no more are generated.
    
    Proposed Solution:
    Stop while loop based on bytes issued instead of bytes completed.
    
    Signed-off-by: Juan Casse <jcasse@chromium.org>
    Reviewed-by: Grant Grundler <grundler@chromium.org>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>


-- 
Jens Axboe


