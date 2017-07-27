Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] pvsync2: Make hipri option probabilistic
References: <1501110306-8531-1-git-send-email-sbates@raithlin.com>
 <4bcff119-bff0-3763-f9ca-a208e4b493a0@kernel.dk>
 <18CE30C5-51B1-498A-A6DA-51F6DACDD8A8@raithlin.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <911b448f-fd82-a53f-492c-c2ae2b47612a@kernel.dk>
Date: Wed, 26 Jul 2017 20:22:16 -0600
MIME-Version: 1.0
In-Reply-To: <18CE30C5-51B1-498A-A6DA-51F6DACDD8A8@raithlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Stephen Bates <sbates@raithlin.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 07/26/2017 08:20 PM, Stephen  Bates wrote:
> 
>> You are potentially breaking existing scripts with this change. If
>> someone currently has:
> 
>> hipri=1
> 
>> in their job file, it'll work fine. After this change, it'll be 1%
>> polled IO.
> 
> Fair point. How about I make it a float and use values between 0 and
> 1? That way existing scripts will continue to work.

That's kind of horrible from a usability point of view. Other percentage
options take 0..100. Since it's just an IO engine option, just add a
hipri_percentage or something option instead, which takes 0..100 as the
input.

-- 
Jens Axboe


