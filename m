Return-Path: <axboe@kernel.dk>
Message-ID: <5571BBFA.9050500@kernel.dk>
Date: Fri, 05 Jun 2015 09:10:50 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Parameter Issue with 'ratemin'...
References: <loom.20150603T211024-259@post.gmane.org> <CY1PR02MB1303CE323DB544A10F37A24381B40@CY1PR02MB1303.namprd02.prod.outlook.com> <loom.20150604T150859-664@post.gmane.org>
In-Reply-To: <loom.20150604T150859-664@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: FIO-User-KKV <viali.lee@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 06/04/2015 07:10 AM, FIO-User-KKV wrote:
> Hinson, Roger <Roger_Hinson@...> writes:
>
>>
>>
>> -----Original Message-----
>> From: fio-owner@...
>> [mailto:fio-owner@...] On Behalf Of FIO-User-KKV
>> Sent: Wednesday, June 03, 2015 12:21 PM
>> To: fio@...
>> Subject: Parameter Issue with 'ratemin'...
>>
>> Hi, I am using Fio 2.2.8.
>> I have an issue when setting the parameter 'ratemin'.
>> It only accepts '0'!
>> no matter what non-zero values I set,
>>
>> e.g.,
>> sudo fio -name "SOURCE"  -numjobs 1  -bs 1M   -rw write -direct 1 -
> runtime
>> 50 -filename=/dev/vdb  -prio 0 -ratemin=1K
>>
>> I will end up quickly with "fio: minimum rate exceeds rate"!
>> Could anyone know what's wrong there?
>>
>> Thanks!
>>
>> --
>> Hey,
>>
>> The value of ratemin needs to be an int.  If you want 1000, you need
> to enter as 1000, not 1K.
>>
>> Roger
>>
>>
> Hi, thanks for the quick reply.
> I also tried 1000, or 1, or 100 whatever...
> It didn't work...
> I always got "fio: minimum rate exceeds rate".
> only 0 works.....

ratemin is meant to be used with rate. Say you set rate at 5mb/s, and 
you set a ratemin at 2mb/s. This means that fio will attempt to run at 
5mb/s, and it will fatally fail if it can't maintain 2mb/s. Setting 
ratemin without rate has no real meaning, which is why it errors out.

-- 
Jens Axboe


