Return-Path: <axboe@kernel.dk>
Subject: Re: Bug using ramp_time shows cpu over 100%
References: <3ccceea7625d474b8afd2a6f6a7ab0ef@BOWEX36-B.micron.com>
 <566796DC.2040308@kernel.dk>
 <a343b7251eb54dae85f0f85e858ee19c@BOWEX36-B.micron.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5668438A.8050909@kernel.dk>
Date: Wed, 9 Dec 2015 08:06:50 -0700
MIME-Version: 1.0
In-Reply-To: <a343b7251eb54dae85f0f85e858ee19c@BOWEX36-B.micron.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Deyoung Hong (dhong)" <dhong@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/09/2015 02:56 AM, Deyoung Hong (dhong) wrote:
> Sorry, not sure how I made that mistake (didn't even check my email response).
> I ran various fio versions (including the latest Download ZIP) and thought I checked and saw cpu way over 100%.

No worries.

> It now looks like my custom engine does not run  with the latest fio code anymore.

How so? We haven't had any changes in that area, and the other IO 
engines haven't needed an update for a long time. Maybe you just need to 
recompile it, if structure sizes changed.

In general, I'd recommend submitting your IO engine so it can be carried 
in fio proper.

-- 
Jens Axboe


