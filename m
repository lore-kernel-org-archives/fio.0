Return-Path: <axboe@kernel.dk>
Subject: Re: bssplit option HOWTO
References: <CALKvLUnbsqZ8VDW5yKc8vbLU-3Sa4eMu2vb7u2vqm0NFQo+FZQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e54427a7-8037-5aa2-06cc-0168b892eb89@kernel.dk>
Date: Thu, 24 May 2018 13:10:49 -0600
MIME-Version: 1.0
In-Reply-To: <CALKvLUnbsqZ8VDW5yKc8vbLU-3Sa4eMu2vb7u2vqm0NFQo+FZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Konstantin Ruvinsky <konstantin.ruvinsky@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/21/18 11:04 AM, Konstantin Ruvinsky wrote:
> Hi
> 
> 
> 
> In the last HOWTO is written:
> 
> 
> 
> http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;h=7680f9c7634a7e55044dba0a8ebdc6928fb3bfc0;hb=HEAD#l1429
> 
> 
> 
> 
> 
> 1429       If you want a workload that has 50% 2k reads and 50% 4k reads, while
> 
> 1430         having 90% 4k writes and 10% 8k writes, you would specify::
> 
> 1431
> 
> 1432                 bssplit=2k/50:4k/50,4k/90,8k/10
> 
> 
> 
> Question:
> 
> Has it be
> 
> 
> 
> bssplit=2k/50:4k/50,4k/90:8k/10

Yes, good patch. Care to send a patch?

-- 
Jens Axboe


