Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:36568 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcCCHN6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Mar 2016 02:13:58 -0500
Received: by mail-vk0-f44.google.com with SMTP id c3so12760997vkb.3
        for <fio@vger.kernel.org>; Wed, 02 Mar 2016 23:13:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgU06EEYCw9VV7S8UzDtgpo-KUQtS90HK=KpfffkCKn2A@mail.gmail.com>
References: <56D525E1.6010407@vlnb.net>
	<CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com>
	<56D66B1C.6050506@vlnb.net>
	<56D7A97F.9080800@vlnb.net>
	<CALjAwxgU06EEYCw9VV7S8UzDtgpo-KUQtS90HK=KpfffkCKn2A@mail.gmail.com>
Date: Thu, 3 Mar 2016 07:13:57 +0000
Message-ID: <CALjAwxi4B4=AAjmR9BmTRtq824_2qEu3nb2AcpH1654HRDAExg@mail.gmail.com>
Subject: Re: Fio high IOPS measurement mistake
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 3 March 2016 at 07:10, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 3 March 2016 at 03:03, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> For those who asked about perf profiling, it remained the same as before with the CPU
>> consumption is all about timekeeping and memset:
>>
>> -  55.74%  fio  fio                [.] clock_thread_fn
>>      clock_thread_fn
>
> Perhaps this is what is already included above but could you use the
> -g option on perf to collect it into a call-graph and post the top
> results?

One extra question: do you see a difference between when you use
threads (thread=1) and when you use processes (thread=0)?

-- 
Sitsofe | http://sucs.org/~sits/
