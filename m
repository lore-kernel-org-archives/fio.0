Return-Path: <fio-owner@vger.kernel.org>
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:48682 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965835AbaFSVO7 (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 19 Jun 2014 17:14:59 -0400
Received: from smtprelay.hostedemail.com (ff-bigip1 [10.5.19.254])
	by smtpgrave05.hostedemail.com (Postfix) with ESMTP id 03B32185B35
	for <fio@vger.kernel.org>; Thu, 19 Jun 2014 21:04:32 +0000 (UTC)
Message-ID: <53A3505F.1000809@nellans.org>
Date: Thu, 19 Jun 2014 16:04:31 -0500
From: David Nellans <david@nellans.org>
MIME-Version: 1.0
Subject: Re: fio execution issue on Android device with MediaTek
References: <CACTzACWfzQpXwfrBuneYiDFYR=ERUXXaA3oOOz62oEvXa5xNCA@mail.gmail.com>
In-Reply-To: <CACTzACWfzQpXwfrBuneYiDFYR=ERUXXaA3oOOz62oEvXa5xNCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David N <android.wm.edu@gmail.com>, fio@vger.kernel.org

generally speaking taking a pre-compiled binary from one machine to 
another is a dicey proposition
but in this case you're moving from a krait 400? which runs armv7 to the 
MT6572 which is a cortex A-7
which are the same ISA rev.  are you running the exact same distro 
and/or set of libs on them too?
changes there in glibc, will cause issues. cross compiling for x86 
certainly isn't going to fix your problems!

just for good measure I did just compile and run fio tip on a tegra k1 
running ubuntu 13.04 (3.10.33 kern)
and it seems to be working just fine. have you managed to get anything 
at all to work via this method?
i doubt its an issue specific to fio.

- the real David N

On 06/19/2014 03:39 PM, David N wrote:
> Hi all,
>
> I got fio working fine on a device with Qualcomm Snapdragon but
> executing that same compiled binary gave me "sh: ./fio: not
> executable: magic 7F45" on a MediaTek (MT6572) device.
>
> I tried to recompile both for ARM and x86 but still the same issue.
> The binary is executable (did chmod it), so I'm not sure what is
> causing this. I'd very much appreciate any input.
>
> Thanks much!
> David
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

