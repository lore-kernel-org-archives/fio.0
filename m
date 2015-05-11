Return-Path: <axboe@kernel.dk>
Message-ID: <5550D6D3.9050803@kernel.dk>
Date: Mon, 11 May 2015 12:20:35 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Why Seperate Log Files?
References: <BLU406-EAS203C4EE266D87AD0F72049E0DB0@phx.gbl>
In-Reply-To: <BLU406-EAS203C4EE266D87AD0F72049E0DB0@phx.gbl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jon Tango <cheerios123@outlook.com>, 'Andrey Kuzmin' <andrey.v.kuzmin@gmail.com>
Cc: 'Sitsofe Wheeler' <sitsofe@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/10/2015 09:36 PM, Jon Tango wrote:
> When I use fio in 2.1.8 the write_iops_log command creates a singular log file, even with 8 workers. With fio in the latest versions, however, it creates eight separate log files. Is there a way to get fio to generate a log file for all 8 workers, instead of 8 separate files? That is untenable. I had to go back to 2.1.8 to get a useable output. It's not like the data outputs are very friendly anyway, but with one file at least that data can easily be parsed and worked with. With a different file for each worker it is just ridiculous.
> How do we get one output for all workers?
> It would also be nice if we could just get one output with all of the numbers for the different workers combined, but that may be asking a bit much. Just getting them all in a workable file would be nice :)

Lets back this up a bit. Your bug reporting _sucks_. Constructive 
criticism - look it up. You were even lazy enough to just reply to an 
old, totally unrelated email, instead of starting a new thread.

So lets try this again. I'll even offer you some free hints. Find out 
where the change happened, see if there's reasoning there. If not, 
suggest a way to improve the situation. Or even just, constructively, 
suggest why the current behavior is a problem and offer your opinion on 
how it could be improved to make your life easier. Nobody on this list 
owes you anything, you need to earn it.

-- 
Jens Axboe


