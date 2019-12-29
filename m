Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] engines: add engine for file stat
References: <925A83423110DA4D836092D40AC7A7E8085CB462@APYOKXMS108.ap.sony.com>
 <CALjAwxhtdp3zJisFDdXt4no2hHwFKktuDNEMEV5EZN7fo=mL4Q@mail.gmail.com>
 <SG2PR04MB2492F64F703104122008D211FD520@SG2PR04MB2492.apcprd04.prod.outlook.com>
 <CALjAwxjd9u+DLLOmf7reEtnkX=wL=vqK0dpCTq3cFHdVN0z7dg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <027dde15-1c6a-47a5-f89b-0d808d4cd1f3@kernel.dk>
Date: Sun, 29 Dec 2019 16:20:41 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxjd9u+DLLOmf7reEtnkX=wL=vqK0dpCTq3cFHdVN0z7dg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, "Su, Friendy" <Friendy.Su@sony.com>
Cc: fio <fio@vger.kernel.org>, "Kobayashi, Kento (Sony)" <Kento.A.Kobayashi@sony.com>
List-ID: <fio@vger.kernel.org>

On 12/29/19 2:23 PM, Sitsofe Wheeler wrote:
> On Thu, 19 Dec 2019 at 10:20, Su, Friendy <Friendy.Su@sony.com> wrote:
>>
>> Thanks for your comments.
>> I fixed and resent patch. Pls see my reply in text below.
> 
> From a brief scan it looks OK to me but I'd say you are better off
> posting patches in-line because it make review easier (anyone else who
> wants to see it will have to look at the parent of this mail). If this
> is troublesome you can always try submitting a pull request (e.g. via
> https://github.com/axboe/fio/pulls )...
> 
> Jens: If you can see the patch as an attachment (e.g. at the bottom of
> https://www.spinics.net/lists/fio/msg08203.html ), what do you think?

With my io_uring hat on, there's a few ways to do stat since io_uring
also supports it. Is the plan to enable a io_uring backend as well for
that engine? Or should stat perhaps be a data direction instead that all
io engines could then support, some of them in an async manner?


-- 
Jens Axboe


