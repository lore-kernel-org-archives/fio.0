Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:42400 "EHLO
        mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751414AbeCOTlF (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 15 Mar 2018 15:41:05 -0400
Received: from pps.filterd (m0075551.ppops.net [127.0.0.1])
        by mx0a-000cda01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w2FJdGpX018989
        for <fio@vger.kernel.org>; Thu, 15 Mar 2018 15:41:05 -0400
Received: from mail-lf0-f70.google.com (mail-lf0-f70.google.com [209.85.215.70])
        by mx0a-000cda01.pphosted.com with ESMTP id 2gqr2a1ygw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 15 Mar 2018 15:41:04 -0400
Received: by mail-lf0-f70.google.com with SMTP id g13-v6so2683502lfl.15
        for <fio@vger.kernel.org>; Thu, 15 Mar 2018 12:41:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521139102.2834.26.camel@wdc.com>
References: <CAODBMz=rOy1kJGVGn3fyCGT78QUK0BH0rzw7cTRMxKZ6sdSF-Q@mail.gmail.com>
 <CY1PR0401MB11166E39586E25D46B482E4581D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxgn-yxPf5noENrdbhPKS7T3BVsArSa8wG50e0r88DPr-A@mail.gmail.com>
 <1521132231.2834.4.camel@wdc.com> <CAODBMznzVriS6kL5aFddKZBfdLfBLYOk=Chfas4+Xn6LjOxveQ@mail.gmail.com>
 <1521139102.2834.26.camel@wdc.com>
From: Phillip Chen <phillip.a.chen@seagate.com>
Date: Thu, 15 Mar 2018 13:40:20 -0600
Message-ID: <CAODBMzk6+f0Hjn-uuzz6rmS0idH1oSD21D8rd21rd9Qhqv+-VQ@mail.gmail.com>
Subject: Re: ZBC/FLEX FIO addition ideas
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "sitsofe@gmail.com" <sitsofe@gmail.com>, Kris Davis <Kris.Davis@wdc.com>, Jason Jorgensen <jason.jorgensen@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

I haven't used the profile argument for FIO before, so when I read
profile I thought it was being used as a synonym I/O profile or
workload. So I think you're right that we shouldn't be creating a new
profile for ZBC but rather focusing on the existing FIO generated
workloads.
When I was talking about valid I meant that get_next_block() would
generate IO that would not cause errors or read filler data past the
write pointer rather than having zbc_adjust_block() modify the IO
afterwards.
You make a good point that the two approaches can easily coexist. If
you get your changes added I would like to try and build the
additional workloads on top of your existing changes so that I can
leverage your write pointer tracking code.
Thank you,
Phillip

On Thu, Mar 15, 2018 at 12:38 PM, Bart Van Assche
<Bart.VanAssche@wdc.com> wrote:
> On Thu, 2018-03-15 at 12:06 -0600, Phillip Chen wrote:
>> Would creating new profiles for all the I/O patterns be particularly
>> difficult? I'm sure you're much more familiar with the FIO codebase
>> than I am, but it seems to me that all you'd need to do for randoms is
>> move the logic from the zbc_adjust_block cases upstream into the
>> various methods called by get_off_from_method(), or possibly modify
>> the existing methods to work differently when working on a ZBC drive.
>> For sequentials it seems like you'd just have to move the logic into
>> get_next_seq_offset().
>
> Hello Phillip,
>
> Adding support for ZBC drives through creation of a new profile has the
> following disadvantages:
> - It makes it impossible to use another profile (act or tiobench) for the
>   generation of a workload.
> - It will lead to code duplication. fio already has code for supporting a
>   large number of I/O patterns (sequential, random, ...). If we can avoid
>   code duplication I think we should avoid it.
>
>> It also seems to me that it might be better to have get_next_block()
>> pick a valid area to begin with.
>
> What does "valid" mean in this context? Have you noticed that
> zbc_adjust_block() modifies the I/O request offset and length such that
> neither write errors nor reads past the end of the write pointer are
> triggered?
>
>> The main benefit to doing this that I
>> can see would be to allow much more control over the number of open
>> zones, which I think will be of particular interest in testing ZBC
>> drive performance. Additionally, it might be worthwhile to have an
>> option allows the workload to pick a new zone instead of resetting the
>> write pointer of a zone when writing to a full zone. This would also
>> be made easier with a more upstream approach, because you wouldn't
>> need to retry and get a new offset, you could just avoid full zones
>> entirely. Or you could keep track of which zones are open and
>> add/replace open zones as necessary.
>
> With the approach I proposed it is already possible to control the number of
> open zones, namely by setting the I/O offset (--offset=) to the start of a
> zone and by setting the I/O size (--io_size=) to (number of zones to test) *
> (zone size). But I agree with you that the kind of workload that you
> described would best be implemented as an I/O profile. How about starting
> with the approach I proposed and adding profile(s) for more advanced ZBC I/O
> patterns later?
>
> Thanks,
>
> Bart.
>
>
