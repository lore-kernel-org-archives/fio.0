Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:39953 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751325AbeDPG4K (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Apr 2018 02:56:10 -0400
Received: by mail-vk0-f47.google.com with SMTP id x204so8812972vkd.7
        for <fio@vger.kernel.org>; Sun, 15 Apr 2018 23:56:10 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?6ams5bCR5qWg?= <shaonan.ma@gmail.com>
Date: Mon, 16 Apr 2018 14:56:09 +0800
Message-ID: <CAAOwsrdmf4HgJqVnGvz5GU58h-BrpHk1SnckWvYYsje2mOvhFg@mail.gmail.com>
Subject: How to use ceph rados ioengine? How to config rados.job for parallel
 reading and writing?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi List,

I am a beginner, and now I am testing performance of rados of ceph. I
use the ioengine of rados but when I used the example in Github, the
ceph pool is empty as following:

data:
    pools:   1 pools, 100 pgs
    objects: 0 objects, 0 bytes
    usage:   72611 MB used, 349 TB / 349 TB avail
    pgs:     100 active+clean

$ ceph df
GLOBAL:
    SIZE     AVAIL     RAW USED     %RAW USED
    349T      349T       72611M          0.02
POOLS:
    NAME       ID     USED     %USED     MAX AVAIL     OBJECTS
    ecpool     1         0         0          221T           0

And my configure file rados.job is as following:

[global]
ioengine=rados
clientname=admin
pool=ecpool
busy_poll=0
rw=write
bs=4M

[job1]
size=100G
io_size=100G
iodepth=2048

I want to know whether the result that fio got could be considered
effective without any ojbect been written in the pool.

And I want to ask what I need to do if I want to test parallel reading
and write of rados. Should I create N pools in ceph and create N jobs
in fio configure file?

Thanks.

Regards,
Shaonan Ma
