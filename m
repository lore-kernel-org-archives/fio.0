Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34907 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964852AbaFSVZh (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Jun 2014 17:25:37 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so122562wib.0
        for <fio@vger.kernel.org>; Thu, 19 Jun 2014 14:25:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53A3527A.1000800@nellans.org>
References: <CACTzACWfzQpXwfrBuneYiDFYR=ERUXXaA3oOOz62oEvXa5xNCA@mail.gmail.com>
	<53A3505F.1000809@nellans.org>
	<53A3527A.1000800@nellans.org>
Date: Thu, 19 Jun 2014 14:25:35 -0700
Message-ID: <CACTzACXL-zOFS8tNft7zs5M3G5MLAXLENY7uQw-NWqq9_WywMA@mail.gmail.com>
Subject: Re: fio execution issue on Android device with MediaTek
From: David N <android.wm.edu@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Nellans <david@nellans.org>
Cc: fio@vger.kernel.org

Hi David,

Yes, it's mt6572 with armv7 rev 3. I didn't do any changes to fio.
Just pulled the latest version, compiled, and pushed the binary to the
device. I tried the same binary on Samsung S4 with qualcomm, and it
worked fine.

Thanks,
-David Nguyen

On Thu, Jun 19, 2014 at 2:13 PM, David Nellans <david@nellans.org> wrote:
> I may have actually spoken prematurely - if the krait version is running v7a
> and compiles for armeabi-v7a
> but the mt6572 is only supports armeabi you could run into ABI issues.
> either way, still very unlikely its a fio issue.
>
>
> On 06/19/2014 04:04 PM, David Nellans wrote:
>>
>> generally speaking taking a pre-compiled binary from one machine to
>> another is a dicey proposition
>> but in this case you're moving from a krait 400? which runs armv7 to the
>> MT6572 which is a cortex A-7
>> which are the same ISA rev.  are you running the exact same distro and/or
>> set of libs on them too?
>> changes there in glibc, will cause issues. cross compiling for x86
>> certainly isn't going to fix your problems!
>>
>> just for good measure I did just compile and run fio tip on a tegra k1
>> running ubuntu 13.04 (3.10.33 kern)
>> and it seems to be working just fine. have you managed to get anything at
>> all to work via this method?
>> i doubt its an issue specific to fio.
>>
>> - the real David N
>>
>> On 06/19/2014 03:39 PM, David N wrote:
>>>
>>> Hi all,
>>>
>>> I got fio working fine on a device with Qualcomm Snapdragon but
>>> executing that same compiled binary gave me "sh: ./fio: not
>>> executable: magic 7F45" on a MediaTek (MT6572) device.
>>>
>>> I tried to recompile both for ARM and x86 but still the same issue.
>>> The binary is executable (did chmod it), so I'm not sure what is
>>> causing this. I'd very much appreciate any input.
>>>
>>> Thanks much!
>>> David
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>>
>
