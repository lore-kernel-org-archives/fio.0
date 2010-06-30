Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34256 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab0F3NXv (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 30 Jun 2010 09:23:51 -0400
Message-ID: <4C2B4565.1070402@fusionio.com>
Date: Wed, 30 Jun 2010 15:23:49 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Have we changed number of fields in fio --minimal output
References: <20100629193247.GA3819@redhat.com> <4C2AF2EC.1090806@fusionio.com> <4C2AF382.7000708@fusionio.com> <4C2AF5DF.8050705@fusionio.com> <20100630125940.GA6229@redhat.com> <4C2B43AA.2080708@fusionio.com>
In-Reply-To: <4C2B43AA.2080708@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2010-06-30 15:16, Jens Axboe wrote:
> On 2010-06-30 14:59, Vivek Goyal wrote:
>> On Wed, Jun 30, 2010 at 09:44:31AM +0200, Jens Axboe wrote:
>>> On 2010-06-30 09:34, Jens Axboe wrote:
>>>> On 2010-06-30 09:31, Jens Axboe wrote:
>>>>> On 2010-06-29 21:32, Vivek Goyal wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I was running latest fio and noticed that number of fields in fio
>>>>>> --minimal output have gone up from 69 to 77. A increase of 8 
>>>>>> fields. Don't see any update in --minimal documentation. Is it 
>>>>>> regarding total latency thing?
>>>>>
>>>>> Woops yes, there's a total latency in there as well now. Should 
>>>>> just be 4 extra fields, though. It gets logged after completion 
>>>>> latency, but before bandwidth stats. I'll update the 
>>>>> documentation.
>>>>>
>>>>> Should we perhaps put a versioning field in there? Now would seem 
>>>>> to be a good time, since the output has changed anyway. I'm open to
>>>>> suggestions from you or other terse output users.
>>>>
>>>> How about redesigning it a bit to make it more bullet proof... We 
>>>> could prefix series of fields with the value they are logging. So
>>>> for instance, the 4 completion latency fields would include a clat
>>>> prefix first:
>>>>
>>>> clat[%lu;%lu;%f;%f],foo[%lu;%lu],etc
>>>>
>>>> Would that not be more resilient to future changes? New fields would 
>>>> not bother you, and reordering should also be fine.
>>>>
>>>> Any other ideas?
>>>
>>> With that change, the output would be modified from:
>>>
>>> file;0;0;131072;356015;377;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;131072;303660;442;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;99.265606%;0.367197%;95;0;343;100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%
>>>
>>> to
>>>
>>> id[file;0;0];overview[131072;357913;375];slat[0;0;0.000000;0.000000];clat[0;0;0.000000;0.000000];lat[0;0;0.000000;0.000000];bw[0;0;0.000000%;0.000000;0.000000];overview[131072;304348;441];slat[0;0;0.000000;0.000000];clat[0;0;0.000000;0.000000];lat[0;0;0.000000;0.000000];bw[0;0;0.000000%;0.000000;0.000000];sys[99.754601%;0.000000%;116;0;342];iodepth[100.0%;0.0%;0.0%;0.0%;0.0%;0.0%;0.0%];iolat[0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%];
>>>
>>> The upside is that it should be easier to parse, and it's even humanly
>>> readable to a much greater extent than the current format. But let me
>>> know what you think.
>>
>> Hi Jens,
>>
>> I have a very simple awk script which looks for bw and max clat fields. I 
>> can definitely enhance it to parse this new format.
>>
>> Above will be broken if you decide the change the name of existing field or
>> try to introduce more stats in the existing field. Say some thing additional
>> in "overview" field.
>>
>> Personally I would prefer to version the fio and change the version 
>> whenever something significant like this happen. Then I can change my
>> parsing method based on version.
>>
>> I think irrespective of the format of the string, versioning fio is
>> probably a good idea.
>>
>> May be we can also provide this new format of output with a new fio
>> option say, "fio --terse".
> 
> I don't think adding a new command line parameter for that will make
> a lot of sense, only if I revert the offending commit and then add
> the parameter when readding it.
> 
> So lets break it and add the version number up front, if that is
> what you prefer. If that is easy for you to handle, then I'm guessing
> it will be similar for others that use it.
> 
>> At the end of the day, I will just adjust my scripts based on whatever
>> format you decide to keep. :-)
> 
> Thanks :-)

http://git.kernel.dk/?p=fio.git;a=commit;h=525c2bfabdb7e0093a8775a09ad3e772d962760e

It's new prefixed with version 2, and I updated the documentation
and man page as well on both the new format and the version field.

Oh, and you were right about the 8 extra fields of course, it's 4
added fields but it's per data direction.

-- 
Jens Axboe

