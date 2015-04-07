Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34416 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbbDGQqb (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Apr 2015 12:46:31 -0400
Received: by qgfi89 with SMTP id i89so23408708qgf.1
        for <fio@vger.kernel.org>; Tue, 07 Apr 2015 09:46:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB-428mdXZqbbK0eGcTnoQae7tOpY06gRVL4m1kNf+jgYrEEHw@mail.gmail.com>
References: <CAGGT8x6z5vU+K=oQ3=R4s2N2xcq=aS5L+x42znaKzqxGjyE0=A@mail.gmail.com>
	<CAB-428mdXZqbbK0eGcTnoQae7tOpY06gRVL4m1kNf+jgYrEEHw@mail.gmail.com>
Date: Tue, 7 Apr 2015 12:46:30 -0400
Message-ID: <CAGGT8x5BgYeDA9=+Ycj4S6PbYC_EgKGZL-ihCP6Ow5YFBRkquw@mail.gmail.com>
Subject: Re: Latencies around 10 seconds for I/Os in a trace!!!
From: Mansour Shafaei Moghaddam <mansoor.shafaei@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Thanks for the response But I am pretty sure about the functionality
of wait command. The device is a conventional magnetic disk.

On Tue, Apr 7, 2015 at 12:39 PM, Alireza Haghdoost <haghdoost@gmail.com> wrote:
> Sounds like your wait statements are not correct. Referring to HOWTO.txt :
>
> wait       Wait for 'offset' microseconds. Everything below 100 is
> discarded.
>
>
> What kind of storage device do you have under /dev/sdb ?
>
>
