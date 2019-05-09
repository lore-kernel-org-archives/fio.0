Return-Path: <sboisvert@gydle.com>
Subject: Re: Recent changes (master)
References: <20190509120003.26BCA2C098E@kernel.dk>
 <AT5PR8401MB1169B5D8881E1D2E3D11EC4DAB330@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Sebastien Boisvert <sboisvert@gydle.com>
Message-ID: <c5c7cb41-565a-d3fa-5a58-c1fb6647b3b4@gydle.com>
Date: Thu, 9 May 2019 11:52:49 -0400
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB1169B5D8881E1D2E3D11EC4DAB330@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Servers)" <elliott@hpe.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 2019-05-09 11:47 a.m., Elliott, Robert (Servers) wrote:
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
> 
> 

This 


+					printf("Your filesystem/device doesn't "
+						"support polled IO\n");

will print one line in standard output:

Your filesystem/device doesn't support polled IO


Do you mean that you want to grep in the source code ?

