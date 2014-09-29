Return-Path: <axboe@kernel.dk>
Message-ID: <542968BF.2090008@kernel.dk>
Date: Mon, 29 Sep 2014 08:12:15 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Confirming test parameters
References: <68dcaec92df442db80f34a518dd05cc3@BLUPR02MB453.namprd02.prod.outlook.com> <54288BA4.50906@kernel.dk> <cdeb54976b2a45d4b195952023e7525f@BLUPR02MB453.namprd02.prod.outlook.com>
In-Reply-To: <cdeb54976b2a45d4b195952023e7525f@BLUPR02MB453.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Hinson, Roger" <Roger_Hinson@intuit.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-09-28 23:50, Hinson, Roger wrote:
> Making sure I understand that.  I'm not sure if I have the right percentages.
>
> Since I'm using this for my type 2 above:
>   rw=randrw
>   rwmixread=3
>   rwmixwrite=97
>   percentage_random=14
>
> Would I list it as percentage_random=1,13  because my read sequential is 2% and write sequential is 84% ?

For those parameters, you should use 100 - percentage for both of them. 
So this would be the correct option:

percentage_random=98,16

-- 
Jens Axboe


