Return-Path: <axboe@kernel.dk>
Date: Wed, 28 Oct 2015 13:16:04 +0900
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: FIO creating empty latency log files
Message-ID: <20151028041556.GB25598@kernel.dk>
References: <CAKPij3xg4=H0R506nT5gV7Lrz3Lpn_a3ML27F0ZNt6ws5svp-Q@mail.gmail.com>
 <562FE8E3.90106@kernel.dk>
 <563014DE.60400@kernel.dk>
 <56301736.1000302@kernel.dk>
 <CAP85WCBF-gq7O2odW7EVQL4uRAsrEjT2shO4Naa3CBKniFqK_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP85WCBF-gq7O2odW7EVQL4uRAsrEjT2shO4Naa3CBKniFqK_w@mail.gmail.com>
To: DoubleDensity <doubledense@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Tue, Oct 27 2015, DoubleDensity wrote:
> This worked! I am in your debt, it is extremely cool to have this
> operational now.
> 
> Please let me know if there is anything I may do to help test or
> validate this fix or otherwise repay the favor!

Glad it works! Just throw it through your regular testing, both things
that broke before and worked before. We just need more coverage testing,
that is all.

-- 
Jens Axboe


