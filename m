Return-Path: <axboe@kernel.dk>
Subject: Re: gcc 8/8.1 warnings
References: <9785b178-92bc-d927-4a79-80ea5beb87e6@kernel.dk>
 <CAHndrBkcbNMqeK4FTkDUmtKhzYGhzg5r=-FD-xYAQJ5_fVQJ3Q@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b714ea59-0415-b836-0613-90716a98d9b2@kernel.dk>
Date: Tue, 5 Jun 2018 12:26:24 -0600
MIME-Version: 1.0
In-Reply-To: <CAHndrBkcbNMqeK4FTkDUmtKhzYGhzg5r=-FD-xYAQJ5_fVQJ3Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 6/5/18 12:23 PM, Tomohiro Kusumi wrote:
> Hi
> 
> 2018年6月5日(火) 23:56 Jens Axboe <axboe@kernel.dk>:
>>
>> Hi,
>>
>> If someone is looking for a little project, compiling fio with
>> gcc 8/8.1 triggers a new set of overflow warnings. I've included
>> them below.
> 
> What's the CFLAGS being used ?
> I see lots of warnings on Fedora 28 (gcc 8.1.1), but only with
> additional -Wextra.

Just a default build, make clean && make. Maybe RH changes the gcc
defaults for -Wformat-truncation? Or maybe ubuntu/debian does.

-- 
Jens Axboe


