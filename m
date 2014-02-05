Return-Path: <axboe@kernel.dk>
Date: Wed, 5 Feb 2014 10:15:28 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fix rand_seed mismatches in verify phase
Message-ID: <20140205171528.GF27534@kernel.dk>
References: <1391463077-14292-1-git-send-email-puthik@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391463077-14292-1-git-send-email-puthik@chromium.org>
To: Puthikorn Voravootivat <puthik@chromium.org>
Cc: FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Grant Grundler <grundler@chromium.org>
List-ID: <fio@vger.kernel.org>

On Mon, Feb 03 2014, Puthikorn Voravootivat wrote:
> In verify phase, the rand_seed generated on replay does not match
> the written rand_seed.
> 
> Multiple problems are causing this:
> 1. In verify phase fio does not set io_u->rand_seed to compare with
>    hdr->rand_seed
> 2. In randrw scenario, fio log is stored in red-black tree in "sorted by LBA"
>    order.  Thus, it is imposible to replay the written order, or rather
>    generate the seeds again in the same order.
> 3. In write phase, the code currently will generate rand_seed, write data
>    and log rand_seed. When queuedepth > 1, it's possible the writes complete
>    in a different order than rand_seed was generated.  Thus when replaying
>    the log, the generated rand_seed might not match what was written.
> 4. verify_backlog option will start verification before all the data has been
>    written and it make rand_seed replay code broken with current design.
> 
> Proposed fixes:
> 1. Use of existing verify_state to generate verify header.
>    (and assumes this was the original intention of verify_state). And also
>    adds code to replay rand_seed in verify phase.
> 2. If verifysort option is not enabled, store the write log in a list instead
>    of the red-black tree. Otherwise, don't attempt to verify the rand_seed
>    in the header.
> 3. In write phase,  generate rand_seed, log rand_seed, write data. I.e. log
>    IO transactions in the order generated, not completed.
> 4. Don't verify rand_seed when verify_backlog is enabled.

Seems like a reasonable solution to it all. Thanks! I'll get this
applied.

-- 
Jens Axboe


