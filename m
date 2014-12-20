Return-Path: <axboe@kernel.dk>
Message-ID: <5495EDE6.7040901@kernel.dk>
Date: Sat, 20 Dec 2014 14:45:10 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Scramble buffers not set by default unless set explicitly
References: <58BC9DC1-E3EE-4B45-9ED7-0B5506045A14@nutanix.com>
In-Reply-To: <58BC9DC1-E3EE-4B45-9ED7-0B5506045A14@nutanix.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Chris Wilson <Chris.Wilson@nutanix.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/20/2014 09:32 AM, Chris Wilson wrote:
> A change (1bf2498d311155bc4eb43edb4e6d3a04845d94c5) to make scramble buffers easier to understand appears to have made scramble buffers not the default behavior by accident.  The logic would always evaluate such that scramble buffers is not used unless set explicitly.
> 
> I think the following little patch changes the logic to what was intended.

Oops, yes that was unintended. Your fix doesn't work for zero enabled
and scramble not set, however. I've checked in a two prong approach:

http://git.kernel.dk/?p=fio.git;a=commit;h=b04f590551050b23768a3969d47371d363aa8745

please let me know if that work as intended for you.

-- 
Jens Axboe


