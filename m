Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk1-f169.google.com ([209.85.221.169]:37774 "EHLO
        mail-vk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728920AbeKAAFq (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 31 Oct 2018 20:05:46 -0400
Received: by mail-vk1-f169.google.com with SMTP id 197so2451143vkf.4
        for <fio@vger.kernel.org>; Wed, 31 Oct 2018 08:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <MWHPR04MB032025E64451635D09E474C08FF30@MWHPR04MB0320.namprd04.prod.outlook.com>
 <CALjAwxiuF2hn99MTGGB-AZp=wbQeud2TOtTUx=PeetyETqECgA@mail.gmail.com>
 <AT5PR8401MB1169A3894E1F442F0EB980E2ABF30@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <MWHPR04MB0320651CAF29DB64A9ACBFD28FCC0@MWHPR04MB0320.namprd04.prod.outlook.com>
 <AT5PR8401MB1169A4930EFBEA0856E92002ABCD0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <MWHPR04MB0320C90A987FA4BA44A888068FCD0@MWHPR04MB0320.namprd04.prod.outlook.com>
In-Reply-To: <MWHPR04MB0320C90A987FA4BA44A888068FCD0@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 31 Oct 2018 15:06:54 +0000
Message-ID: <CALjAwxjNpp56s6=mD5Nxr6h9xoCWEyh9jZoNMy4-jd-rgkd4KA@mail.gmail.com>
Subject: Re: fio win affinity broken
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, fio <fio@vger.kernel.org>

I agree with the assessment that Robert and yourself have made - it
should have been a call to GetActiveProcessorCount() and I'm not sure
why I didn't use that...

On Wed, 31 Oct 2018 at 04:06, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>
> Each socket has 8 logical cores, so 16 total cores.  Agreed GetMaximumProcessorCount() returns the max possible cores, and GetActiveProcessorCount() returns the current active cores.  I can try to see if that change resolves it.  Thanks.
>
> Regards,
> Jeff
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Elliott, Robert (Persistent Memory)
> Sent: Tuesday, October 30, 2018 7:21 PM
> To: Jeff Furlong <jeff.furlong@wdc.com>; 'Sitsofe Wheeler' <sitsofe@gmail.com>
> Cc: fio <fio@vger.kernel.org>
> Subject: RE: fio win affinity broken
>
>
>
> > -----Original Message-----
> > From: Jeff Furlong [mailto:jeff.furlong@wdc.com]
> > Sent: Tuesday, October 30, 2018 11:21 AM
> > To: Elliott, Robert (Persistent Memory) <elliott@hpe.com>; 'Sitsofe
> > Wheeler' <sitsofe@gmail.com>
> > Cc: fio <fio@vger.kernel.org>
> > Subject: RE: fio win affinity broken
> >
> > Robert,
> > Agreed split is better.  In trying to trim down the parameter list I
> > left the policy to shared, which is default.  I haven't constrained the fio process, so not sure why the resulting clock threads fail.
> > Is the mask shifted the correct number of bits?
> >
> > Sitsofe,
> > On a x64 version of Win2016, with dual Intel(R) Xeon(R) CPU E5-2623 v3
> > @ 3.00GHz, running
> >
> > fio --name=test --ioengine=windowsaio --direct=1 --rw=write
> > --overwrite=1 --
> > filename=\\.\PHYSICALDRIVE1 --runtime=1s --thread --cpus_allowed=0-1
> > --debug=process
> >
>
> All of your threads fail starting with the 17th (mask 10000) (see below).
> Is that how many CPU cores you really have?
>
> cpus_online() is calling GetMaximumProcessorCount() which is returning the count of 64:
>     process  4788  group=0 group_start=0 group_size=64 search_cpu=0
>
> In linux, that would return only 16 for a system with 16 online CPUs.
> GetActiveProcessorCount() might be a better function to call.
>
>
> fio_setaffinity: failed to set thread affinity (mask 10000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 100000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 1000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 10000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 100000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 1000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 10000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 100000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 1000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 10000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 100000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 1000000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 20000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 200000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 2000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 20000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 200000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 2000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 20000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 200000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 2000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 20000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 200000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 2000000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 40000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 400000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 4000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 40000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 400000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 4000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 40000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 400000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 4000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 40000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 400000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 4000000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 80000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 800000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 8000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 80000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 800000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 8000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 80000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 800000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 8000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 80000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 800000000000000, GetLastError=87)
> fio_setaffinity: failed to set thread affinity (mask 8000000000000000, GetLastError=87)
>
>
> ---
> Robert Elliott, HPE Persistent Memory
>
>
>
>


--
Sitsofe | http://sucs.org/~sits/

