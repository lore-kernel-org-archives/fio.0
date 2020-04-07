Return-Path: <axboe@kernel.dk>
Subject: Re: RFC: New GAS meta-engine and S3 engine
References: <CABdSUwQx5HmuVQGYsY6fc1TeOwE223i4NoMKMmWxgQTcZuPvTQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <15112f6c-e0d6-162c-5120-d0c247fa95f9@kernel.dk>
Date: Tue, 7 Apr 2020 15:44:06 -0700
MIME-Version: 1.0
In-Reply-To: <CABdSUwQx5HmuVQGYsY6fc1TeOwE223i4NoMKMmWxgQTcZuPvTQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: =?UTF-8?Q?Marcin_=c5=bbukowski?= <marcin.zukowski@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/11/20 6:56 AM, Marcin Żukowski wrote:
> Hi all,
> 
> Sending this before I send a pull request, as I wanted to consult
> first if this is something that would be desirable.
> 
> A long while ago (2017) I needed ability to test AWS S3 performance,
> including aspects like concurrent IOs, various IO sizes etc. So I
> decided my favorite "fio" is probably a good tool to use for it. Back
> then, S3 mode for http.c didn't exist yet, so I had to do something
> myself. I made it work back then, but I got busy and didn't merge it
> upstream (sorry!). Trying to fix it now.
> 
> Instead of manually implementing S3 HTTP interface (like http.c did),
> I thought it would be desirable to use the official AWS SDK. However,
> it had some issues, like no built-in asynchronicity, being C++ and so
> on.
> 
> I realized the process of making AWS interface provide what fio needs
> is super generic. So I decided to write a mini meta-engine I called
> GAS - Generic ASync. It provides fio-compatible  async-adding wrapper
> to any IO-like library. Then, adding a full-fledged fio engine is
> trivial, see example in gas-direct-io.c . Similarly S3 engine
> (read-only for now) is quite trivial. I had to split it into a C and
> C++ part, but the entire thing is still <200 LOC.
> 
> I'm now thinking about adding similar engines for Azure and GCP object
> stores, hence I wonder if it would make sense to merge it upstream.
> One concern I have is making fio dependent on all these SDKs. Hence I
> thought this should only be optionally compiled-in.
> 
> The repo is here, I recently refreshed it from upstream:
> https://github.com/MarcinZukowski/fio
> 
> Thoughts? Comments? Should I just send a pull request? :)

Yeah, just send a pull request, probably the best way to get some
comments on the code!

-- 
Jens Axboe


