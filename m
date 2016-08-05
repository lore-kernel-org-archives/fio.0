Return-Path: <axboe@kernel.dk>
Subject: Re: Unlink after each loop in job
References: <CAG6KGPRQf7Mii35T1drhL=u0mZB8PQEeOMnmuBFWSNgBy4E31A@mail.gmail.com>
 <48aea5d8-12a5-58ca-9008-913e13bc7a8d@kernel.dk>
 <CAG6KGPSthqs28GTQYSnFGcs_XzQWdALQ8knUS7ook2-_wurcmw@mail.gmail.com>
 <4ac1a598-480e-bfa6-3704-929c909be5da@kernel.dk>
 <b67f4217-97f3-f9f9-46a1-92c9b43ba9b9@kernel.dk>
 <CAG6KGPSukQwdmfcJiE7CSHZf4hYV4niHm2QQcM1tyE=kBHBtzw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0523eea4-0332-2b8e-a595-fd66cd6ae3de@kernel.dk>
Date: Fri, 5 Aug 2016 07:50:53 -0600
MIME-Version: 1.0
In-Reply-To: <CAG6KGPSukQwdmfcJiE7CSHZf4hYV4niHm2QQcM1tyE=kBHBtzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Martin Dev <mrturtledev@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/05/2016 01:31 AM, Martin Dev wrote:
> Hey Jens,
>
> I applied your patch, but it doesn't unlink the file as it continues
> at the !fio_file_open(f) in unlink_files(), run for 2 loops
>
> Clear State: 0
> Clear State: 1
> Doing unlink
> Starting file loop
> File is not open!
>
> I assume it's OK to flip it and check if the file is open then
> continue (so not to unlink files that are potentially still in use)
>
> I'll update the readme/docs and fio.1 as suggested.

The file_open() should just be removed, at best, or at least we should 
flip the check, it doesn't make a lot of sense to only unlink if it's 
open. In any case, it doesn't really matter if it's open or not, last 
user will drop it.

So I'd just drop that check.

-- 
Jens Axboe


