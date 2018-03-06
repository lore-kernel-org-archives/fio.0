Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <b7239a5e-78cd-5dc5-39bc-f61ea9cc8a9c@kernel.dk>
References: <04b051c0-85a6-d6c5-e20e-c9a765a8e22d@bluestop.org>
 <a1e84eb8-5b0c-efa2-6234-555150a740cf@kernel.dk> <68527aaf-203d-8a43-560c-f9135f348b18@bluestop.org>
 <32928ce1-5980-31b5-0566-65e90796d164@kernel.dk> <4bcbe8f2-4460-c0ed-d15d-4d994a9fa6cb@kernel.dk>
 <CALjAwxiiuKXqd-YVWhdBoSuMvpVCFQt5BwjRdf-9RKGBxkV6fQ@mail.gmail.com>
 <5181032d-5f85-5b65-66c6-5621b1582323@kernel.dk> <9e47c711-7101-85ad-3208-eb21dd0d12a9@kernel.dk>
 <CALjAwxhCpSiW9dgKDEzworPFBz07bViCLLogYhqByUc4sWTtwQ@mail.gmail.com>
 <520d1625-b0d6-2c4f-c270-985bf5456254@kernel.dk> <CALjAwxixBb53snR4W9=HCZqRyB=6ieBb+scOQWWLULS_ZLu5mA@mail.gmail.com>
 <b7239a5e-78cd-5dc5-39bc-f61ea9cc8a9c@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 6 Mar 2018 19:16:24 +0000
Message-ID: <CALjAwxgS7FK0pd7OVz8a-PedB+CTayq4rRU0dUnBxz=MVPVGFA@mail.gmail.com>
Subject: Re: memcpy test: results from adding sse and avx tests
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 6 March 2018 at 19:09, Jens Axboe <axboe@kernel.dk> wrote:
> On 3/6/18 12:00 PM, Sitsofe Wheeler wrote:
>> Right and I'm saying change the how we add the flag and the configure
>> test. If the user explicitly sets sse on the configure line  then
>> assume the user knows what they're doing and add it to the CFLAGS and
>> but always detect (via comping a program that would only work if the
>> user really had told the compiler to use SSE) if its already enabled
>> later (rather than only if the user turned it on). My thinking is that
>> platforms like x86_64 will nearly always have SSE so it would be nice
>> to detect if the compiler somehow already has it on.
>
> Ah I see, yes that might make sense. You could already just do that with
> configure --extra-cflags="-msse", though.

Yes you might but having the explicit option means people won't have
to remember gcc flag names if they don't want to (but I don't really
mind either way). The change I was suggesting would also mean if you
set an option
that somehow included lower ones (e.g. --enable_avx512) you would all
the lower flags automatically.

-- 
Sitsofe | http://sucs.org/~sits/

