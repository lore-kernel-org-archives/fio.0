Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:58774 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbcCDEiC (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Mar 2016 23:38:02 -0500
Message-ID: <56D91124.8050905@vlnb.net>
Date: Thu, 03 Mar 2016 20:37:56 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Re: Fio high IOPS measurement mistake
References: <56D525E1.6010407@vlnb.net>	<CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com>	<56D66B1C.6050506@vlnb.net>	<56D7A97F.9080800@vlnb.net>	<CALjAwxgU06EEYCw9VV7S8UzDtgpo-KUQtS90HK=KpfffkCKn2A@mail.gmail.com> <CALjAwxi4B4=AAjmR9BmTRtq824_2qEu3nb2AcpH1654HRDAExg@mail.gmail.com>
In-Reply-To: <CALjAwxi4B4=AAjmR9BmTRtq824_2qEu3nb2AcpH1654HRDAExg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Sitsofe Wheeler wrote on 03/02/2016 11:13 PM:
> On 3 March 2016 at 07:10, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> On 3 March 2016 at 03:03, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>>> For those who asked about perf profiling, it remained the same as before with the CPU
>>> consumption is all about timekeeping and memset:
>>>
>>> -  55.74%  fio  fio                [.] clock_thread_fn
>>>      clock_thread_fn
>>
>> Perhaps this is what is already included above but could you use the
>> -g option on perf to collect it into a call-graph and post the top
>> results?
> 
> One extra question: do you see a difference between when you use
> threads (thread=1) and when you use processes (thread=0)?

Nothing serious (few %%), which could be easily explained, because I'm running number
of jobs less, than CPU cores count, so each thread or process has a dedicated CPU core.

Thanks,
Vlad



