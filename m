Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:50471 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752637AbdIRL36 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Sep 2017 07:29:58 -0400
Received: by mail-ua0-f169.google.com with SMTP id g34so105073uah.7
        for <fio@vger.kernel.org>; Mon, 18 Sep 2017 04:29:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3rD49jNs3yH-yNZfmO49YffjSogNtG+GQZq0cch5uzS4nX7A@mail.gmail.com>
References: <CAL3rD49jNs3yH-yNZfmO49YffjSogNtG+GQZq0cch5uzS4nX7A@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 18 Sep 2017 12:29:27 +0100
Message-ID: <CALjAwxiEN1MRuV5K_zn3sgwpaqCzPcLFsfDV6T4FaxvOja_X8Q@mail.gmail.com>
Subject: Re: fio rbd engine cannot specify the location of ceph.conf
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: shawn tim <tontinme@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 15 September 2017 at 09:04, shawn tim <tontinme@gmail.com> wrote:
>
> Is the fio rbd engine support clusterconf option?
>
> 01:~# fio --enghelp=rbd
> clustername             : Cluster name for ceph
> rbdname                 : RBD name for RBD engine
> pool                    : Name of the pool hosting the RBD for the RBD engine
> clientname              : Name of the ceph client to access the RBD
> for the RBD engine
> busy_poll               : Busy poll for completions instead of sleeping
>
> In my environment, the ceph.conf is not in /etc/ceph/, and clustername
> is 'ceph'.
> But fio seems failed if there is no /etc/ceph/ceph.conf.

Isn't the file used controlled by the $CEPH_CONF environment variable
(http://docs.ceph.com/docs/hammer/rados/configuration/ceph-conf/ )
when you want a non-standard location?

-- 
Sitsofe | http://sucs.org/~sits/
