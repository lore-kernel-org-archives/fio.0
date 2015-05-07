Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
In-Reply-To: <554B7ABF.8050309@kernel.dk>
References: <CAHA74uot2-dZCi=iehNRgx0RF55QsBpLFFcxQ7KqdXmjbn1FuA@mail.gmail.com>
 <8DA4332D-F151-41F4-BC00-59F68ED3ACE3@cran.org.uk> <CAHA74uqeP9ntkHVABfdDPxSZK4tTLbm486b9FJm2YjdJPv8XKA@mail.gmail.com>
 <CAHA74uqXsXBRrNHOdTnnLegnO-DzSdj_DRxnm3R6h8aZkaSSbg@mail.gmail.com>
 <CAHA74uq=vCkY4SVRH6DJM9r70=2ae4vcFVbnjbbVbzRRh=T_SA@mail.gmail.com> <554B7ABF.8050309@kernel.dk>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Thu, 7 May 2015 10:05:51 -0500
Message-ID: <CAB-428=f+yx_E_Hzdvx2UP=ZjxMgS_GRXEjt=NFLzTuJOdXpKQ@mail.gmail.com>
Subject: Re: fio queue depth and windows build.
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Iuliu Rus <iuliur@google.com>, Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Did you guys reproduce exact the same IOMeter IOPS with
FIO on Windows ?  Would you please provide more validation details ?

On Thu, May 7, 2015 at 9:46 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 05/06/2015 12:35 PM, Iuliu Rus wrote:
>>
>> FYI i have sent a pull request https://github.com/axboe/fio/pull/64
>> which makes fio on windows on par with iometer. The difference quite
>> big on our local flash machines (60k iops to 100k)
>
>
> Thanks for fixing this up, it's been a pain point for quite a while!
>
> --
> Jens Axboe
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

