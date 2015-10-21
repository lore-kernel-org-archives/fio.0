Return-Path: <axboe@kernel.dk>
Subject: Re: FIO: adding SMR ZONE management commands
References: <DC12A894E6E89949B50B1F35C3903C1B3B2B0ECA@G9W0747.americas.hpqcorp.net>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5627FC2B.2@kernel.dk>
Date: Wed, 21 Oct 2015 14:57:15 -0600
MIME-Version: 1.0
In-Reply-To: <DC12A894E6E89949B50B1F35C3903C1B3B2B0ECA@G9W0747.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Wolford, Jeff (HP Servers - Web Scale performance)" <jeff.wolford@hpe.com>, "Benchmark FIO (fio@vger.kernel.org)" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/20/2015 02:30 PM, Wolford, Jeff (HP Servers - Web Scale 
performance) wrote:
> Has any consideration been given to adding support for SMR Management ZONE commands to FIO (obviously in block mode) ?
> (Open, Close, Report, Finish, Reset Write Pointer) ?

Some folks from Seagate expressed interest and desire for working on SMR 
for fio this summer, not sure if anything came of that yet. I'll check 
with them. Personally I haven't looked at it much, I don't even have any 
SMR hw.

-- 
Jens Axboe


