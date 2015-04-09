Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33434 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbbDIDNS (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 8 Apr 2015 23:13:18 -0400
Received: by iebmp1 with SMTP id mp1so90889525ieb.0
        for <fio@vger.kernel.org>; Wed, 08 Apr 2015 20:13:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF+0mvmYty_1X8xT747D0kbPwQDWhZXNevkeYW=5HvLjZkThjA@mail.gmail.com>
References: <CABtFm2V2E2sZAhebJzxfxifcBJ95FzE8gTdQd+97CGJu2eNntQ@mail.gmail.com>
	<CAF+0mvmYty_1X8xT747D0kbPwQDWhZXNevkeYW=5HvLjZkThjA@mail.gmail.com>
Date: Thu, 9 Apr 2015 11:13:17 +0800
Message-ID: <CABtFm2XZWLRVsG=nVmmxQ7j8ucEwmPVkgDN-cfx_GJjW7eAGPg@mail.gmail.com>
Subject: Re: Generating random data with FIO on directories returning null
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org

Working fine with the following version.

# fio -v
fio-2.2.6-25-g87f5

Thanks for the great support.

On Thu, Apr 9, 2015 at 1:01 AM, Matthew Eaton <m.eaton82@gmail.com> wrote:
>> Am i doing something wrong here? My requirement is to generate random
>> io and multiple files with different sizes.
>>
>> Thanks for any help.
>>
>> --
>> Srinivasa R Chamarthy
>
> This should be fixed if you update to latest fio from git.



-- 
Srinivasa R Chamarthy
