Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] pvsync2: Make hipri option probabilistic
References: <1501110306-8531-1-git-send-email-sbates@raithlin.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4bcff119-bff0-3763-f9ca-a208e4b493a0@kernel.dk>
Date: Wed, 26 Jul 2017 20:17:25 -0600
MIME-Version: 1.0
In-Reply-To: <1501110306-8531-1-git-send-email-sbates@raithlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: sbates@raithlin.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 07/26/2017 05:05 PM, sbates@raithlin.com wrote:
> From: Stephen Bates <sbates@raithlin.com>
> 
> Allow the user to set the probability of a pvsync2 IO being high
> priority. This allows the user to investigate performance when there
> is a mix of higher and lower priority IO.

You are potentially breaking existing scripts with this change. If
someone currently has:

hipri=1

in their job file, it'll work fine. After this change, it'll be 1%
polled IO.

-- 
Jens Axboe


