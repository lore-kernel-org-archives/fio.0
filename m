Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34646 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcCCHKF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Mar 2016 02:10:05 -0500
Received: by mail-vk0-f42.google.com with SMTP id e185so12788232vkb.1
        for <fio@vger.kernel.org>; Wed, 02 Mar 2016 23:10:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56D7A97F.9080800@vlnb.net>
References: <56D525E1.6010407@vlnb.net>
	<CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com>
	<56D66B1C.6050506@vlnb.net>
	<56D7A97F.9080800@vlnb.net>
Date: Thu, 3 Mar 2016 07:10:02 +0000
Message-ID: <CALjAwxgU06EEYCw9VV7S8UzDtgpo-KUQtS90HK=KpfffkCKn2A@mail.gmail.com>
Subject: Re: Fio high IOPS measurement mistake
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 3 March 2016 at 03:03, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> For those who asked about perf profiling, it remained the same as before with the CPU
> consumption is all about timekeeping and memset:
>
> -  55.74%  fio  fio                [.] clock_thread_fn
>      clock_thread_fn

Perhaps this is what is already included above but could you use the
-g option on perf to collect it into a call-graph and post the top
results?

-- 
Sitsofe | http://sucs.org/~sits/
