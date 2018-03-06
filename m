Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:32792 "EHLO
        mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753071AbeCFS7x (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 6 Mar 2018 13:59:53 -0500
Received: from pps.filterd (m0075553.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w26Iws5u006861
        for <fio@vger.kernel.org>; Tue, 6 Mar 2018 13:59:52 -0500
Received: from mail-lf0-f71.google.com (mail-lf0-f71.google.com [209.85.215.71])
        by mx0a-00003501.pphosted.com with ESMTP id 2ghxv0gfqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Tue, 06 Mar 2018 13:59:52 -0500
Received: by mail-lf0-f71.google.com with SMTP id l7so6629731lfg.19
        for <fio@vger.kernel.org>; Tue, 06 Mar 2018 10:59:51 -0800 (PST)
MIME-Version: 1.0
From: Phillip Chen <phillip.a.chen@seagate.com>
Date: Tue, 6 Mar 2018 11:59:08 -0700
Message-ID: <CAODBMz=rOy1kJGVGn3fyCGT78QUK0BH0rzw7cTRMxKZ6sdSF-Q@mail.gmail.com>
Subject: ZBC/FLEX FIO addition ideas
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello again,
We are interested in making changes to the Seagate branch of FIO that
ideally would be widely picked up that would allow FIO to run well on
Host Managed/Zoned Block Command (ZBC) drives. Host Managed drives
have some simple restrictions which make running workloads on them
very challenging. The main hurdles to overcome are all writes must be
at its zone write pointer, all reads must be below its zone write
pointer, and reads or writes can be over more than one zone. The
largest difficulty is to get random performance data. To do this we
will need to add the capability to write randomly between zones (but
sequentially within zones) and only read what has been written. There
seem to be two approaches that could work for this and I'd appreciate
any advice as to which approach to pursue.
Approach 1:
We could let FIO pick I/O offsets as it usually does, but change those
offsets into legal ones before they reach the drive.
Approach 2:
We create a random Host Managed specific workload which will be aware
of where it is legal to read and write and will only pick offsets that
are valid. Additionally, we would later make some small changes to the
existing sequential workloads that would prevent I/O over zone
boundaries and do some preparation (writing over zones we are planning
to read and resetting the write pointers of zones we want to write
over). I am leaning towards this approach because it makes more sense
to me.
Either way, we will need to implement some way of keeping track of
where it is legal to read and write as well as send some new commands
like get zone information and reset write pointer(s). Again, it seems
like there are two viable approaches.
Approach 1:
We can create a new I/O engine which handles all the I/O as well as
any additional ZBC specific commands like get zone information and
resetting write pointers. However, we would like to avoid this option
because our customers to use the I/O engine they are comfortable with.
Approach 2:
We create a layer above the I/O engine which watches all of the I/O
and keeps track of the write pointers on the drive as well as issuing
any additional ZBC commands as necessary.

Thank you,
Phillip Chen
