Return-Path: <axboe@kernel.dk>
Message-ID: <5356E959.7010707@kernel.dk>
Date: Tue, 22 Apr 2014 16:12:41 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: runtime resets eta after countdown
References: <F73CB16A-07C1-4E7B-AD65-2045F7538FBF@gmail.com> <53554C4D.60706@kernel.dk> <1D77D71A-32AE-4BC9-8358-0A1AA55062C3@gmail.com> <31FB952C-782C-49DF-9067-16991E82D434@gmail.com>
In-Reply-To: <31FB952C-782C-49DF-9067-16991E82D434@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Vasu Kulkarni <vasu.kulkarni@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/22/2014 10:22 AM, Vasu Kulkarni wrote:
> 
> On Apr 21, 2014, at 11:56 AM, Vasu Kulkarni <vasu.kulkarni@gmail.com> wrote:
> 
>>>
>>> http://brick.kernel.dk/snaps/fio-git-latest.tar.gz
>>
>> Tried most of the scenario's with the above git and its working fine. Thanks 
> 	
>       I still see 1/5 runs still exhibit the problem where eta is getting reset, Will paths going offline and coming back online affect eta in anyway, runtime is in the range of 45minutes ? 
>       Is there any logs that i can provide that will help debug this issue. Thanks.

OK, sounds like there's still a bug there, just triggers a bit
differently. I'll take a look at this.

-- 
Jens Axboe


