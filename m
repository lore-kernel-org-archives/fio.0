Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:36601 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbcJXQNF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 24 Oct 2016 12:13:05 -0400
Received: by mail-yw0-f182.google.com with SMTP id u124so4024319ywg.3
        for <fio@vger.kernel.org>; Mon, 24 Oct 2016 09:13:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB0169198E7CB58F942068F566ABD70@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <CAOHuL9gEd8VoDuyirSosdTwyQETskOgTvCyEGEPJoDEQS+9K=A@mail.gmail.com>
 <DF4PR84MB0169198E7CB58F942068F566ABD70@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Mon, 24 Oct 2016 09:13:04 -0700
Message-ID: <CAF+0mvnc2kyMroFSoXT8FHck54DmHvPmEBfvyvHfuqeChk4ssA@mail.gmail.com>
Subject: Re: Results too good to be true?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Tarek <cashew250@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Oct 21, 2016 at 8:07 PM, Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf
>> Of Tarek
>> Sent: Thursday, October 20, 2016 8:31 PM
>> Subject: Results too good to be true?
>>
>> 10 NVME Intel DC P3600 spec'd at 450K Random Read 32QD 4 Jobs
>> I ran 128QD, 3 Jobs each and got aggregate total of  iops=7039.3K!
>> That's more than the spec (granted they didn't spec it for 128QD).
>> Results below and Fio File below that can you take a look
>> if I am overlooking something?
>
> If you want to match the data sheet, you should replicate the
> data sheet's test conditions: 4 jobs with a queue depth of 32.
>
> http://www.anandtech.com/show/8104/intel-ssd-dc-p3700-review-the-pcie-ssd-transition-begins-with-nvme/3 shows the P3700 is better at QD 128 for random reads:
> * 1125 MB/s at QD 32
> * 1875 MB/s at QD 128
>
> so you might be seeing a similar effect.
>
> Also, since the data sheet mentions iometer, they must have used
> Windows.  Windows and linux drivers don't always deliver equal
> performance.
>

Have the drives been preconditioned? Reads won't make it all the way
to the nand if the mapping table is empty so you need to fill each
drive with data first (preconditioning) and then run your test.
