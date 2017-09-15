Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36538 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbdIOIEP (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 15 Sep 2017 04:04:15 -0400
Received: by mail-io0-f193.google.com with SMTP id n69so2976485ioi.3
        for <fio@vger.kernel.org>; Fri, 15 Sep 2017 01:04:15 -0700 (PDT)
MIME-Version: 1.0
From: shawn tim <tontinme@gmail.com>
Date: Fri, 15 Sep 2017 16:04:14 +0800
Message-ID: <CAL3rD49jNs3yH-yNZfmO49YffjSogNtG+GQZq0cch5uzS4nX7A@mail.gmail.com>
Subject: fio rbd engine cannot specify the location of ceph.conf
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

Is the fio rbd engine support clusterconf option?

01:~# fio --enghelp=rbd
clustername             : Cluster name for ceph
rbdname                 : RBD name for RBD engine
pool                    : Name of the pool hosting the RBD for the RBD engine
clientname              : Name of the ceph client to access the RBD
for the RBD engine
busy_poll               : Busy poll for completions instead of sleeping

In my environment, the ceph.conf is not in /etc/ceph/, and clustername
is 'ceph'.
But fio seems failed if there is no /etc/ceph/ceph.conf.
