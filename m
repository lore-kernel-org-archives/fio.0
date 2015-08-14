Return-Path: <axboe@kernel.dk>
Message-ID: <55CE0D64.6090907@kernel.dk>
Date: Fri, 14 Aug 2015 09:46:44 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: valgrind error "invalid read of size 4" in get_jobs_eta
References: <55BFADD9.2090303@cran.org.uk>
In-Reply-To: <55BFADD9.2090303@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 08/03/2015 12:07 PM, Bruce Cran wrote:
> Running fio built from git master is reporting the following error:
>
> ==26208== Invalid read of size 4
> ==26208==    at 0x429FF7: get_jobs_eta (eta.c:604)
> ==26208==    by 0x41B8B5: show_thread_status_json (stat.c:1080)
> ==26208==    by 0x420A80: __show_run_stats (stat.c:1579)
> ==26208==    by 0x451714: fio_backend (backend.c:2292)
> ==26208==    by 0x40CD3F: main (fio.c:54)
> ==26208==  Address 0x15197a3c is 124 bytes inside a block of size 125
> alloc'd
> ==26208==    at 0x4C2AE25: calloc (in
> /usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==26208==    by 0x429FCB: get_jobs_eta (eta.c:594)
> ==26208==    by 0x41B8B5: show_thread_status_json (stat.c:1080)
> ==26208==    by 0x420A80: __show_run_stats (stat.c:1579)
> ==26208==    by 0x451714: fio_backend (backend.c:2292)
> ==26208==    by 0x40CD3F: main (fio.c:54)
>

Can you check if current git shows this issue? If it does, please let me 
know how you are reproducing it.

-- 
Jens Axboe


