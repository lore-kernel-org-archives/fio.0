Return-Path: <axboe@kernel.dk>
Message-ID: <55535FD1.2080202@kernel.dk>
Date: Wed, 13 May 2015 10:29:37 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Write Pattern and Verify in separate run instance ?
References: <CAB-428kCfA3PZdu+3jOUAxQH4jL2fScEUAKctxy4NhXUfbz3rA@mail.gmail.com> <CAF+0mv=L0xSu8zs-d7kXUZ8LtUV+kmPc0MVyammADMHeJFuDEQ@mail.gmail.com> <CAB-428m3S0xRi8KD9a9zr55839mD6vEx8OATHdb4Yzhv8-R6xw@mail.gmail.com>
In-Reply-To: <CAB-428m3S0xRi8KD9a9zr55839mD6vEx8OATHdb4Yzhv8-R6xw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Alireza Haghdoost <haghdoost@gmail.com>, Matthew Eaton <m.eaton82@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/13/2015 10:01 AM, Alireza Haghdoost wrote:
> Mattew,
>
> Thanks for your reply. Is it possible to run Write-Phase and
> Verify-phase in two separate run instances and job files ?

Yes, the example file could be split into two jobs, it would not matter.

-- 
Jens Axboe


