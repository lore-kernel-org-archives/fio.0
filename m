Return-Path: <ruby.wktk@gmail.com>
Return-Path: <ruby.wktk@gmail.com>
Message-ID: <5430F01E.2010906@gmail.com>
Date: Sun, 05 Oct 2014 16:15:42 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
MIME-Version: 1.0
Subject: Re: [Question] How to perform stride access?
References: <CANvN+enrUD45Zp1CJKQ3kxQncHLyhp7hE1jr4AnzRD65oDTUvg@mail.gmail.com>	<54228237.5000805@gmail.com>	<CALjAwxg+o05=3YDOmXaKskrdg3AHU88T-pkqZw=QFQkwRTjdwA@mail.gmail.com>	<CALjAwxirUW+v662QZ9zQG-2zuTNtE8xkpfaJqv=5ArLviqjhGw@mail.gmail.com>	<5427716A.1080407@kernel.dk>	<20140928103616.GA9991@sucs.org>	<54281A0A.8050905@kernel.dk>	<5428246F.7020506@kernel.dk>	<20140928194419.GA24724@sucs.org>	<54288805.2020008@kernel.dk>	<20140929074038.GA12377@sucs.org> <20140930102344.4a6b95795a43c614bb1ab253@gmail.com>
In-Reply-To: <20140930102344.4a6b95795a43c614bb1ab253@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: sitsofe@gmail.com
Cc: axboe@kernel.dk, andrey.v.kuzmin@gmail.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

The latest fio works as I expected.
It wraps around until certain amount (specified by io_limit) ends.

Thanks,

- Akira

On 9/30/14 10:23 AM, Akira Hayakawa wrote:
>> Latest patch fixes zone skipping for me too. Akira are things better for
>> you too?
> Thanks Sitsofe,
> I will make my time on this weekend to try your patch out.
> But, at the first look, it looks fine.
> 
> - Akira
> 


