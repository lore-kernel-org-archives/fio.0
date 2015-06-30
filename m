Return-Path: <axboe@kernel.dk>
Message-ID: <5591FED3.1090106@kernel.dk>
Date: Mon, 29 Jun 2015 20:28:35 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: t/stest failures
References: <5591CD2C.2080806@cran.org.uk> <5591CE3C.60203@cran.org.uk>
In-Reply-To: <5591CE3C.60203@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/29/2015 05:01 PM, Bruce Cran wrote:
> On 6/29/2015 4:56 PM, Bruce Cran wrote:
>> Is something broken in the t/stest program? It's reporting lots of
>> failures:
>>
>> $ ./t/stest
>> fail at 128205317, size 978
>
> Rather obviously from the console output (and tested), it works if the
> loop if changed from:
>
> while (total < 128*1024*1024UL) {
> to
> while (total < 128*1000*1000UL) {

The smalloc pool size was reduced. I committed something to reduce the 
size of the test cases too.

Bruce, I just found these 4 emails in my spam filter...

-- 
Jens Axboe


