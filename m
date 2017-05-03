Return-Path: <axboe@kernel.dk>
Date: Wed, 3 May 2017 08:50:13 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/6] stat: change json+ output format so that instead of
 printing the raw clat data structure, use actual durations instead of array
 indices and print only bins with nonzero counts
Message-ID: <20170503145012.GA22842@kernel.dk>
References: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
 <23c62b4c-2aac-6a43-927f-69cfc036120a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23c62b4c-2aac-6a43-927f-69cfc036120a@gmail.com>
To: Vincent Fu <vincentfu@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Wed, May 03 2017, Vincent Fu wrote:
> Jens, can you review this patch series?
> 
> The json+ change (PATCH 1/6 and 2/6) was a request from a user and makes the
> output easier to use.
> 
> The other patches fix problems with resetting the latency counters when
> --latency-target is used (PATCH 4/6) and make sure some forgotten latency
> counters are transferred in client/server mode (PATCH 5/6). PATCH 6/6 is a
> cleanup. You can ignore PATCH 3/6.

Looks good to me, this got lost since it arrived while I was away on
vacation. I applied the series, skipping patch #3. Thanks Vincent!

-- 
Jens Axboe


