Return-Path: <axboe@kernel.dk>
Subject: Re: FW: default value for random_generator
References: <923FC40148D42D44A828D320CE66E06A01E620@MX204CL01.corp.emc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56A9411B.5020707@kernel.dk>
Date: Wed, 27 Jan 2016 15:13:47 -0700
MIME-Version: 1.0
In-Reply-To: <923FC40148D42D44A828D320CE66E06A01E620@MX204CL01.corp.emc.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/27/2016 05:21 AM, Ruvinsky, Konstantin wrote:
> Hi,
>
> In the description of random_generator=str in HowTo
> ( http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO;h=7c24c1b74296aa33cdff97eca9458defd291b6ca;hb=HEAD )
> is not written now what is its default value.

$ fio --cmdhelp=random_generator

care to send a patch to add it to the HOWTO/man page?
     random_generator: Type of random number generator to use
                 type: string (opt=bla)
              default: tausworthe
         valid values: tausworthe Strong Tausworthe generator
                     : lfsr       Variable length LFSR
                     : tausworthe64 64-bit Tausworthe variant

Care to send a patch to update the HOWTO/man page?

-- 
Jens Axboe


