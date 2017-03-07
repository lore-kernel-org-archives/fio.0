Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:35598 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754842AbdCGItQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Mar 2017 03:49:16 -0500
Received: by mail-ua0-f175.google.com with SMTP id q7so160321261uaf.2
        for <fio@vger.kernel.org>; Tue, 07 Mar 2017 00:47:46 -0800 (PST)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Mon, 6 Mar 2017 22:49:17 -0800
Message-ID: <CAKwzdDptpE_Z7wzS7JOi4057UWABu2Dsik16sc8VovGB3vvi0Q@mail.gmail.com>
Subject: fio output-format=json+ and latency histogram buckets ~1200
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
Can someone please explain what is the detailed latency buckets using
--output-format=json+ depict? The are always ~16 buckets populated. I
am not able to figure out the # iops per latency buckets and what the
units of latency are?

Another question:
For the histogram latency there are ~1200 buckets which can track
16sec for max latency. Can someone please explain what each bucket
interval. e.g. assuming each is 10us increment.
0-10us [#IOPS]
10-20us[#IOPS]
20-30us..[#IOPS]
......
15-16sec
--
Life is too short for silly things so invest your time in some
productive outputs!!
