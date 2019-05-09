Return-Path: <axboe@kernel.dk>
Subject: Re: Recent changes (master)
References: <20190509120003.26BCA2C098E@kernel.dk>
 <AT5PR8401MB1169B5D8881E1D2E3D11EC4DAB330@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e2203ed6-359b-0e14-eb54-459616e4ed02@kernel.dk>
Date: Thu, 9 May 2019 09:57:10 -0600
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB1169B5D8881E1D2E3D11EC4DAB330@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Servers)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 5/9/19 9:47 AM, Elliott, Robert (Servers) wrote:
> 
> 
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf
>> Of Jens Axboe
>> Sent: Thursday, May 09, 2019 7:00 AM
>> To: fio@vger.kernel.org
>> Subject: Recent changes (master)
> ...
>> -					printf("Your filesystem doesn't
>> support poll\n");
>> +					printf("Your filesystem/device
>> doesn't "
>> +						"support polled IO\n");
> 
> Can you keep that string on one line so it is grep-able?

To keep everyone happy, I changed it to one line AND added a kernel
mention too.

Next up, color of the build ;-)

-- 
Jens Axboe


