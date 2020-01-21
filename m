Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] engines: add engine for file stat
References: <925A83423110DA4D836092D40AC7A7E8085CB462@APYOKXMS108.ap.sony.com>
 <CALjAwxhtdp3zJisFDdXt4no2hHwFKktuDNEMEV5EZN7fo=mL4Q@mail.gmail.com>
 <SG2PR04MB2492F64F703104122008D211FD520@SG2PR04MB2492.apcprd04.prod.outlook.com>
 <CALjAwxjd9u+DLLOmf7reEtnkX=wL=vqK0dpCTq3cFHdVN0z7dg@mail.gmail.com>
 <027dde15-1c6a-47a5-f89b-0d808d4cd1f3@kernel.dk>
 <SG2PR04MB24924423F87B356C30A9AF54FD3E0@SG2PR04MB2492.apcprd04.prod.outlook.com>
 <HK0PR04MB2388DC18A61F0D5483D72BE8FD0D0@HK0PR04MB2388.apcprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56461733-2fef-6faa-ac60-2436bf7d692d@kernel.dk>
Date: Tue, 21 Jan 2020 08:26:49 -0700
MIME-Version: 1.0
In-Reply-To: <HK0PR04MB2388DC18A61F0D5483D72BE8FD0D0@HK0PR04MB2388.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Su, Friendy" <Friendy.Su@sony.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>, "Kobayashi, Kento (Sony)" <Kento.A.Kobayashi@sony.com>
List-ID: <fio@vger.kernel.org>

I'm not totally against adding this type of engine, I just think that
going forward it'd be better to make any sort of file oriented operation
something the IO engine can perform, instead of having a specific engine
for that. But that's probably a larger scope project than you're willing
to attack, and I don't think it'd be fair to gate the inclusion of this
one on that.

So feel free to send the latest version you have and we can take a look
at it.


On 1/21/20 3:09 AM, Su, Friendy wrote:
> Any update or opinion on this topic?
> 
> -----Original Message-----
> From: Su, Friendy 
> Sent: Wednesday, January 8, 2020 5:33 PM
> To: Jens Axboe <axboe@kernel.dk>; Sitsofe Wheeler <sitsofe@gmail.com>
> Cc: fio <fio@vger.kernel.org>; Kobayashi, Kento (Sony) <Kento.A.Kobayashi@sony.com>
> Subject: RE: [PATCH] engines: add engine for file stat
> 
> Sorry, I resend patch in mail body, not attachment.
> 
> Until now, I have not considered relation between 'io_uring' and 'filestat'.
> 
> This 'filestat' engine is created since under some real occasion, we really care about 'how fast files being lookup or operated' as well as 'how fast read/write'. FIO is strong on 'IO performance' measurement, we choose FIO. We want the same benchmark tool to measure 'file operation' since 'same tool' makes condition, sequence easy to be same. Based on this, I created 'filestat' engine. We hope FIO can be strengthen its capability on 'file operation' measurement. Besides 'filestat', 'file-delete', 'file-rename' are also need.
> 
> -----Original Message-----
> From: Jens Axboe <axboe@kernel.dk>
> Sent: Monday, December 30, 2019 7:21 AM
> To: Sitsofe Wheeler <sitsofe@gmail.com>; Su, Friendy <Friendy.Su@sony.com>
> Cc: fio <fio@vger.kernel.org>; Kobayashi, Kento (Sony) <Kento.A.Kobayashi@sony.com>
> Subject: Re: [PATCH] engines: add engine for file stat
> 
> On 12/29/19 2:23 PM, Sitsofe Wheeler wrote:
>> On Thu, 19 Dec 2019 at 10:20, Su, Friendy <Friendy.Su@sony.com> wrote:
>>>
>>> Thanks for your comments.
>>> I fixed and resent patch. Pls see my reply in text below.
>>
>> From a brief scan it looks OK to me but I'd say you are better off 
>> posting patches in-line because it make review easier (anyone else who 
>> wants to see it will have to look at the parent of this mail). If this 
>> is troublesome you can always try submitting a pull request (e.g. via 
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_axboe_fio_pulls&d=DwICaQ&c=fP4tf--1dS0biCFlB0saz0I0kjO5v7-GLPtvShAo4cc&r=x4w-xeFLV1q9QNvT-g51hIN_YdnTDh2iniRTDjOpGTk&m=n7aH04Az0Bke6LtP1bcGhKisgjZ4-_cX3Cm0aJyo62Y&s=HZGFwGTEsbbO6oWDd2fNQYzft3kP9Yv1DBiBq7dmDj0&e=  )...
>>
>> Jens: If you can see the patch as an attachment (e.g. at the bottom of 
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_lists_fio_msg08203.html&d=DwICaQ&c=fP4tf--1dS0biCFlB0saz0I0kjO5v7-GLPtvShAo4cc&r=x4w-xeFLV1q9QNvT-g51hIN_YdnTDh2iniRTDjOpGTk&m=n7aH04Az0Bke6LtP1bcGhKisgjZ4-_cX3Cm0aJyo62Y&s=gVr4lkUJChqpKsxpSPdguu8txoH_geku7Z5MQXzYK_k&e=  ), what do you think?
> 
> With my io_uring hat on, there's a few ways to do stat since io_uring also supports it. Is the plan to enable a io_uring backend as well for that engine? Or should stat perhaps be a data direction instead that all io engines could then support, some of them in an async manner?
> 
> 
> --
> Jens Axboe
> 


-- 
Jens Axboe


