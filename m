Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3] rdma: Add bind option
References: <1510181253-7632-1-git-send-email-sbates@raithlin.com>
 <CF527084-479C-4085-8C3F-2F6D5F607825@raithlin.com>
 <CALjAwxjW3grF90L-5tksdtK4u-6fM5_2Y2Cqf7e02Hz0yjBa4w@mail.gmail.com>
 <9142459b-2a3e-bedb-794d-c150a64598fd@kernel.dk>
 <11D0CCCF-50BC-483C-B37E-3C67A0377843@raithlin.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <07bcb2d3-8e4c-84e4-2acf-25a20eb62662@kernel.dk>
Date: Wed, 22 Nov 2017 13:25:46 -0700
MIME-Version: 1.0
In-Reply-To: <11D0CCCF-50BC-483C-B37E-3C67A0377843@raithlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Stephen Bates <sbates@raithlin.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "logang@deltatee.com" <logang@deltatee.com>, "elliott@hpe.com" <elliott@hpe.com>
List-ID: <fio@vger.kernel.org>

On 11/22/2017 01:22 PM, Stephen  Bates wrote:
>>> One quick suggestion - any chance you could update the HOWTO and fio.1
>>> documentation to include the new ioengine parameter?
>>
>> Thanks Sitsofe, I somehow missed this. Yes, those options should be added
>> to the engine specific options in both those files.
> 
> I did look at this but saw that there was no description for any of
> the existing rdma ioengine options. If you like I can submit a
> follow-on patch adding some information for both the new bind option
> and the older options for rdma ioengine? I will try and get that in
> the next couple of days.

That'd be awesome, that's definitely an oversight. The engine private
options should all be documented in there.

-- 
Jens Axboe


