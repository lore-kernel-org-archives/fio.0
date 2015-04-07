Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:34277 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbbDGRdn (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Apr 2015 13:33:43 -0400
Received: by qcyk17 with SMTP id k17so24438997qcy.1
        for <fio@vger.kernel.org>; Tue, 07 Apr 2015 10:33:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGGT8x5BgYeDA9=+Ycj4S6PbYC_EgKGZL-ihCP6Ow5YFBRkquw@mail.gmail.com>
References: <CAGGT8x6z5vU+K=oQ3=R4s2N2xcq=aS5L+x42znaKzqxGjyE0=A@mail.gmail.com>
 <CAB-428mdXZqbbK0eGcTnoQae7tOpY06gRVL4m1kNf+jgYrEEHw@mail.gmail.com> <CAGGT8x5BgYeDA9=+Ycj4S6PbYC_EgKGZL-ihCP6Ow5YFBRkquw@mail.gmail.com>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Tue, 7 Apr 2015 12:33:02 -0500
Message-ID: <CAB-428mn+_kjUkViKbBUzD1b1Q=018bNDdXo7Ps-2g4P+4disg@mail.gmail.com>
Subject: Re: Latencies around 10 seconds for I/Os in a trace!!!
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mansour Shafaei Moghaddam <mansoor.shafaei@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Not sure what does 512 means in your wait statements. I would also
recommend to use blktrace+btrecord+btreplay to replay block I/O
workloads on a single HDD. That is more accurate replay method and
tested by the community.

Good luck with your experiments.

On Tue, Apr 7, 2015 at 11:46 AM, Mansour Shafaei Moghaddam
<mansoor.shafaei@gmail.com> wrote:
> Thanks for the response But I am pretty sure about the functionality
> of wait command. The device is a conventional magnetic disk.
>
> On Tue, Apr 7, 2015 at 12:39 PM, Alireza Haghdoost <haghdoost@gmail.com> wrote:
>> Sounds like your wait statements are not correct. Referring to HOWTO.txt :
>>
>> wait       Wait for 'offset' microseconds. Everything below 100 is
>> discarded.
>>
>>
>> What kind of storage device do you have under /dev/sdb ?
>>
>>
