Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36393 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdBBW36 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Feb 2017 17:29:58 -0500
Received: by mail-lf0-f43.google.com with SMTP id z134so915606lff.3
        for <fio@vger.kernel.org>; Thu, 02 Feb 2017 14:29:58 -0800 (PST)
MIME-Version: 1.0
From: Brandon Schwartz <schwartz.xn@gmail.com>
Date: Thu, 2 Feb 2017 15:29:26 -0700
Message-ID: <CADAGN7VvUH5nQcBK40-x-sizZDchG_kYWH2KvWY0Vt8QxoPU2g@mail.gmail.com>
Subject: NCQ Priority Support and FIO
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

In the latest kernel 4.10 there has been support added for NCQ
Priority commands.  I can test this functionality by using the option
prioclass=1 as in the following FIO script (100% RR) and I can see
that the prio bit is set on the 8k RR commands, but not the 64k RR
(expected).

[global]
direct=1
filename=/dev/sdb
runtime=2m
ioengine=libaio
norandommap

[High-Prio-8kRR-q8]
prioclass=1
iodepth=8
rw=randread
bs=8k

[Low-Prio-64kRR-q8]
prioclass=0
iodepth=8
rw=randread
bs=64k

Would it be possible to add something in FIO that would give finer
control over the split of high priority commands to low priority?
Ideally I would like to be able to test something like:

60% RandomRead / 40% RandomWrite but of those reads, have 15% be high priority

Or is there a way to get this sort of priority testing done with
current FIO?

Regards,
Brandon
