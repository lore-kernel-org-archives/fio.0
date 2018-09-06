Return-Path: <axboe@kernel.dk>
Subject: Re: examples .job vs .fio, and the fusion-aw-sync ioengine
References: <99c83ad8-ac18-363c-30cc-48f42361f1bd@bluestop.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f54e502e-16fc-ba39-8bed-bd8a50a36ba1@kernel.dk>
Date: Thu, 6 Sep 2018 14:23:43 -0600
MIME-Version: 1.0
In-Reply-To: <99c83ad8-ac18-363c-30cc-48f42361f1bd@bluestop.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Rebecca Cran <rebecca@bluestop.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 9/6/18 2:20 PM, Rebecca Cran wrote:
> Hi,
> 
> 
> I noticed a couple of things when taking a look at the FIO build recently.
> 
> First is that there are some example files named "*.job" instead of 
> "*.fio" (e.g. fio-rand-read.job) - was that deliberate?

Not deliberate, I think they should all be named .fio

> Secondly, I was wondering if it's time to remove the fusion-aw-sync 
> ("Fusion-io atomic engine") ioengine? My understanding is that it was 
> never widely adopted since being introduced around 2013.

Yeah let's kill it, it never really went anywhere.

-- 
Jens Axboe


