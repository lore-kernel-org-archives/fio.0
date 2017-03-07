Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:33235 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755699AbdCGOjz (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Mar 2017 09:39:55 -0500
Received: by mail-qk0-f177.google.com with SMTP id y76so6840964qkb.0
        for <fio@vger.kernel.org>; Tue, 07 Mar 2017 06:38:39 -0800 (PST)
From: Vincent Fu <vincentfu@gmail.com>
Subject: Re: fio output-format=json+ and latency histogram buckets ~1200
References: <CAKwzdDptpE_Z7wzS7JOi4057UWABu2Dsik16sc8VovGB3vvi0Q@mail.gmail.com>
Message-ID: <01227001-3a9a-23f4-bdc5-84376801c293@gmail.com>
Date: Tue, 7 Mar 2017 09:07:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAKwzdDptpE_Z7wzS7JOi4057UWABu2Dsik16sc8VovGB3vvi0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>, fio@vger.kernel.org

On 07-Mar-17 01:49, abhishek koundal wrote:
> Hi,
> Can someone please explain what is the detailed latency buckets using
> --output-format=json+ depict? The are always ~16 buckets populated. I
> am not able to figure out the # iops per latency buckets and what the
> units of latency are?
>
> Another question:
> For the histogram latency there are ~1200 buckets which can track
> 16sec for max latency. Can someone please explain what each bucket
> interval. e.g. assuming each is 10us increment.
> 0-10us [#IOPS]
> 10-20us[#IOPS]
> 20-30us..[#IOPS]
> ......
> 15-16sec
> --
> Life is too short for silly things so invest your time in some
> productive outputs!!
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

The json+ latency buckets are explained in the "Aggregate clat 
samples..." comment here:

http://git.kernel.dk/cgit/fio/tree/stat.h

There is a Python script at

http://git.kernel.dk/cgit/fio/tree/tools/fio_latency2csv.py

which converts the json+ output into a more intelligible format. It will 
produce a list of completion latency times (usec) with counts of how 
many IOs required each of those times.

My ultimate intention is to eliminate the need for the script and change 
the json+ output format to directly include the actual times.

Vincent
