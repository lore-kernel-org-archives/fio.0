Return-Path: <fio-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:60805 "EHLO
        mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932184AbdCGOkO (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Mar 2017 09:40:14 -0500
Date: Tue, 7 Mar 2017 09:40:13 -0500 (EST)
From: Ben England <bengland@redhat.com>
Message-ID: <1654928993.43134723.1488897613235.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAKwzdDptpE_Z7wzS7JOi4057UWABu2Dsik16sc8VovGB3vvi0Q@mail.gmail.com>
References: <CAKwzdDptpE_Z7wzS7JOi4057UWABu2Dsik16sc8VovGB3vvi0Q@mail.gmail.com>
Subject: Re: fio output-format=json+ and latency histogram buckets ~1200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: fio@vger.kernel.org

Abhishek,

For a good explanation of how fio histograms work:

https://github.com/axboe/fio/blob/master/stat.h#L30

I really like the approach that allows you to trade off accuracy and latency range, where there is a potentially enormous latency range.  Bucket latency range doubles for successive bucket groups.  For buckets in each bucket group, latency range is fixed.

There is a compile-time limit on the number of buckets at present.  you can recompile fio and change FIO_IO_U_PLAT_GROUP_NR.  The limit of 16 seconds comes from this compile time limit.  

Would be nice if row 1 of the histogram log contained the upper bound of each histogram bucket's latency range.  You can parse the histogram logs and generate latency percentiles as a function of time from them with fiologparser_hist.py.  

HTH

-ben


----- Original Message -----
> From: "abhishek koundal" <akoundal@gmail.com>
> To: fio@vger.kernel.org
> Sent: Tuesday, March 7, 2017 1:49:17 AM
> Subject: fio output-format=json+ and latency histogram buckets ~1200
> 
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
