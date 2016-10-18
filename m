Return-Path: <fio-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:56290 "EHLO
        mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753749AbcJRUbR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2016 16:31:17 -0400
Date: Tue, 18 Oct 2016 16:31:15 -0400 (EDT)
From: Ben England <bengland@redhat.com>
Message-ID: <711335537.3644077.1476822675982.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAOmo8DaQBEc6f0UdK+Ta-S919PzJXg_qe7fEN7UmdL=tH82maA@mail.gmail.com>
References: <CAOmo8DaQBEc6f0UdK+Ta-S919PzJXg_qe7fEN7UmdL=tH82maA@mail.gmail.com>
Subject: Re: Sequential workload with fio
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrzej Jakowski <andrzej.jakowski@gmail.com>
Cc: fio@vger.kernel.org

there is an option "--time_based" that does this, I think. 

fio --runtime=10 --filesize=25M --filename=/tmp/yyy.fio --bs=4k --name=x --rw=write --time_based

----- Original Message -----
> From: "Andrzej Jakowski" <andrzej.jakowski@gmail.com>
> To: fio@vger.kernel.org
> Sent: Tuesday, October 18, 2016 4:07:18 PM
> Subject: Sequential workload with fio
> 
> Question on fio configuration.
> I would like to run seq write workload on raw block device.
> Fio finishes when it reaches end-of-device. Is there a way to force it
> to continue in a circular way till "size" or "runtime" parameter is
> satisfied?
> 
> Thx,
> Andrzej
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
