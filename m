Return-Path: <axboe@kernel.dk>
Message-ID: <53554C4D.60706@kernel.dk>
Date: Mon, 21 Apr 2014 10:50:21 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: runtime resets eta after countdown
References: <F73CB16A-07C1-4E7B-AD65-2045F7538FBF@gmail.com>
In-Reply-To: <F73CB16A-07C1-4E7B-AD65-2045F7538FBF@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Vasu Kulkarni <vasu.kulkarni@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/20/2014 11:08 AM, Vasu Kulkarni wrote:
> I see the following issue with my testing,  runtime always resets  eta to some higher number after countdown to 0
> 
> [randon_rw1]
> rw=randrw
> iodepth=8
> runtime=24
> ioengine=sync
> filename=/dev/mapper/mpathdeo:/dev/mapper/mpathdep
> 
> 
> or
> 
> [randon_rw1]
> rw=randrw
> iodepth=4
> runtime=24
> ioengine=sync
> filename=/dev/mapper/mpathdeo
> filename=/dev/mapper/mpathdep
> 
> both devices have 8 paths
> 
> mpathdep (23035376338373633) dm-7 FUSIONIO,ION LUN
> size=382G features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 alua' wp=rw
> |-+- policy='queue-length 0' prio=130 status=active
> | |- 0:0:1:5 sdk  8:160  active ready running
> | |- 1:0:1:5 sdl  8:176  active ready running
> | |- 1:0:0:5 sdaa 65:160 active ready running
> | `- 0:0:0:5 sdab 65:176 active ready running
> `-+- policy='queue-length 0' prio=1 status=enabled
>   |- 1:0:2:5 sdar 66:176 active ready running
>   |- 0:0:2:5 sdas 66:192 active ready running
>   |- 0:0:3:5 sdbi 67:192 active ready running
>   `- 1:0:3:5 sdbh 67:176 active ready running
> mpathdeo (26361306637636532) dm-6 FUSIONIO,ION LUN
> size=345G features='3 queue_if_no_path pg_init_retries 50' hwhandler='1 alua' wp=rw
> |-+- policy='queue-length 0' prio=130 status=active
> | |- 0:0:2:4 sdap 66:144 active ready running
> | |- 1:0:2:4 sdaq 66:160 active ready running
> | |- 1:0:3:4 sdbf 67:144 active ready running
> | `- 0:0:3:4 sdbg 67:160 active ready running
> `-+- policy='queue-length 0' prio=1 status=enabled
>   |- 1:0:1:4 sdj  8:144  active ready running
>   |- 0:0:1:4 sdi  8:128  active ready running
>   |- 0:0:0:4 sdy  65:128 active ready running
>   `- 1:0:0:4 sdz  65:144 active ready running
> 
> 
> runtime gradually decreases from 24 seconds to 1 seconds and then eta is reset back to 4hours,  if there is only one device the runtime works properly

Just tried this with current fio -git, and it seems to work fine. Counts
down from 24s to 0, then quits and displays results. Can you try and
download the latest snapshot and re-test?

http://brick.kernel.dk/snaps/fio-git-latest.tar.gz

-- 
Jens Axboe


